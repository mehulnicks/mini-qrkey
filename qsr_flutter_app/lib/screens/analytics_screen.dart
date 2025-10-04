import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../core/theme/qrkey_theme.dart';
import '../services/analytics_service.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String _selectedPeriod = 'This Week';

  // Real analytics data from app orders
  Map<String, dynamic> _analyticsData = {};
  List<Map<String, dynamic>> _actualOrders = [];
  Map<String, dynamic> _customerData = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRealAnalytics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRealAnalytics() async {
    setState(() => _isLoading = true);
    
    try {
      // Load actual orders from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString('orders');
      
      if (ordersJson != null) {
        final List<dynamic> ordersList = json.decode(ordersJson);
        _actualOrders = List<Map<String, dynamic>>.from(ordersList);
      }
      
      // Process real data into analytics
      _processRealData();
      
    } catch (e) {
      print('Error loading analytics: $e');
      _loadSampleData(); // Fallback to sample data
    }
    
    setState(() => _isLoading = false);
  }

  void _processRealData() {
    if (_actualOrders.isEmpty) {
      _loadSampleData();
      return;
    }

    // Filter orders based on selected period
    final now = DateTime.now();
    final filteredOrders = _actualOrders.where((order) {
      try {
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? now.toIso8601String());
        switch (_selectedPeriod) {
          case 'Today':
            return orderDate.day == now.day && orderDate.month == now.month && orderDate.year == now.year;
          case 'This Week':
            final weekStart = now.subtract(Duration(days: now.weekday - 1));
            return orderDate.isAfter(weekStart);
          case 'This Month':
            return orderDate.month == now.month && orderDate.year == now.year;
          case 'This Year':
            return orderDate.year == now.year;
          default:
            return true;
        }
      } catch (e) {
        return false;
      }
    }).toList();

    // Calculate metrics from real orders
    double totalRevenue = 0;
    int totalOrders = filteredOrders.length;
    Map<String, int> itemCounts = {};
    Map<String, double> itemRevenue = {};
    Set<String> customers = {};
    Map<String, int> dailyCounts = {'Mon': 0, 'Tue': 0, 'Wed': 0, 'Thu': 0, 'Fri': 0, 'Sat': 0, 'Sun': 0};
    Map<String, double> dailyRevenue = {'Mon': 0, 'Tue': 0, 'Wed': 0, 'Thu': 0, 'Fri': 0, 'Sat': 0, 'Sun': 0};

    for (var order in filteredOrders) {
      try {
        // Extract revenue
        final orderTotal = (order['total'] ?? order['totalAmount'] ?? 0).toDouble();
        totalRevenue += orderTotal;

        // Extract customer info
        final customerName = order['customerName'] ?? '';
        final customerPhone = order['customerPhone'] ?? '';
        if (customerName.isNotEmpty && customerName != 'Walk-in Customer') {
          customers.add('$customerName:$customerPhone');
        }

        // Extract order date for daily breakdown
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? DateTime.now().toIso8601String());
        final dayName = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][orderDate.weekday];
        dailyCounts[dayName] = (dailyCounts[dayName] ?? 0) + 1;
        dailyRevenue[dayName] = (dailyRevenue[dayName] ?? 0) + orderTotal;

        // Extract item data
        final items = order['items'] ?? [];
        for (var item in items) {
          final itemName = item['name'] ?? item['menuItemName'] ?? 'Unknown Item';
          final int quantity = (item['quantity'] ?? 1).toInt();
          final price = (item['price'] ?? item['totalPrice'] ?? 0).toDouble();
          
          final currentCount = itemCounts[itemName] ?? 0;
          itemCounts[itemName] = currentCount + quantity;
          itemRevenue[itemName] = (itemRevenue[itemName] ?? 0) + (price * quantity);
        }
      } catch (e) {
        print('Error processing order: $e');
      }
    }

    // Get top selling items
    final topItems = itemCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topSellingItems = topItems.take(5).map((entry) => {
      'name': entry.key,
      'orders': entry.value,
      'revenue': itemRevenue[entry.key] ?? 0.0,
    }).toList();

    // Build daily revenue chart data
    final dailyRevenueList = dailyRevenue.entries.map((entry) => {
      'day': entry.key,
      'revenue': entry.value,
      'orders': dailyCounts[entry.key] ?? 0,
    }).toList();

    _analyticsData = {
      'totalRevenue': totalRevenue,
      'totalOrders': totalOrders,
      'averageOrderValue': totalOrders > 0 ? totalRevenue / totalOrders : 0.0,
      'topSellingItems': topSellingItems,
      'dailyRevenue': dailyRevenueList,
      'customerStats': {
        'totalCustomers': customers.length,
        'newCustomers': (customers.length * 0.6).round(), // Estimate
        'returningCustomers': (customers.length * 0.4).round(), // Estimate
      },
      'hasRealData': true,
    };

    _customerData = {
      'customers': customers.toList(),
      'totalRevenue': totalRevenue,
      'averageOrderValue': totalOrders > 0 ? totalRevenue / totalOrders : 0.0,
    };
  }

  void _loadSampleData() {
    // Fallback sample data when no real orders exist
    _analyticsData = {
      'totalRevenue': 12450.0,
      'totalOrders': 156,
      'averageOrderValue': 79.81,
      'topSellingItems': [
        {'name': 'Butter Chicken', 'orders': 45, 'revenue': 2250.0},
        {'name': 'Paneer Tikka', 'orders': 38, 'revenue': 1900.0},
        {'name': 'Dal Makhani', 'orders': 32, 'revenue': 1280.0},
      ],
      'dailyRevenue': [
        {'day': 'Mon', 'revenue': 1800.0, 'orders': 23},
        {'day': 'Tue', 'revenue': 2100.0, 'orders': 27},
        {'day': 'Wed', 'revenue': 1650.0, 'orders': 21},
        {'day': 'Thu', 'revenue': 2300.0, 'orders': 29},
        {'day': 'Fri', 'revenue': 2800.0, 'orders': 35},
        {'day': 'Sat', 'revenue': 1800.0, 'orders': 21},
        {'day': 'Sun', 'revenue': 1000.0, 'orders': 15},
      ],
      'customerStats': {
        'newCustomers': 23,
        'returningCustomers': 45,
        'totalCustomers': 68,
      },
      'hasRealData': false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QRKeyTheme.greyBackground,
      body: _isLoading
          ? _buildLoadingState()
          : Column(
              children: [
                _buildAnalyticsHeader(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(),
                      _buildSalesTab(),
                      _buildCustomersTab(),
                    ],
                  ),
                ),
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
              color: QRKeyTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(QRKeyTheme.primaryBlue),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading Analytics...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: QRKeyTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Analyzing your restaurant data',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Business Analytics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() => _selectedPeriod = value);
                      _loadRealAnalytics();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Today', child: Text('Today')),
                      const PopupMenuItem(value: 'This Week', child: Text('This Week')),
                      const PopupMenuItem(value: 'This Month', child: Text('This Month')),
                      const PopupMenuItem(value: 'This Year', child: Text('This Year')),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedPeriod,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: Colors.purple,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Sales'),
              Tab(text: 'Customers'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final hasRealData = _analyticsData['hasRealData'] ?? false;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Business Overview - $_selectedPeriod',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: QRKeyTheme.primaryBlue,
                  ),
                ),
              ),
              if (hasRealData)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Real Data',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info, color: Colors.orange, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Demo Data',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (!hasRealData)
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue.shade600, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Start placing orders in QRKEY System to see real analytics data here!',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          _buildMetricsGrid(),
          const SizedBox(height: 24),
          _buildRevenueChart(),
          const SizedBox(height: 24),
          _buildTopSellingItems(),
        ],
      ),
    );
  }

  Widget _buildSalesTab() {
    final hasRealData = _analyticsData['hasRealData'] ?? false;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Sales Performance - $_selectedPeriod',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: QRKeyTheme.primaryBlue,
                  ),
                ),
              ),
              if (hasRealData)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_actualOrders.length} Orders',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSalesMetrics(),
          const SizedBox(height: 24),
          _buildDailySalesChart(),
          const SizedBox(height: 24),
          _buildSalesTrends(),
        ],
      ),
    );
  }

  Widget _buildCustomersTab() {
    final hasRealData = _analyticsData['hasRealData'] ?? false;
    final customerStats = _analyticsData['customerStats'];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Customer Insights - $_selectedPeriod',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: QRKeyTheme.primaryBlue,
                  ),
                ),
              ),
              if (hasRealData)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${customerStats['totalCustomers']} Customers',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCustomerMetrics(),
          const SizedBox(height: 24),
          _buildCustomerSegmentation(),
          const SizedBox(height: 24),
          _buildCustomerActivity(),
          if (hasRealData) ...[
            const SizedBox(height: 24),
            _buildActualCustomersList(),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMetricCard(
          'Total Revenue',
          '₹${_analyticsData['totalRevenue'].toStringAsFixed(0)}',
          Icons.currency_rupee,
          Colors.green,
          '+12.5%',
        ),
        _buildMetricCard(
          'Total Orders',
          '${_analyticsData['totalOrders']}',
          Icons.receipt_long,
          Colors.blue,
          '+8.3%',
        ),
        _buildMetricCard(
          'Avg Order Value',
          '₹${_analyticsData['averageOrderValue'].toStringAsFixed(0)}',
          Icons.shopping_cart,
          Colors.orange,
          '+5.2%',
        ),
        _buildMetricCard(
          'Customers',
          '${_analyticsData['customerStats']['totalCustomers']}',
          Icons.people,
          Colors.purple,
          '+15.7%',
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, String change) {
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      change,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    final hasRealData = _analyticsData['hasRealData'] ?? false;
    final dailyRevenue = _analyticsData['dailyRevenue'] as List<dynamic>;
    
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
                SizedBox(width: 8),
                Text(
                  'Revenue Trend',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Spacer(),
                if (hasRealData)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Live Data',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: hasRealData && dailyRevenue.any((day) => day['revenue'] > 0)
                  ? _buildRealDataChart()
                  : hasRealData 
                      ? _buildEmptyChart()
                      : _buildSimpleChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealDataChart() {
    final dailyRevenue = _analyticsData['dailyRevenue'] as List<dynamic>;
    final maxRevenue = dailyRevenue.isNotEmpty 
        ? dailyRevenue.map((e) => e['revenue'] as double).reduce((a, b) => a > b ? a : b)
        : 0.0;

    if (maxRevenue == 0) return _buildEmptyChart();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: dailyRevenue.map((data) {
        final revenue = data['revenue'] as double;
        final orders = data['orders'] as int;
        final height = maxRevenue > 0 ? (revenue / maxRevenue) * 150 : 0.0;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (revenue > 0) ...[
              Text(
                '₹${(revenue / 1000).toStringAsFixed(1)}k',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Container(
              width: 32,
              height: height > 0 ? height : 8,
              decoration: BoxDecoration(
                color: revenue > 0 ? Colors.green.shade600 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data['day'],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            if (orders > 0)
              Text(
                '$orders',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade600,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, color: Colors.grey.shade400, size: 48),
            SizedBox(height: 8),
            Text(
              'No Revenue Data',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Start processing orders to see trends',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleChart() {
    final dailyRevenue = _analyticsData['dailyRevenue'] as List<dynamic>;
    final maxRevenue = dailyRevenue.map((e) => e['revenue'] as double).reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: dailyRevenue.map((data) {
        final revenue = data['revenue'] as double;
        final height = (revenue / maxRevenue) * 150;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '₹${(revenue / 1000).toStringAsFixed(1)}k',
              style: const TextStyle(fontSize: 10),
            ),
            const SizedBox(height: 4),
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(
                color: Colors.purple.shade600,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data['day'],
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTopSellingItems() {
    final topItems = _analyticsData['topSellingItems'] as List<dynamic>;
    final hasRealData = _analyticsData['hasRealData'] ?? false;
    
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
                Icon(Icons.trending_up, color: QRKeyTheme.primaryBlue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Top Selling Items',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: QRKeyTheme.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (topItems.isEmpty && hasRealData)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.inbox, color: Colors.grey.shade400, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No items found for this period. Start taking orders to see data here!',
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
              ...topItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: index < 3 ? [Colors.amber, Colors.grey, Colors.orange][index] : QRKeyTheme.primaryBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
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
                              '${item['orders']} orders sold',
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
                            '₹${item['revenue'].toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '₹${(item['revenue'] / item['orders']).toStringAsFixed(0)}/unit',
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
    );
  }

  Widget _buildSalesMetrics() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Sales Growth',
            '+12.5%',
            Icons.trending_up,
            Colors.green,
            'vs last period',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Best Day',
            'Friday',
            Icons.calendar_today,
            Colors.blue,
            '₹2,800',
          ),
        ),
      ],
    );
  }

  Widget _buildDailySalesChart() {
    final hasRealData = _analyticsData['hasRealData'] ?? false;
    final dailyRevenue = _analyticsData['dailyRevenue'] as List<dynamic>;
    
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
                Icon(Icons.bar_chart, color: QRKeyTheme.primaryBlue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Daily Sales Breakdown',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: QRKeyTheme.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (hasRealData && dailyRevenue.any((day) => day['revenue'] > 0)) ...[
              ...dailyRevenue.map((data) {
                final revenue = data['revenue'] as double;
                final orders = data['orders'] as int;
                final maxRevenue = dailyRevenue.map((d) => d['revenue'] as double).reduce((a, b) => a > b ? a : b);
                final progress = maxRevenue > 0 ? revenue / maxRevenue : 0.0;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(
                              data['day'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation(
                                revenue > 0 ? QRKeyTheme.primaryBlue : Colors.grey.shade300,
                              ),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 80,
                            child: Text(
                              revenue > 0 ? '₹${revenue.toStringAsFixed(0)}' : 'No sales',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: revenue > 0 ? Colors.black87 : Colors.grey.shade500,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      if (orders > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 50, top: 2),
                          child: Row(
                            children: [
                              Text(
                                '$orders order${orders != 1 ? 's' : ''}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ] else if (hasRealData) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timeline, color: Colors.blue.shade300, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No sales data for this period. Daily breakdown will appear as you process orders.',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ...dailyRevenue.map((data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          data['day'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (data['revenue'] as double) / 3000,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(Colors.purple.shade600),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('₹${data['revenue'].toStringAsFixed(0)}'),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTrends() {
    final hasRealData = _analyticsData['hasRealData'] ?? false;
    final totalOrders = _analyticsData['totalOrders'] ?? 0;
    final totalRevenue = _analyticsData['totalRevenue'] ?? 0.0;
    final avgOrderValue = _analyticsData['averageOrderValue'] ?? 0.0;
    
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
                Icon(Icons.insights, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  'Sales Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (hasRealData && totalOrders > 0) ...[
              _buildInsightItem('📊', 'You have processed $totalOrders orders in this period'),
              _buildInsightItem('�', 'Average order value is ₹${avgOrderValue.toStringAsFixed(0)}'),
              _buildInsightItem('🎯', 'Total revenue generated: ₹${totalRevenue.toStringAsFixed(0)}'),
              if (totalRevenue > 1000)
                _buildInsightItem('�🔥', 'Great performance! Revenue exceeded ₹1,000'),
              if (avgOrderValue > 100)
                _buildInsightItem('⭐', 'Excellent! High-value orders averaging ₹${avgOrderValue.toStringAsFixed(0)}'),
            ] else if (hasRealData) ...[
              _buildInsightItem('📈', 'No orders found for this period'),
              _buildInsightItem('💡', 'Start taking orders to see valuable insights here'),
              _buildInsightItem('🎯', 'Your analytics will improve as you process more orders'),
            ] else ...[
              _buildInsightItem('🔥', 'Peak hours: 7-9 PM generates 40% of daily revenue'),
              _buildInsightItem('📈', 'Weekend sales are 25% higher than weekdays'),
              _buildInsightItem('🎯', 'Online orders increased by 18% this week'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerMetrics() {
    final customerStats = _analyticsData['customerStats'];
    
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'New Customers',
            '${customerStats['newCustomers']}',
            Icons.person_add,
            Colors.green,
            '+34%',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Returning',
            '${customerStats['returningCustomers']}',
            Icons.repeat,
            Colors.blue,
            '+8%',
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSegmentation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Segmentation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSegmentItem('New Customers', 23, 68, Colors.green),
            _buildSegmentItem('Returning Customers', 45, 68, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentItem(String label, int count, int total, Color color) {
    final percentage = (count / total * 100).round();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('$count ($percentage%)'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: count / total,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerActivity() {
    final hasRealData = _analyticsData['hasRealData'] ?? false;
    final customerStats = _analyticsData['customerStats'];
    final totalCustomers = customerStats['totalCustomers'] ?? 0;
    final avgOrderValue = _analyticsData['averageOrderValue'] ?? 0.0;
    
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
                Icon(Icons.psychology, color: Colors.teal, size: 20),
                SizedBox(width: 8),
                Text(
                  'Customer Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (hasRealData && totalCustomers > 0) ...[
              _buildInsightItem('👥', 'You have served $totalCustomers unique customers'),
              _buildInsightItem('💰', 'Average spending per customer: ₹${avgOrderValue.toStringAsFixed(0)}'),
              if (totalCustomers > 10)
                _buildInsightItem('🎉', 'Great job! You have a growing customer base'),
              if (avgOrderValue > 150)
                _buildInsightItem('⭐', 'Your customers love high-value orders!'),
            ] else if (hasRealData) ...[
              _buildInsightItem('👋', 'No customer data for this period'),
              _buildInsightItem('📱', 'Customer insights will appear as you serve more customers'),
              _buildInsightItem('💡', 'Add customer names in orders to track customer analytics'),
            ] else ...[
              _buildInsightItem('👥', 'Average customer visits 2.3 times per week'),
              _buildInsightItem('💰', 'Top 20% customers contribute 45% of revenue'),
              _buildInsightItem('⭐', 'Customer satisfaction rate: 4.6/5'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActualCustomersList() {
    final customers = _customerData['customers'] as List? ?? [];
    
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
                Icon(Icons.people, color: Colors.purple, size: 20),
                SizedBox(width: 8),
                Text(
                  'Recent Customers',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (customers.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_add, color: Colors.purple.shade300, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No customer data available. Customer names will appear here as you process orders.',
                        style: TextStyle(
                          color: Colors.purple.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...customers.take(10).map((customer) {
                final parts = customer.split(':');
                final name = parts.isNotEmpty ? parts[0] : 'Unknown';
                final phone = parts.length > 1 ? parts[1] : '';
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.purple.withOpacity(0.1),
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'U',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            if (phone.isNotEmpty)
                              Text(
                                phone,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.verified_user,
                        color: Colors.green,
                        size: 16,
                      ),
                    ],
                  ),
                );
              }).toList(),
            if (customers.length > 10)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: Text(
                    '+ ${customers.length - 10} more customers',
                    style: TextStyle(
                      color: Colors.purple.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
