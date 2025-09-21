import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'clean_qsr_main.dart';

// Enhanced Reports Screen with the 5 requested features
class EnhancedReportsScreen extends ConsumerStatefulWidget {
  const EnhancedReportsScreen({super.key});

  @override
  ConsumerState<EnhancedReportsScreen> createState() => _EnhancedReportsScreenState();
}

class _EnhancedReportsScreenState extends ConsumerState<EnhancedReportsScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  ReportFilter _selectedFilter = ReportFilter.today;

  @override
  void initState() {
    super.initState();
    _updateDateRange();
  }

  void _updateDateRange() {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case ReportFilter.today:
        _startDate = DateTime(now.year, now.month, now.day);
        _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case ReportFilter.yesterday:
        final yesterday = now.subtract(const Duration(days: 1));
        _startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
        _endDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;
      case ReportFilter.last7Days:
        _startDate = DateTime(now.year, now.month, now.day - 6);
        _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case ReportFilter.thisMonth:
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case ReportFilter.thisWeek:
        final dayOfWeek = now.weekday;
        _startDate = DateTime(now.year, now.month, now.day - dayOfWeek + 1);
        _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case ReportFilter.last30Days:
        _startDate = DateTime(now.year, now.month, now.day - 29);
        _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case ReportFilter.thisYear:
        _startDate = DateTime(now.year, 1, 1);
        _endDate = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      case ReportFilter.custom:
        // Custom dates are set by date picker
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    final menuItems = ref.watch(menuProvider);
    final settings = ref.watch(settingsProvider);

    // Filter orders by date range
    final filteredOrders = orders.where((order) =>
        order.createdAt.isAfter(_startDate) && order.createdAt.isBefore(_endDate)).toList();

    // Calculate metrics
    final totalOrders = filteredOrders.length;
    final completedOrders = filteredOrders.where((o) => o.status == OrderStatus.completed).length;
    final totalSales = filteredOrders.fold(0.0, (sum, order) => sum + order.grandTotal);
    final totalItems = filteredOrders.fold(0, (sum, order) => sum + order.items.fold(0, (itemSum, item) => itemSum + item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(ref, 'reports')),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _exportToCSV(context, filteredOrders, settings),
            icon: const Icon(Icons.download),
            tooltip: 'Export CSV',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with date range and filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFFF9933).withOpacity(0.1), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedFilter == ReportFilter.today
                            ? 'Today - ${_formatDate(_startDate)}'
                            : '${_formatDate(_startDate)} - ${_formatDate(_endDate)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Today', ReportFilter.today),
                      const SizedBox(width: 8),
                      _buildFilterChip('Yesterday', ReportFilter.yesterday),
                      const SizedBox(width: 8),
                      _buildFilterChip('Last 7 Days', ReportFilter.last7Days),
                      const SizedBox(width: 8),
                      _buildFilterChip('This Month', ReportFilter.thisMonth),
                      const SizedBox(width: 8),
                      _buildFilterChip('Custom', ReportFilter.custom),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Daily Overview Section
                  _buildSectionCard(
                    'Daily Overview',
                    Icons.today,
                    Colors.blue,
                    [
                      Row(
                        children: [
                          Expanded(child: _buildMetricCard('Total Orders', '$totalOrders', Icons.receipt_long, Colors.blue, '$completedOrders completed')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildMetricCard('Total Revenue', formatIndianCurrency(settings.currency, totalSales), Icons.trending_up, Colors.green, totalOrders > 0 ? '${(totalSales / totalOrders).toStringAsFixed(0)} avg' : '0 avg')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildMetricCard('Items Sold', '$totalItems', Icons.inventory, Colors.orange, totalOrders > 0 ? '${(totalItems / totalOrders).toStringAsFixed(1)} per order' : '0 per order')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildMetricCard('Completion Rate', '${totalOrders > 0 ? ((completedOrders / totalOrders) * 100).toStringAsFixed(1) : 0}%', Icons.check_circle, Colors.purple, '$completedOrders / $totalOrders')),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Category-wise Analysis
                  _buildSectionCard(
                    'Category Performance',
                    Icons.category,
                    Colors.green,
                    _buildCategoryAnalysis(filteredOrders, menuItems, settings),
                  ),

                  const SizedBox(height: 24),

                  // Revenue by Order Type
                  _buildSectionCard(
                    'Revenue by Order Type',
                    Icons.bar_chart,
                    Colors.orange,
                    _buildOrderTypeAnalysis(filteredOrders, settings),
                  ),

                  const SizedBox(height: 24),

                  // Payment Methods Analysis
                  _buildSectionCard(
                    'Payment Collection',
                    Icons.payment,
                    Colors.teal,
                    _buildPaymentAnalysis(filteredOrders, settings),
                  ),

                  const SizedBox(height: 24),

                  // Discount Analysis
                  _buildSectionCard(
                    'Discount Analysis',
                    Icons.local_offer,
                    Colors.red,
                    _buildDiscountAnalysis(filteredOrders, settings),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _exportToCSV(BuildContext context, List<Order> orders, AppSettings settings) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV export functionality coming soon')),
    );
  }

  Widget _buildFilterChip(String label, ReportFilter filter) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == filter,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = filter;
            if (filter == ReportFilter.custom) {
              _showDateRangePicker(context);
            } else {
              _updateDateRange();
            }
          });
        }
      },
      selectedColor: const Color(0xFFFF9933).withOpacity(0.2),
      checkmarkColor: const Color(0xFFFF9933),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, Color color, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Analysis Methods
  List<Widget> _buildCategoryAnalysis(List<Order> orders, List<MenuItem> menuItems, AppSettings settings) {
    final Map<String, Map<String, dynamic>> categoryStats = {};
    
    for (final order in orders) {
      for (final orderItem in order.items) {
        final menuItem = menuItems.firstWhere((item) => item.id == orderItem.itemId, orElse: () => MenuItem(id: '', name: 'Unknown', basePrice: 0, category: 'Other'));
        final category = menuItem.category;
        
        if (!categoryStats.containsKey(category)) {
          categoryStats[category] = {'orders': 0, 'revenue': 0.0, 'quantity': 0};
        }
        
        categoryStats[category]!['orders'] = categoryStats[category]!['orders'] + 1;
        categoryStats[category]!['revenue'] = categoryStats[category]!['revenue'] + orderItem.total;
        categoryStats[category]!['quantity'] = categoryStats[category]!['quantity'] + orderItem.quantity;
      }
    }

    if (categoryStats.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('No category data available', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ];
    }

    return categoryStats.entries.map((entry) {
      return _buildCategoryRow(
        entry.key,
        entry.value['orders'],
        entry.value['revenue'],
        settings,
      );
    }).toList();
  }

  List<Widget> _buildOrderTypeAnalysis(List<Order> orders, AppSettings settings) {
    final Map<String, Map<String, dynamic>> orderTypeStats = {};
    
    for (final order in orders) {
      final type = _getOrderTypeDisplayName(order.type);
      if (!orderTypeStats.containsKey(type)) {
        orderTypeStats[type] = {'count': 0, 'revenue': 0.0};
      }
      orderTypeStats[type]!['count'] = orderTypeStats[type]!['count'] + 1;
      orderTypeStats[type]!['revenue'] = orderTypeStats[type]!['revenue'] + order.grandTotal;
    }

    if (orderTypeStats.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('No order type data available', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ];
    }

    return orderTypeStats.entries.map((entry) {
      return _buildOrderTypeRow(
        entry.key,
        entry.value['count'],
        entry.value['revenue'],
        settings,
      );
    }).toList();
  }

  List<Widget> _buildPaymentAnalysis(List<Order> orders, AppSettings settings) {
    final Map<String, double> paymentStats = {};
    
    for (final order in orders) {
      for (final payment in order.payments) {
        final method = payment.method.toString();
        paymentStats[method] = (paymentStats[method] ?? 0) + payment.amount;
      }
    }

    if (paymentStats.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('No payment data available', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ];
    }

    return paymentStats.entries.map((entry) {
      return _buildPaymentMethodRow(
        entry.key.replaceAll('PaymentMethod.', '').replaceAll('_', ' ').toUpperCase(),
        entry.value,
        settings,
      );
    }).toList();
  }

  List<Widget> _buildDiscountAnalysis(List<Order> orders, AppSettings settings) {
    final Map<String, double> discountStats = {};
    
    for (final order in orders) {
      for (final orderItem in order.items) {
        if (orderItem.discountAmount > 0) {
          final itemName = menuItems.firstWhere((item) => item.id == orderItem.itemId, orElse: () => MenuItem(id: '', name: 'Unknown Item', basePrice: 0, category: 'Other')).name;
          discountStats[itemName] = (discountStats[itemName] ?? 0) + orderItem.discountAmount;
        }
      }
      
      // Also include order-level discounts
      if (order.orderDiscountAmount > 0) {
        discountStats['Order Discount'] = (discountStats['Order Discount'] ?? 0) + order.orderDiscountAmount;
      }
    }

    if (discountStats.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('No discounts applied in this period', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ];
    }

    return discountStats.entries.map((entry) {
      return _buildDiscountItemRow(entry.key, entry.value, settings);
    }).toList();
  }

  // Row Builders
  Widget _buildCategoryRow(String category, int orders, double revenue, AppSettings settings) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              '$orders orders',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              formatIndianCurrency(settings.currency, revenue),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.green),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypeRow(String type, int count, double revenue, AppSettings settings) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              type,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              '$count orders',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              formatIndianCurrency(settings.currency, revenue),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.green),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodRow(String method, double amount, AppSettings settings) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              method,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              formatIndianCurrency(settings.currency, amount),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.green),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountItemRow(String itemName, double discount, AppSettings settings) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              itemName,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              formatIndianCurrency(settings.currency, discount),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _getOrderTypeDisplayName(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'Dine In';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.delivery:
        return 'Delivery';
    }
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedFilter = ReportFilter.custom;
      });
    }
  }
}
