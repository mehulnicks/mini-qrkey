import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // Sample data - in real app, this would come from your analytics service
  final Map<String, dynamic> _analyticsData = {
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
    ],
    'customerStats': {
      'newCustomers': 23,
      'returningCustomers': 45,
      'totalCustomers': 68,
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAnalytics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);
    
    // Simulate loading analytics data
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _selectedPeriod = value);
              _loadAnalytics();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Today', child: Text('Today')),
              const PopupMenuItem(value: 'This Week', child: Text('This Week')),
              const PopupMenuItem(value: 'This Month', child: Text('This Month')),
              const PopupMenuItem(value: 'This Year', child: Text('This Year')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selectedPeriod),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Sales'),
            Tab(text: 'Customers'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildSalesTab(),
                _buildCustomersTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Metrics - $_selectedPeriod',
            style: Theme.of(context).textTheme.headlineSmall,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Performance',
            style: Theme.of(context).textTheme.headlineSmall,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Insights',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildCustomerMetrics(),
          const SizedBox(height: 24),
          _buildCustomerSegmentation(),
          const SizedBox(height: 24),
          _buildCustomerActivity(),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  change,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trend',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _buildSimpleChart(),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Selling Items',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...(_analyticsData['topSellingItems'] as List<dynamic>).map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${item['orders']} orders',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${item['revenue'].toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Sales Breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...(_analyticsData['dailyRevenue'] as List<dynamic>).map((data) {
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
        ),
      ),
    );
  }

  Widget _buildSalesTrends() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Insights',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInsightItem('🔥', 'Peak hours: 7-9 PM generates 40% of daily revenue'),
            _buildInsightItem('📈', 'Weekend sales are 25% higher than weekdays'),
            _buildInsightItem('🎯', 'Online orders increased by 18% this week'),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Insights',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInsightItem('👥', 'Average customer visits 2.3 times per week'),
            _buildInsightItem('💰', 'Top 20% customers contribute 45% of revenue'),
            _buildInsightItem('⭐', 'Customer satisfaction rate: 4.6/5'),
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
}
