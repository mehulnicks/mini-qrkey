import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import '../core/theme/qrkey_theme.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';
import '../shared/widgets/premium_upgrade_widgets.dart';

class BusinessInsightsScreen extends ConsumerStatefulWidget {
  const BusinessInsightsScreen({super.key});

  @override
  ConsumerState<BusinessInsightsScreen> createState() => _BusinessInsightsScreenState();
}

class _BusinessInsightsScreenState extends ConsumerState<BusinessInsightsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  
  List<Map<String, dynamic>> _orders = [];
  Map<String, dynamic> _insightsData = {};
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadInsightsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInsightsData() async {
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
      
      _processInsightsData();
      
    } catch (e) {
      print('Error loading business insights: $e');
      _loadSampleInsightsData();
    }
    
    setState(() => _isLoading = false);
  }

  void _processInsightsData() {
    if (_orders.isEmpty) {
      _loadSampleInsightsData();
      return;
    }

    // Calculate comprehensive business insights
    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));
    final last7Days = now.subtract(const Duration(days: 7));
    
    // Filter orders by periods
    final ordersLast30Days = _orders.where((order) {
      try {
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? now.toIso8601String());
        return orderDate.isAfter(last30Days);
      } catch (e) {
        return false;
      }
    }).toList();

    final ordersLast7Days = _orders.where((order) {
      try {
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? now.toIso8601String());
        return orderDate.isAfter(last7Days);
      } catch (e) {
        return false;
      }
    }).toList();

    // Calculate key metrics
    final revenue30Days = ordersLast30Days.fold(0.0, (sum, order) => 
        sum + (order['total'] ?? order['totalAmount'] ?? 0).toDouble());
    final revenue7Days = ordersLast7Days.fold(0.0, (sum, order) => 
        sum + (order['total'] ?? order['totalAmount'] ?? 0).toDouble());
    
    final avgOrderValue30Days = ordersLast30Days.isNotEmpty 
        ? revenue30Days / ordersLast30Days.length 
        : 0.0;
    final avgOrderValue7Days = ordersLast7Days.isNotEmpty 
        ? revenue7Days / ordersLast7Days.length 
        : 0.0;

    // Peak hours analysis
    Map<int, int> hourlyOrders = {};
    Map<int, double> hourlyRevenue = {};
    for (var order in ordersLast30Days) {
      try {
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? now.toIso8601String());
        final hour = orderDate.hour;
        hourlyOrders[hour] = (hourlyOrders[hour] ?? 0) + 1;
        hourlyRevenue[hour] = (hourlyRevenue[hour] ?? 0) + (order['total'] ?? 0).toDouble();
      } catch (e) {
        // Skip invalid dates
      }
    }

    // Find peak hours
    final peakHour = hourlyOrders.entries.isNotEmpty 
        ? hourlyOrders.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 12;

    // Customer analysis
    Set<String> uniqueCustomers30Days = {};
    Set<String> uniqueCustomers7Days = {};
    Map<String, List<Map<String, dynamic>>> customerOrders = {};

    for (var order in ordersLast30Days) {
      final customerKey = '${order['customerName'] ?? 'Walk-in'}:${order['customerPhone'] ?? ''}';
      if (order['customerName'] != null && order['customerName'] != 'Walk-in Customer') {
        uniqueCustomers30Days.add(customerKey);
        customerOrders[customerKey] = customerOrders[customerKey] ?? [];
        customerOrders[customerKey]!.add(order);
      }
    }

    for (var order in ordersLast7Days) {
      final customerKey = '${order['customerName'] ?? 'Walk-in'}:${order['customerPhone'] ?? ''}';
      if (order['customerName'] != null && order['customerName'] != 'Walk-in Customer') {
        uniqueCustomers7Days.add(customerKey);
      }
    }

    // Repeat customer analysis
    final repeatCustomers = customerOrders.entries.where((entry) => entry.value.length > 1).toList();
    final customerRetentionRate = uniqueCustomers30Days.isNotEmpty 
        ? (repeatCustomers.length / uniqueCustomers30Days.length * 100)
        : 0.0;

    // Item popularity trends
    Map<String, int> itemPopularity = {};
    Map<String, double> itemRevenue = {};
    for (var order in ordersLast30Days) {
      final items = order['items'] ?? [];
      for (var item in items) {
        final itemName = item['name'] ?? item['menuItemName'] ?? 'Unknown';
                  final quantity = ((item['quantity'] ?? 1) as num).toInt();
        final price = (item['price'] ?? item['totalPrice'] ?? 0).toDouble();
        
        itemPopularity[itemName] = (itemPopularity[itemName] ?? 0) + quantity;
        itemRevenue[itemName] = (itemRevenue[itemName] ?? 0) + (price * quantity);
      }
    }

    // Growth trends
    final revenueGrowth = revenue7Days > 0 && ordersLast30Days.length > 7 
        ? ((revenue7Days / 7) / ((revenue30Days - revenue7Days) / 23) - 1) * 100
        : 0.0;

    final orderGrowth = ordersLast7Days.isNotEmpty && ordersLast30Days.length > 7
        ? ((ordersLast7Days.length / 7) / ((ordersLast30Days.length - ordersLast7Days.length) / 23) - 1) * 100
        : 0.0;

    // Performance insights
    List<Map<String, dynamic>> insights = [];
    
    if (revenue30Days > 0) {
      insights.add({
        'icon': '💰',
        'title': 'Revenue Performance',
        'description': 'Generated ₹${revenue30Days.toStringAsFixed(0)} in last 30 days',
        'type': 'positive',
      });
    }

    if (peakHour >= 11 && peakHour <= 14) {
      insights.add({
        'icon': '🍽️',
        'title': 'Lunch Rush Identified',
        'description': 'Peak orders occur at ${peakHour}:00 - optimize staffing',
        'type': 'info',
      });
    }

    if (customerRetentionRate > 30) {
      insights.add({
        'icon': '🎯',
        'title': 'Strong Customer Loyalty',
        'description': '${customerRetentionRate.toStringAsFixed(1)}% customers return for repeat orders',
        'type': 'positive',
      });
    }

    if (avgOrderValue30Days > 150) {
      insights.add({
        'icon': '⭐',
        'title': 'High-Value Orders',
        'description': 'Average order value: ₹${avgOrderValue30Days.toStringAsFixed(0)}',
        'type': 'positive',
      });
    }

    if (revenueGrowth > 10) {
      insights.add({
        'icon': '📈',
        'title': 'Growing Business',
        'description': 'Revenue increased by ${revenueGrowth.toStringAsFixed(1)}% this week',
        'type': 'positive',
      });
    } else if (revenueGrowth < -10) {
      insights.add({
        'icon': '📉',
        'title': 'Revenue Decline',
        'description': 'Revenue decreased by ${(-revenueGrowth).toStringAsFixed(1)}% - focus on promotions',
        'type': 'warning',
      });
    }

    // Top performing items
    final topItems = itemPopularity.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _insightsData = {
      'revenue30Days': revenue30Days,
      'revenue7Days': revenue7Days,
      'orders30Days': ordersLast30Days.length,
      'orders7Days': ordersLast7Days.length,
      'avgOrderValue30Days': avgOrderValue30Days,
      'avgOrderValue7Days': avgOrderValue7Days,
      'revenueGrowth': revenueGrowth,
      'orderGrowth': orderGrowth,
      'peakHour': peakHour,
      'uniqueCustomers30Days': uniqueCustomers30Days.length,
      'uniqueCustomers7Days': uniqueCustomers7Days.length,
      'customerRetentionRate': customerRetentionRate,
      'repeatCustomers': repeatCustomers.length,
      'topItems': topItems.take(5).map((e) => {
        'name': e.key,
        'quantity': e.value,
        'revenue': itemRevenue[e.key] ?? 0.0,
      }).toList(),
      'insights': insights,
      'hourlyData': hourlyOrders.entries.map((e) => {
        'hour': e.key,
        'orders': e.value,
        'revenue': hourlyRevenue[e.key] ?? 0.0,
      }).toList()..sort((a, b) => (a['hour'] as int).compareTo(b['hour'] as int)),
      'hasRealData': true,
    };
  }

  void _loadSampleInsightsData() {
    _insightsData = {
      'revenue30Days': 145670.0,
      'revenue7Days': 34200.0,
      'orders30Days': 487,
      'orders7Days': 115,
      'avgOrderValue30Days': 299.1,
      'avgOrderValue7Days': 297.4,
      'revenueGrowth': 12.5,
      'orderGrowth': 8.7,
      'peakHour': 13,
      'uniqueCustomers30Days': 234,
      'uniqueCustomers7Days': 67,
      'customerRetentionRate': 42.3,
      'repeatCustomers': 99,
      'topItems': [
        {'name': 'Butter Chicken', 'quantity': 85, 'revenue': 4250.0},
        {'name': 'Paneer Tikka', 'quantity': 72, 'revenue': 3600.0},
        {'name': 'Dal Makhani', 'quantity': 68, 'revenue': 2720.0},
        {'name': 'Naan', 'quantity': 145, 'revenue': 2175.0},
        {'name': 'Biryani', 'quantity': 43, 'revenue': 3225.0},
      ],
      'insights': [
        {
          'icon': '💰',
          'title': 'Strong Revenue Performance',
          'description': 'Generated ₹145,670 in last 30 days with consistent growth',
          'type': 'positive',
        },
        {
          'icon': '🍽️',
          'title': 'Lunch Rush Peak',
          'description': 'Highest orders at 1:00 PM - consider lunch specials',
          'type': 'info',
        },
        {
          'icon': '🎯',
          'title': 'Excellent Customer Loyalty',
          'description': '42.3% customers return for repeat orders',
          'type': 'positive',
        },
        {
          'icon': '📈',
          'title': 'Growing Business',
          'description': 'Revenue increased by 12.5% this week',
          'type': 'positive',
        },
      ],
      'hourlyData': [
        {'hour': 11, 'orders': 12, 'revenue': 2400.0},
        {'hour': 12, 'orders': 18, 'revenue': 3600.0},
        {'hour': 13, 'orders': 25, 'revenue': 5000.0},
        {'hour': 14, 'orders': 15, 'revenue': 3000.0},
        {'hour': 19, 'orders': 22, 'revenue': 4400.0},
        {'hour': 20, 'orders': 20, 'revenue': 4000.0},
        {'hour': 21, 'orders': 16, 'revenue': 3200.0},
      ],
      'hasRealData': false,
    };
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text('Business Insights are available with Premium subscription.'),
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
        title: const Text(
          'Business Insights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInsightsData,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: QRKeyTheme.primarySaffron,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: QRKeyTheme.primarySaffron,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Performance'),
            Tab(text: 'Trends'),
            Tab(text: 'Predictions'),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildPerformanceTab(),
                _buildTrendsTab(),
                _buildPredictionsTab(),
              ],
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
            'Analyzing Business Data...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: QRKeyTheme.primarySaffron,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generating intelligent insights',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final hasRealData = _insightsData['hasRealData'] ?? false;
    final insights = _insightsData['insights'] as List<dynamic>? ?? [];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics Summary
          _buildMetricsSummary(),
          const SizedBox(height: 24),
          
          // AI Insights
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: QRKeyTheme.primarySaffron.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.psychology,
                          color: QRKeyTheme.primarySaffron,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'AI-Powered Insights',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (hasRealData)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Live Analysis',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (insights.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.blue.shade300, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Insights will appear as you process more orders and gather business data.',
                              style: TextStyle(
                                color: Colors.blue.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...insights.map((insight) => _buildInsightItem(insight)).toList(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Quick Actions
          _buildQuickActions(),
          
          if (!hasRealData) ...[
            const SizedBox(height: 16),
            _buildSampleDataNotice(),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricsSummary() {
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
                Icon(Icons.dashboard, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Business Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildSummaryCard(
                  'Monthly Revenue',
                  '₹${(_insightsData['revenue30Days'] ?? 0).toStringAsFixed(0)}',
                  Icons.trending_up,
                  Colors.green,
                  '${(_insightsData['revenueGrowth'] ?? 0) >= 0 ? '+' : ''}${(_insightsData['revenueGrowth'] ?? 0).toStringAsFixed(1)}%',
                ),
                _buildSummaryCard(
                  'Total Orders',
                  '${_insightsData['orders30Days'] ?? 0}',
                  Icons.receipt_long,
                  Colors.blue,
                  '${(_insightsData['orderGrowth'] ?? 0) >= 0 ? '+' : ''}${(_insightsData['orderGrowth'] ?? 0).toStringAsFixed(1)}%',
                ),
                _buildSummaryCard(
                  'Avg Order Value',
                  '₹${(_insightsData['avgOrderValue30Days'] ?? 0).toStringAsFixed(0)}',
                  Icons.shopping_cart,
                  QRKeyTheme.primarySaffron,
                  'Last 30 days',
                ),
                _buildSummaryCard(
                  'Repeat Customers',
                  '${_insightsData['repeatCustomers'] ?? 0}',
                  Icons.people,
                  Colors.purple,
                  '${(_insightsData['customerRetentionRate'] ?? 0).toStringAsFixed(1)}% retention',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
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
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(Map<String, dynamic> insight) {
    final type = insight['type'] as String;
    Color cardColor;
    Color iconColor;
    
    switch (type) {
      case 'positive':
        cardColor = Colors.green.shade50;
        iconColor = Colors.green;
        break;
      case 'warning':
        cardColor = Colors.orange.shade50;
        iconColor = Colors.orange;
        break;
      case 'info':
        cardColor = Colors.blue.shade50;
        iconColor = Colors.blue;
        break;
      default:
        cardColor = Colors.grey.shade50;
        iconColor = Colors.grey;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(
            insight['icon'],
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
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
                Icon(Icons.flash_on, color: QRKeyTheme.primarySaffron, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildActionButton(
                  'View Sales Report',
                  Icons.bar_chart,
                  Colors.green,
                  () => _navigateToSalesReport(),
                ),
                _buildActionButton(
                  'Live Dashboard',
                  Icons.dashboard,
                  Colors.blue,
                  () => _navigateToLiveDashboard(),
                ),
                _buildActionButton(
                  'Peak Hours',
                  Icons.schedule,
                  Colors.orange,
                  () => _showPeakHours(),
                ),
                _buildActionButton(
                  'Top Items',
                  Icons.star,
                  Colors.purple,
                  () => _showTopItems(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTab() {
    final topItems = _insightsData['topItems'] as List<dynamic>? ?? [];
    final peakHour = _insightsData['peakHour'] ?? 12;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Analysis',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: QRKeyTheme.primarySaffron,
            ),
          ),
          const SizedBox(height: 16),
          
          // Peak Hours Analysis
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Peak Hours Analysis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildHourlyChart(),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Peak hour: ${peakHour}:00 - Consider staffing optimization and special offers during this time.',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Top Performing Items
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: QRKeyTheme.primarySaffron, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Top Performing Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (topItems.isEmpty)
                    Center(
                      child: Text(
                        'No item data available',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  else
                    ...topItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final colors = [Colors.amber, Colors.grey, Colors.orange, QRKeyTheme.primarySaffron, Colors.purple];
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors[index % colors.length].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors[index % colors.length].withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: colors[index % colors.length],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    '${item['quantity']} units sold',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
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
                                  '₹${(item['revenue'] as double).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  '₹${((item['revenue'] as double) / (item['quantity'] as int)).toStringAsFixed(0)}/unit',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyChart() {
    final hourlyData = _insightsData['hourlyData'] as List<dynamic>? ?? [];
    
    if (hourlyData.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'No hourly data available',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    final maxOrders = hourlyData.isNotEmpty 
        ? hourlyData.map((e) => e['orders'] as int).reduce((a, b) => a > b ? a : b)
        : 0;

    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: hourlyData.map<Widget>((data) {
            final hour = data['hour'] as int;
            final orders = data['orders'] as int;
            final revenue = data['revenue'] as double;
            final height = maxOrders > 0 ? (orders / maxOrders) * 150 : 0.0;
            
            return Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (orders > 0) ...[
                    Text(
                      '$orders',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Container(
                    width: 24,
                    height: height > 0 ? height : 8,
                    decoration: BoxDecoration(
                      color: orders > 0 ? Colors.orange.shade600 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${hour}:00',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                  if (revenue > 0)
                    Text(
                      '₹${(revenue / 1000).toStringAsFixed(1)}k',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Trends',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: QRKeyTheme.primarySaffron,
            ),
          ),
          const SizedBox(height: 16),
          
          // Growth Metrics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Growth Metrics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTrendCard(
                          'Revenue Growth',
                          '${(_insightsData['revenueGrowth'] ?? 0) >= 0 ? '+' : ''}${(_insightsData['revenueGrowth'] ?? 0).toStringAsFixed(1)}%',
                          (_insightsData['revenueGrowth'] ?? 0) >= 0 ? Colors.green : Colors.red,
                          'This week vs last 3 weeks avg',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTrendCard(
                          'Order Growth',
                          '${(_insightsData['orderGrowth'] ?? 0) >= 0 ? '+' : ''}${(_insightsData['orderGrowth'] ?? 0).toStringAsFixed(1)}%',
                          (_insightsData['orderGrowth'] ?? 0) >= 0 ? Colors.green : Colors.red,
                          'Weekly order volume change',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Customer Insights
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people, color: Colors.purple, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Customer Trends',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCustomerMetricsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard(String title, String value, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildCustomerMetric(
          'Total Customers',
          '${_insightsData['uniqueCustomers30Days'] ?? 0}',
          Icons.group,
          Colors.blue,
        ),
        _buildCustomerMetric(
          'Retention Rate',
          '${(_insightsData['customerRetentionRate'] ?? 0).toStringAsFixed(1)}%',
          Icons.repeat,
          Colors.green,
        ),
        _buildCustomerMetric(
          'New This Week',
          '${_insightsData['uniqueCustomers7Days'] ?? 0}',
          Icons.person_add,
          Colors.orange,
        ),
        _buildCustomerMetric(
          'Repeat Customers',
          '${_insightsData['repeatCustomers'] ?? 0}',
          Icons.star,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildCustomerMetric(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
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
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Predictions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: QRKeyTheme.primarySaffron,
            ),
          ),
          const SizedBox(height: 16),
          
          // Revenue Predictions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Revenue Forecast',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPredictionCards(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Recommendations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.recommend, color: QRKeyTheme.primarySaffron, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'AI Recommendations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendations(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCards() {
    final currentRevenue = _insightsData['revenue30Days'] ?? 0.0;
    final growthRate = _insightsData['revenueGrowth'] ?? 0.0;
    
    final nextWeekPrediction = currentRevenue * (1 + (growthRate / 100)) * (7 / 30);
    final nextMonthPrediction = currentRevenue * (1 + (growthRate / 100));
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildPredictionCard(
                'Next Week',
                '₹${nextWeekPrediction.toStringAsFixed(0)}',
                growthRate >= 0 ? Icons.trending_up : Icons.trending_down,
                growthRate >= 0 ? Colors.green : Colors.red,
                'Estimated revenue',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPredictionCard(
                'Next Month',
                '₹${nextMonthPrediction.toStringAsFixed(0)}',
                growthRate >= 0 ? Icons.trending_up : Icons.trending_down,
                growthRate >= 0 ? Colors.green : Colors.red,
                'Projected revenue',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Predictions are based on current trends and may vary based on external factors.',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    final hasRealData = _insightsData['hasRealData'] ?? false;
    final avgOrderValue = _insightsData['avgOrderValue30Days'] ?? 0.0;
    final retentionRate = _insightsData['customerRetentionRate'] ?? 0.0;
    final revenueGrowth = _insightsData['revenueGrowth'] ?? 0.0;
    
    List<Map<String, dynamic>> recommendations = [];
    
    if (hasRealData) {
      if (avgOrderValue < 200) {
        recommendations.add({
          'icon': '🎯',
          'title': 'Increase Average Order Value',
          'description': 'Consider combo meals or upselling to increase AOV from ₹${avgOrderValue.toStringAsFixed(0)}',
          'priority': 'high',
        });
      }
      
      if (retentionRate < 40) {
        recommendations.add({
          'icon': '💡',
          'title': 'Improve Customer Retention',
          'description': 'Launch loyalty program to increase retention rate from ${retentionRate.toStringAsFixed(1)}%',
          'priority': 'medium',
        });
      }
      
      if (revenueGrowth < 0) {
        recommendations.add({
          'icon': '📈',
          'title': 'Revenue Recovery Plan',
          'description': 'Consider promotional campaigns to reverse negative growth trend',
          'priority': 'high',
        });
      }
      
      if (recommendations.isEmpty) {
        recommendations.add({
          'icon': '🌟',
          'title': 'Excellent Performance',
          'description': 'Your business metrics are strong. Focus on maintaining quality and scaling.',
          'priority': 'low',
        });
      }
    } else {
      recommendations = [
        {
          'icon': '📊',
          'title': 'Start Data Collection',
          'description': 'Process more orders to get personalized AI recommendations',
          'priority': 'high',
        },
        {
          'icon': '🎯',
          'title': 'Track Customer Data',
          'description': 'Collect customer names and phone numbers for better insights',
          'priority': 'medium',
        },
        {
          'icon': '💡',
          'title': 'Monitor Peak Hours',
          'description': 'Identify busy periods to optimize staffing and inventory',
          'priority': 'medium',
        },
      ];
    }
    
    return Column(
      children: recommendations.map((rec) => _buildRecommendationItem(rec)).toList(),
    );
  }

  Widget _buildRecommendationItem(Map<String, dynamic> recommendation) {
    final priority = recommendation['priority'] as String;
    Color cardColor;
    Color borderColor;
    
    switch (priority) {
      case 'high':
        cardColor = Colors.red.shade50;
        borderColor = Colors.red;
        break;
      case 'medium':
        cardColor = Colors.orange.shade50;
        borderColor = Colors.orange;
        break;
      default:
        cardColor = Colors.green.shade50;
        borderColor = Colors.green;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(
            recommendation['icon'],
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      recommendation['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: borderColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: borderColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        priority.toUpperCase(),
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: borderColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  recommendation['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: borderColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                'This is sample data. Start processing orders to see real business insights!',
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

  void _navigateToSalesReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening Sales Reports...'),
        backgroundColor: QRKeyTheme.primarySaffron,
      ),
    );
  }

  void _navigateToLiveDashboard() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening Live Dashboard...'),
        backgroundColor: QRKeyTheme.primarySaffron,
      ),
    );
  }

  void _showPeakHours() {
    final peakHour = _insightsData['peakHour'] ?? 12;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Peak Hours'),
        content: Text('Your busiest hour is ${peakHour}:00. Consider optimizing staffing and inventory during this time.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTopItems() {
    final topItems = _insightsData['topItems'] as List<dynamic>? ?? [];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Top Selling Items'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: topItems.take(3).map((item) => ListTile(
            title: Text(item['name']),
            subtitle: Text('${item['quantity']} units sold'),
            trailing: Text('₹${(item['revenue'] as double).toStringAsFixed(0)}'),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
