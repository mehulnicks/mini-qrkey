import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import '../core/theme/qrkey_theme.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';
import '../shared/widgets/premium_upgrade_widgets.dart';

class LiveDashboardScreen extends ConsumerStatefulWidget {
  const LiveDashboardScreen({super.key});

  @override
  ConsumerState<LiveDashboardScreen> createState() => _LiveDashboardScreenState();
}

class _LiveDashboardScreenState extends ConsumerState<LiveDashboardScreen> 
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _chartController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _chartAnimation;
  
  Timer? _refreshTimer;
  bool _isLoading = true;
  
  List<Map<String, dynamic>> _orders = [];
  Map<String, dynamic> _liveData = {};
  List<Map<String, dynamic>> _recentOrders = [];
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadLiveData();
    _startAutoRefresh();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.easeOutCubic),
    );
    
    _pulseController.repeat(reverse: true);
    _chartController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _chartController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadLiveData() async {
    // Check subscription access
    final validation = await SubscriptionService.validateFeatureAccess(
      SubscriptionFeature.analyticsReports
    );
    
    if (!validation.isValid) {
      _showUpgradeDialog();
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      // Load orders from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString('orders');
      
      if (ordersJson != null) {
        final List<dynamic> ordersList = json.decode(ordersJson);
        _orders = List<Map<String, dynamic>>.from(ordersList);
      }
      
      _processLiveData();
      
    } catch (e) {
      print('Error loading live dashboard: $e');
      _loadSampleLiveData();
    }
    
    setState(() => _isLoading = false);
    _chartController.forward();
  }

  void _processLiveData() {
    if (_orders.isEmpty) {
      _loadSampleLiveData();
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeek = now.subtract(Duration(days: now.weekday - 1));
    final thisMonth = DateTime(now.year, now.month, 1);

    // Filter orders for different periods
    final todayOrders = _orders.where((order) {
      try {
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? now.toIso8601String());
        return orderDate.isAfter(today);
      } catch (e) {
        return false;
      }
    }).toList();

    final weekOrders = _orders.where((order) {
      try {
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? now.toIso8601String());
        return orderDate.isAfter(thisWeek);
      } catch (e) {
        return false;
      }
    }).toList();

    final monthOrders = _orders.where((order) {
      try {
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? now.toIso8601String());
        return orderDate.isAfter(thisMonth);
      } catch (e) {
        return false;
      }
    }).toList();

    // Calculate metrics
    final todayRevenue = todayOrders.fold(0.0, (sum, order) => 
        sum + (order['total'] ?? order['totalAmount'] ?? 0).toDouble());
    final weekRevenue = weekOrders.fold(0.0, (sum, order) => 
        sum + (order['total'] ?? order['totalAmount'] ?? 0).toDouble());
    final monthRevenue = monthOrders.fold(0.0, (sum, order) => 
        sum + (order['total'] ?? order['totalAmount'] ?? 0).toDouble());

    // Recent orders (last 10)
    _recentOrders = _orders.take(10).toList();

    // Hourly breakdown for today
    Map<int, double> hourlyRevenue = {};
    Map<int, int> hourlyOrders = {};
    for (var order in todayOrders) {
      try {
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? now.toIso8601String());
        final hour = orderDate.hour;
        hourlyRevenue[hour] = (hourlyRevenue[hour] ?? 0) + (order['total'] ?? 0).toDouble();
        hourlyOrders[hour] = (hourlyOrders[hour] ?? 0) + 1;
      } catch (e) {
        // Skip invalid dates
      }
    }

    // Order status breakdown
    Map<String, int> statusCount = {'pending': 0, 'preparing': 0, 'ready': 0, 'completed': 0};
    for (var order in todayOrders) {
      final status = order['status'] ?? 'completed';
      statusCount[status] = (statusCount[status] ?? 0) + 1;
    }

    // Live metrics calculation
    final avgOrderValue = todayOrders.isNotEmpty ? todayRevenue / todayOrders.length : 0.0;
    final currentHour = now.hour;
    final currentHourRevenue = hourlyRevenue[currentHour] ?? 0.0;
    final currentHourOrders = hourlyOrders[currentHour] ?? 0;

    // Peak hour detection
    final peakHour = hourlyOrders.entries.isNotEmpty 
        ? hourlyOrders.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : currentHour;

    // Generate hourly chart data
    final hourlyChartData = List.generate(24, (index) => {
      'hour': index,
      'revenue': hourlyRevenue[index] ?? 0.0,
      'orders': hourlyOrders[index] ?? 0,
    });

    _liveData = {
      'todayRevenue': todayRevenue,
      'todayOrders': todayOrders.length,
      'weekRevenue': weekRevenue,
      'weekOrders': weekOrders.length,
      'monthRevenue': monthRevenue,
      'monthOrders': monthOrders.length,
      'avgOrderValue': avgOrderValue,
      'currentHourRevenue': currentHourRevenue,
      'currentHourOrders': currentHourOrders,
      'peakHour': peakHour,
      'statusBreakdown': statusCount,
      'hourlyData': hourlyChartData,
      'lastUpdated': DateTime.now(),
      'hasRealData': true,
    };
  }

  void _loadSampleLiveData() {
    final now = DateTime.now();
    final random = Random();
    
    // Generate realistic sample data
    final todayRevenue = 8500.0 + random.nextDouble() * 1500;
    final todayOrders = 35 + random.nextInt(15);
    
    _liveData = {
      'todayRevenue': todayRevenue,
      'todayOrders': todayOrders,
      'weekRevenue': todayRevenue * 6.8,
      'weekOrders': todayOrders * 7,
      'monthRevenue': todayRevenue * 28.5,
      'monthOrders': todayOrders * 30,
      'avgOrderValue': todayRevenue / todayOrders,
      'currentHourRevenue': 450.0 + random.nextDouble() * 200,
      'currentHourOrders': 2 + random.nextInt(4),
      'peakHour': 13,
      'statusBreakdown': {
        'pending': 2 + random.nextInt(3),
        'preparing': 3 + random.nextInt(4),
        'ready': 1 + random.nextInt(2),
        'completed': todayOrders - 10,
      },
      'hourlyData': List.generate(24, (index) => {
        'hour': index,
        'revenue': index >= 11 && index <= 21 
            ? 200.0 + random.nextDouble() * 400 
            : random.nextDouble() * 100,
        'orders': index >= 11 && index <= 21 
            ? 1 + random.nextInt(5) 
            : random.nextInt(2),
      }),
      'lastUpdated': DateTime.now(),
      'hasRealData': false,
    };

    // Generate sample recent orders
    _recentOrders = List.generate(10, (index) {
      final orderTime = now.subtract(Duration(minutes: index * 15 + random.nextInt(30)));
      return {
        'id': 'ORD${1000 + index}',
        'customerName': ['Rahul S.', 'Priya P.', 'Amit K.', 'Sneha M.', 'Vikram T.'][random.nextInt(5)],
        'total': 150.0 + random.nextDouble() * 300,
        'status': ['pending', 'preparing', 'ready', 'completed'][random.nextInt(4)],
        'timestamp': orderTime.toIso8601String(),
        'items': [
          {'name': 'Butter Chicken', 'quantity': 1},
          {'name': 'Naan', 'quantity': 2},
        ],
      };
    });
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _loadLiveData();
      }
    });
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text('Live Dashboard is available with Premium subscription.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to subscription upgrade
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QRKeyTheme.greyBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        title: Row(
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Live Dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          if (_liveData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Updated ${DateFormat('HH:mm').format(_liveData['lastUpdated'])}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLiveData,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Live Metrics Grid
                  _buildLiveMetricsGrid(),
                  const SizedBox(height: 24),
                  
                  // Real-time Chart
                  _buildRealTimeChart(),
                  const SizedBox(height: 24),
                  
                  // Order Status Overview
                  _buildOrderStatusOverview(),
                  const SizedBox(height: 24),
                  
                  // Recent Orders Stream
                  _buildRecentOrdersStream(),
                  
                  if (!(_liveData['hasRealData'] ?? false)) ...[
                    const SizedBox(height: 16),
                    _buildSampleDataNotice(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: QRKeyTheme.primarySaffron.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(QRKeyTheme.primarySaffron),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading Live Dashboard...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: QRKeyTheme.primarySaffron,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Connecting to real-time data',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildLiveMetricCard(
          'Today\'s Revenue',
          '₹${(_liveData['todayRevenue'] ?? 0).toStringAsFixed(0)}',
          Icons.currency_rupee,
          Colors.green,
          '${_liveData['todayOrders'] ?? 0} orders',
          isLive: true,
        ),
        _buildLiveMetricCard(
          'Current Hour',
          '₹${(_liveData['currentHourRevenue'] ?? 0).toStringAsFixed(0)}',
          Icons.access_time,
          Colors.blue,
          '${_liveData['currentHourOrders'] ?? 0} orders',
          isLive: true,
        ),
        _buildLiveMetricCard(
          'Avg Order Value',
          '₹${(_liveData['avgOrderValue'] ?? 0).toStringAsFixed(0)}',
          Icons.shopping_cart,
          QRKeyTheme.primarySaffron,
          'Today\'s average',
        ),
        _buildLiveMetricCard(
          'Peak Hour',
          '${_liveData['peakHour'] ?? 12}:00',
          Icons.trending_up,
          Colors.purple,
          'Busiest time',
        ),
      ],
    );
  }

  Widget _buildLiveMetricCard(String title, String value, IconData icon, Color color, String subtitle, {bool isLive = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Spacer(),
                  if (isLive)
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRealTimeChart() {
    final hourlyData = _liveData['hourlyData'] as List<dynamic>? ?? [];
    final hasRealData = _liveData['hasRealData'] ?? false;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.show_chart, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Today\'s Revenue Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Spacer(),
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'REAL-TIME',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _buildAnimatedChart(hourlyData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedChart(List<dynamic> hourlyData) {
    if (hourlyData.isEmpty) {
      return Center(
        child: Text(
          'No chart data available',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    final maxRevenue = hourlyData.isNotEmpty 
        ? hourlyData.map((e) => e['revenue'] as double).reduce((a, b) => a > b ? a : b)
        : 0.0;

    if (maxRevenue == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, color: Colors.grey.shade400, size: 48),
            const SizedBox(height: 8),
            Text(
              'No revenue data for today',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    final currentHour = DateTime.now().hour;

    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: hourlyData.asMap().entries.map<Widget>((entry) {
              final index = entry.key;
              final data = entry.value;
              final hour = data['hour'] as int;
              final revenue = data['revenue'] as double;
              final orders = data['orders'] as int;
              final height = (revenue / maxRevenue) * 150 * _chartAnimation.value;
              final isCurrentHour = hour == currentHour;
              
              return Container(
                width: 40,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (revenue > 0) ...[
                      Text(
                        '₹${(revenue / 1000).toStringAsFixed(1)}k',
                        style: TextStyle(
                          fontSize: 9,
                          color: isCurrentHour ? Colors.red.shade700 : Colors.green.shade700,
                          fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200 + index * 50),
                      width: isCurrentHour ? 28 : 24,
                      height: height > 0 ? height : 4,
                      decoration: BoxDecoration(
                        color: isCurrentHour 
                            ? Colors.red.shade600 
                            : revenue > 0 
                                ? Colors.green.shade600 
                                : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: isCurrentHour ? [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ] : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${hour.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 10, 
                        fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.w500,
                        color: isCurrentHour ? Colors.red : Colors.black87,
                      ),
                    ),
                    if (orders > 0)
                      Text(
                        '$orders',
                        style: TextStyle(
                          fontSize: 8,
                          color: isCurrentHour ? Colors.red.shade600 : Colors.grey.shade600,
                          fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildOrderStatusOverview() {
    final statusBreakdown = _liveData['statusBreakdown'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.purple, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Order Status Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.purple.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatusCard(
                    'Pending',
                    statusBreakdown['pending'] ?? 0,
                    Icons.schedule,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusCard(
                    'Preparing',
                    statusBreakdown['preparing'] ?? 0,
                    Icons.restaurant,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusCard(
                    'Ready',
                    statusBreakdown['ready'] ?? 0,
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatusCard(
                    'Completed',
                    statusBreakdown['completed'] ?? 0,
                    Icons.done_all,
                    Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersStream() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.stream, color: QRKeyTheme.primarySaffron, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Recent Orders Stream',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_recentOrders.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.inbox, color: Colors.grey.shade400, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No recent orders. Orders will appear here in real-time.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: _recentOrders.take(5).map((order) => _buildOrderStreamItem(order)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStreamItem(Map<String, dynamic> order) {
    final status = order['status'] ?? 'completed';
    final orderTime = DateTime.parse(order['timestamp'] ?? DateTime.now().toIso8601String());
    final timeAgo = _getTimeAgo(orderTime);
    
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case 'preparing':
        statusColor = Colors.blue;
        statusIcon = Icons.restaurant;
        break;
      case 'ready':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.done_all;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(statusIcon, color: statusColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      order['id'] ?? 'ORDER',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  order['customerName'] ?? 'Walk-in Customer',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${(order['total'] ?? 0).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime orderTime) {
    final now = DateTime.now();
    final difference = now.difference(orderTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Widget _buildSampleDataNotice() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.blue.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'This is sample real-time data. Start processing orders to see live dashboard updates!',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
