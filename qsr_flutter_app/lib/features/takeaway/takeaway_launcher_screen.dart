import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../orders/enhanced_takeaway_screen.dart';
import '../../core/providers/enhanced_takeaway_providers.dart';
import '../../shared/models/enhanced_takeaway_models.dart';

class TakeawayLauncherScreen extends ConsumerStatefulWidget {
  const TakeawayLauncherScreen({super.key});

  @override
  ConsumerState<TakeawayLauncherScreen> createState() => _TakeawayLauncherScreenState();
}

class _TakeawayLauncherScreenState extends ConsumerState<TakeawayLauncherScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _initializeSampleCart();
  }

  void _initializeSampleCart() {
    // Sample menu items for testing
    cartItems = [
      {
        'name': 'Margherita Pizza',
        'price': 299.0,
        'quantity': 2,
        'instructions': 'Extra cheese',
      },
      {
        'name': 'Chicken Burger',
        'price': 199.0,
        'quantity': 1,
        'instructions': 'No onions',
      },
      {
        'name': 'French Fries',
        'price': 99.0,
        'quantity': 1,
        'instructions': '',
      },
    ];
  }

  double get subtotal => cartItems.fold(0.0, (sum, item) => 
      sum + ((item['price'] ?? 0.0) * (item['quantity'] ?? 1)));
  
  double get taxAmount => subtotal * 0.05; // 5% tax
  double get discountAmount => 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takeaway System'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[400]!, Colors.orange[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restaurant, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Enhanced Takeaway System',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dual ordering with flexible payment options',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Features overview
            _buildFeaturesSection(),

            const SizedBox(height: 24),

            // Cart preview
            _buildCartPreview(),

            const SizedBox(height: 24),

            // Quick stats
            _buildQuickStats(),

            const SizedBox(height: 24),

            // Action buttons
            _buildActionButtons(),

            const SizedBox(height: 24),

            // Recent orders
            _buildRecentOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                'Order Now',
                'Immediate processing',
                Icons.flash_on,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                'Schedule Order',
                'Future date/time',
                Icons.schedule,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                'Full Payment',
                'Complete amount',
                Icons.payment,
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                'Partial Payment',
                'Advance + balance',
                Icons.payments,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCartPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
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
              Icon(Icons.shopping_cart, color: Colors.orange[600]),
              const SizedBox(width: 8),
              Text(
                'Current Cart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              Text(
                '${cartItems.length} items',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...cartItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${item['name']} x ${item['quantity']}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Text(
                  '₹${((item['price'] ?? 0) * (item['quantity'] ?? 1)).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          )).toList(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(color: Colors.grey[700]),
              ),
              Text(
                '₹${subtotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          if (taxAmount > 0) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tax (5%)',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Text(
                  '₹${taxAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '₹${(subtotal + taxAmount - discountAmount).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final quickStats = ref.watch(quickStatsProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                'Today\'s Stats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          quickStats.when(
            data: (stats) => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Total Orders',
                        '${stats['total_orders'] ?? 0}',
                        Icons.receipt,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatItem(
                        'Revenue',
                        '₹${(stats['total_revenue'] ?? 0).toStringAsFixed(0)}',
                        Icons.monetization_on,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Scheduled',
                        '${stats['scheduled_orders_count'] ?? 0}',
                        Icons.schedule,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatItem(
                        'Pending',
                        '${stats['pending_orders'] ?? 0}',
                        Icons.pending,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text(
              'Unable to load stats',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EnhancedTakeawayScreen(
                    cartItems: cartItems,
                    subtotal: subtotal,
                    taxAmount: taxAmount,
                    discountAmount: discountAmount,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.restaurant_menu),
                const SizedBox(width: 8),
                const Text(
                  'Process Takeaway Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _showOrdersDialog();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('View Orders'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _showDatabaseSchemaDialog();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Database Setup'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentOrders() {
    final recentOrders = ref.watch(recentOrdersProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              'Recent Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        recentOrders.when(
          data: (orders) => orders.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.inbox, color: Colors.grey[400], size: 32),
                        const SizedBox(height: 8),
                        Text(
                          'No orders yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Place your first takeaway order to see it here',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: orders.take(3).map((order) => 
                    _buildOrderCard(order)
                  ).toList(),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text(
            'Unable to load recent orders',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(EnhancedTakeawayOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
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
              Text(
                '#${order.id.substring(0, 8)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.statusDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(order.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            order.customerName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                order.orderType == TakeawayOrderType.orderNow 
                    ? Icons.flash_on 
                    : Icons.schedule,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                order.orderType == TakeawayOrderType.orderNow 
                    ? 'Order Now' 
                    : 'Scheduled',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                '₹${order.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TakeawayOrderStatus status) {
    switch (status) {
      case TakeawayOrderStatus.placed:
        return Colors.blue;
      case TakeawayOrderStatus.confirmed:
        return Colors.orange;
      case TakeawayOrderStatus.preparing:
        return Colors.purple;
      case TakeawayOrderStatus.ready:
        return Colors.green;
      case TakeawayOrderStatus.completed:
        return Colors.green[700]!;
      case TakeawayOrderStatus.cancelled:
        return Colors.red;
      case TakeawayOrderStatus.scheduled:
        return Colors.indigo;
    }
  }

  void _showOrdersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Orders Management'),
        content: const Text(
          'This would open the orders management screen where you can:\n\n'
          '• View all takeaway orders\n'
          '• Filter by status, type, date\n'
          '• Update order status\n'
          '• Manage payments\n'
          '• View order details\n'
          '• Real-time updates',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDatabaseSchemaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Database Setup'),
        content: const Text(
          'To use the enhanced takeaway system:\n\n'
          '1. Run the enhanced_takeaway_schema.sql file in your Supabase SQL editor\n'
          '2. This will create all necessary tables and functions\n'
          '3. The system will then be ready for real-time order management\n\n'
          'Tables created:\n'
          '• takeaway_orders\n'
          '• takeaway_order_items\n'
          '• order_schedules\n'
          '• order_payments\n'
          '• time_slots\n'
          '• takeaway_config',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
