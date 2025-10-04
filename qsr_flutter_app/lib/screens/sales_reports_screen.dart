import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../core/theme/qrkey_theme.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';
import '../shared/widgets/premium_upgrade_widgets.dart';

class SalesReportsScreen extends ConsumerStatefulWidget {
  const SalesReportsScreen({super.key});

  @override
  ConsumerState<SalesReportsScreen> createState() => _SalesReportsScreenState();
}

class _SalesReportsScreenState extends ConsumerState<SalesReportsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  
  List<Map<String, dynamic>> _orders = [];
  Map<String, dynamic> _reportData = {};
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadReportData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReportData() async {
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
      
      _processReportData();
      
    } catch (e) {
      print('Error loading sales reports: $e');
      _loadSampleReportData();
    }
    
    setState(() => _isLoading = false);
  }

  void _processReportData() {
    if (_orders.isEmpty) {
      _loadSampleReportData();
      return;
    }

    // Filter orders by date range
    final filteredOrders = _orders.where((order) {
      try {
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? DateTime.now().toIso8601String());
        return orderDate.isAfter(_startDate.subtract(const Duration(days: 1))) && 
               orderDate.isBefore(_endDate.add(const Duration(days: 1)));
      } catch (e) {
        return false;
      }
    }).toList();

    // Calculate comprehensive metrics
    double totalRevenue = 0;
    double totalDiscounts = 0;
    double totalTax = 0;
    int totalOrders = filteredOrders.length;
    Map<String, double> dailyRevenue = {};
    Map<String, int> dailyOrders = {};
    Map<String, double> categoryRevenue = {};
    Map<String, int> paymentMethods = {};
    Map<String, double> hourlyRevenue = {};
    Map<String, int> itemsSold = {};
    List<Map<String, dynamic>> topCustomers = [];

    for (var order in filteredOrders) {
      try {
        final orderTotal = (order['total'] ?? order['totalAmount'] ?? 0).toDouble();
        final discount = (order['discount'] ?? 0).toDouble();
        final tax = (order['tax'] ?? order['gst'] ?? 0).toDouble();
        
        totalRevenue += orderTotal;
        totalDiscounts += discount;
        totalTax += tax;

        // Daily breakdown
        final orderDate = DateTime.parse(order['timestamp'] ?? order['createdAt'] ?? DateTime.now().toIso8601String());
        final dateKey = DateFormat('yyyy-MM-dd').format(orderDate);
        dailyRevenue[dateKey] = (dailyRevenue[dateKey] ?? 0) + orderTotal;
        dailyOrders[dateKey] = (dailyOrders[dateKey] ?? 0) + 1;

        // Hourly breakdown
        final hour = '${orderDate.hour}:00';
        hourlyRevenue[hour] = (hourlyRevenue[hour] ?? 0) + orderTotal;

        // Payment methods
        final paymentMethod = order['paymentMethod'] ?? 'Cash';
        paymentMethods[paymentMethod] = (paymentMethods[paymentMethod] ?? 0) + 1;

        // Items analysis
        final items = order['items'] ?? [];
        for (var item in items) {
          final itemName = item['name'] ?? item['menuItemName'] ?? 'Unknown';
          final category = item['category'] ?? 'Other';
          final quantity = ((item['quantity'] ?? 1) as num).toInt();
          final price = (item['price'] ?? item['totalPrice'] ?? 0).toDouble();
          
          itemsSold[itemName] = (itemsSold[itemName] ?? 0) + quantity;
          categoryRevenue[category] = (categoryRevenue[category] ?? 0) + (price * quantity);
        }

        // Customer analysis
        final customerName = order['customerName'] ?? 'Walk-in Customer';
        if (customerName != 'Walk-in Customer') {
          topCustomers.add({
            'name': customerName,
            'phone': order['customerPhone'] ?? '',
            'amount': orderTotal,
            'date': orderDate,
          });
        }
      } catch (e) {
        print('Error processing order: $e');
      }
    }

    // Sort and limit top customers
    topCustomers.sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));
    topCustomers = topCustomers.take(10).toList();

    // Convert maps to sorted lists
    final sortedDailyRevenue = dailyRevenue.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    final sortedHourlyRevenue = hourlyRevenue.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final topSellingItems = itemsSold.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategories = categoryRevenue.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _reportData = {
      'totalRevenue': totalRevenue,
      'totalOrders': totalOrders,
      'totalDiscounts': totalDiscounts,
      'totalTax': totalTax,
      'averageOrderValue': totalOrders > 0 ? totalRevenue / totalOrders : 0.0,
      'dailyRevenue': sortedDailyRevenue.map((e) => {
        'date': e.key,
        'revenue': e.value,
        'orders': dailyOrders[e.key] ?? 0,
      }).toList(),
      'hourlyRevenue': sortedHourlyRevenue.map((e) => {
        'hour': e.key,
        'revenue': e.value,
      }).toList(),
      'topSellingItems': topSellingItems.take(10).map((e) => {
        'name': e.key,
        'quantity': e.value,
      }).toList(),
      'topCategories': topCategories.take(5).map((e) => {
        'name': e.key,
        'revenue': e.value,
      }).toList(),
      'paymentMethods': paymentMethods,
      'topCustomers': topCustomers,
      'hasRealData': true,
      'dateRange': '${DateFormat('MMM dd, yyyy').format(_startDate)} - ${DateFormat('MMM dd, yyyy').format(_endDate)}',
    };
  }

  void _loadSampleReportData() {
    _reportData = {
      'totalRevenue': 45670.0,
      'totalOrders': 287,
      'totalDiscounts': 2340.0,
      'totalTax': 4120.0,
      'averageOrderValue': 159.2,
      'dailyRevenue': [
        {'date': '2024-10-01', 'revenue': 1520.0, 'orders': 12},
        {'date': '2024-10-02', 'revenue': 1880.0, 'orders': 15},
        {'date': '2024-10-03', 'revenue': 2100.0, 'orders': 18},
      ],
      'hourlyRevenue': [
        {'hour': '11:00', 'revenue': 850.0},
        {'hour': '12:00', 'revenue': 1200.0},
        {'hour': '19:00', 'revenue': 1600.0},
      ],
      'topSellingItems': [
        {'name': 'Butter Chicken', 'quantity': 45},
        {'name': 'Paneer Tikka', 'quantity': 38},
        {'name': 'Dal Makhani', 'quantity': 32},
      ],
      'topCategories': [
        {'name': 'Main Course', 'revenue': 18500.0},
        {'name': 'Appetizers', 'revenue': 8900.0},
        {'name': 'Beverages', 'revenue': 4200.0},
      ],
      'paymentMethods': {'Cash': 150, 'Card': 95, 'UPI': 42},
      'topCustomers': [
        {'name': 'Rahul Sharma', 'phone': '9876543210', 'amount': 540.0, 'date': DateTime.now()},
        {'name': 'Priya Patel', 'phone': '8765432109', 'amount': 420.0, 'date': DateTime.now()},
      ],
      'hasRealData': false,
      'dateRange': '${DateFormat('MMM dd, yyyy').format(_startDate)} - ${DateFormat('MMM dd, yyyy').format(_endDate)}',
    };
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text('Sales Reports are available with Premium subscription.'),
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Reports',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_reportData.isNotEmpty)
              Text(
                _reportData['dateRange'] ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _selectDateRange,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
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
            Tab(text: 'Daily'),
            Tab(text: 'Items'),
            Tab(text: 'Customers'),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildDailyTab(),
                _buildItemsTab(),
                _buildCustomersTab(),
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
            'Generating Sales Report...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: QRKeyTheme.primarySaffron,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Analyzing your business data',
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
    final hasRealData = _reportData['hasRealData'] ?? false;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics Cards
          _buildMetricsGrid(),
          const SizedBox(height: 24),
          
          // Revenue Chart
          _buildRevenueChart(),
          const SizedBox(height: 24),
          
          // Quick Insights
          _buildQuickInsights(),
          const SizedBox(height: 24),
          
          // Payment Methods
          _buildPaymentMethodsChart(),
          
          if (!hasRealData) ...[
            const SizedBox(height: 16),
            _buildSampleDataNotice(),
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
      childAspectRatio: 1.2,
      children: [
        _buildMetricCard(
          'Total Revenue',
          '₹${(_reportData['totalRevenue'] ?? 0).toStringAsFixed(0)}',
          Icons.currency_rupee,
          Colors.green,
          '+12.5%',
        ),
        _buildMetricCard(
          'Total Orders',
          '${_reportData['totalOrders'] ?? 0}',
          Icons.receipt_long,
          Colors.blue,
          '+8.3%',
        ),
        _buildMetricCard(
          'Avg Order Value',
          '₹${(_reportData['averageOrderValue'] ?? 0).toStringAsFixed(0)}',
          Icons.shopping_cart,
          QRKeyTheme.primarySaffron,
          '+5.2%',
        ),
        _buildMetricCard(
          'Total Discounts',
          '₹${(_reportData['totalDiscounts'] ?? 0).toStringAsFixed(0)}',
          Icons.discount,
          Colors.red,
          '-2.1%',
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
                      color: change.startsWith('+') ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      change,
                      style: TextStyle(
                        color: change.startsWith('+') ? Colors.green : Colors.red,
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
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
    final dailyRevenue = _reportData['dailyRevenue'] as List<dynamic>? ?? [];
    final hasRealData = _reportData['hasRealData'] ?? false;
    
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
                Icon(Icons.trending_up, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Revenue Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Spacer(),
                if (hasRealData)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
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
            if (dailyRevenue.isEmpty)
              SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart, color: Colors.grey.shade400, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        'No Data Available',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 200,
                child: _buildRevenueChartBars(dailyRevenue),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChartBars(List<dynamic> dailyRevenue) {
    final maxRevenue = dailyRevenue.isNotEmpty 
        ? dailyRevenue.map((e) => e['revenue'] as double).reduce((a, b) => a > b ? a : b)
        : 0.0;

    if (maxRevenue == 0) {
      return Center(
        child: Text(
          'No revenue data available',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dailyRevenue.map<Widget>((data) {
          final revenue = data['revenue'] as double;
          final orders = data['orders'] as int;
          final height = (revenue / maxRevenue) * 150;
          final date = DateTime.parse(data['date']);
          
          return Container(
            width: 60,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
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
                  DateFormat('dd/MM').format(date),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                if (orders > 0)
                  Text(
                    '$orders ord',
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
    );
  }

  Widget _buildQuickInsights() {
    final hasRealData = _reportData['hasRealData'] ?? false;
    final totalOrders = _reportData['totalOrders'] ?? 0;
    final totalRevenue = _reportData['totalRevenue'] ?? 0.0;
    final avgOrderValue = _reportData['averageOrderValue'] ?? 0.0;
    
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
                Icon(Icons.lightbulb, color: QRKeyTheme.primarySaffron, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Quick Insights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (hasRealData && totalOrders > 0) ...[
              _buildInsightItem('📊', 'Total orders processed: $totalOrders'),
              _buildInsightItem('💰', 'Average order value: ₹${avgOrderValue.toStringAsFixed(0)}'),
              _buildInsightItem('🎯', 'Total revenue generated: ₹${totalRevenue.toStringAsFixed(0)}'),
              if (totalRevenue > 10000)
                _buildInsightItem('🔥', 'Excellent performance! Revenue exceeded ₹10,000'),
              if (avgOrderValue > 150)
                _buildInsightItem('⭐', 'High-value orders with avg ₹${avgOrderValue.toStringAsFixed(0)}'),
            ] else if (hasRealData) ...[
              _buildInsightItem('📈', 'No orders found for selected period'),
              _buildInsightItem('💡', 'Try selecting a different date range'),
              _buildInsightItem('🎯', 'Your analytics will improve as you process more orders'),
            ] else ...[
              _buildInsightItem('🔥', 'Peak revenue day generated 40% of total sales'),
              _buildInsightItem('📈', 'Weekend sales consistently outperform weekdays'),
              _buildInsightItem('💡', 'Main course items drive 65% of total revenue'),
              _buildInsightItem('⭐', 'Customer retention rate increased by 15%'),
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

  Widget _buildPaymentMethodsChart() {
    final paymentMethods = _reportData['paymentMethods'] as Map<String, dynamic>? ?? {};
    
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
                Icon(Icons.payment, color: Colors.purple, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (paymentMethods.isEmpty)
              Center(
                child: Text(
                  'No payment data available',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            else
              ...paymentMethods.entries.map((entry) {
                final total = paymentMethods.values.fold<int>(0, (sum, value) => sum + (value as int));
                final percentage = total > 0 ? (entry.value / total * 100).round() : 0;
                final colors = [Colors.purple, Colors.blue, Colors.green, Colors.orange];
                final colorIndex = paymentMethods.keys.toList().indexOf(entry.key) % colors.length;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colors[colorIndex],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        '${entry.value} ($percentage%)',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
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
                'This is sample data. Start processing orders to see real sales reports!',
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

  Widget _buildDailyTab() {
    final dailyRevenue = _reportData['dailyRevenue'] as List<dynamic>? ?? [];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Sales Breakdown',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: QRKeyTheme.primarySaffron,
            ),
          ),
          const SizedBox(height: 16),
          if (dailyRevenue.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey.shade400, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'No daily data available',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...dailyRevenue.map((data) {
              final date = DateTime.parse(data['date']);
              final revenue = data['revenue'] as double;
              final orders = data['orders'] as int;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
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
                              Icons.today,
                              color: QRKeyTheme.primarySaffron,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE, MMM dd, yyyy').format(date),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '$orders orders',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${revenue.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                              ),
                              if (orders > 0)
                                Text(
                                  '₹${(revenue / orders).toStringAsFixed(0)}/order',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildItemsTab() {
    final topItems = _reportData['topSellingItems'] as List<dynamic>? ?? [];
    final topCategories = _reportData['topCategories'] as List<dynamic>? ?? [];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item Performance',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: QRKeyTheme.primarySaffron,
            ),
          ),
          const SizedBox(height: 16),
          
          // Top Categories
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.purple, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Top Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (topCategories.isEmpty)
                    Center(
                      child: Text(
                        'No category data available',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  else
                    ...topCategories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final category = entry.value;
                      final colors = [Colors.purple, Colors.blue, Colors.green, Colors.orange, Colors.red];
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                              child: Text(
                                category['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              '₹${(category['revenue'] as double).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Top Items
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
                        'Best Selling Items',
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
                      final colors = [Colors.amber, Colors.grey, Colors.orange, QRKeyTheme.primarySaffron];
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: index < 3 ? colors[index] : QRKeyTheme.primarySaffron,
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
                            Icon(
                              Icons.trending_up,
                              color: Colors.green,
                              size: 20,
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

  Widget _buildCustomersTab() {
    final topCustomers = _reportData['topCustomers'] as List<dynamic>? ?? [];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Analysis',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: QRKeyTheme.primarySaffron,
            ),
          ),
          const SizedBox(height: 16),
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
                        'Top Customers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (topCustomers.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person_add, color: Colors.purple.shade300, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'No customer data available. Customer analytics will appear as you process more orders.',
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
                    ...topCustomers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final customer = entry.value;
                      final colors = [Colors.amber, Colors.grey, Colors.orange, Colors.purple];
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: index < 3 ? colors[index] : Colors.purple,
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
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.purple.withOpacity(0.1),
                              child: Text(
                                (customer['name'] as String).isNotEmpty 
                                    ? (customer['name'] as String)[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.purple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if ((customer['phone'] as String).isNotEmpty)
                                    Text(
                                      customer['phone'],
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
                                  '₹${(customer['amount'] as double).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM dd').format(customer['date']),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
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

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: QRKeyTheme.primarySaffron,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadReportData();
    }
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Report export feature coming soon!'),
        backgroundColor: QRKeyTheme.primarySaffron,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
