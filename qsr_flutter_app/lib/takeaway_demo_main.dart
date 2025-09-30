import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/orders/enhanced_takeaway_screen.dart';
import 'shared/models/enhanced_takeaway_models.dart';

void main() {
  runApp(const ProviderScope(child: TakeawayTestApp()));
}

class TakeawayTestApp extends StatelessWidget {
  const TakeawayTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Takeaway System Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TakeawayDemoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TakeawayDemoScreen extends StatefulWidget {
  const TakeawayDemoScreen({super.key});

  @override
  State<TakeawayDemoScreen> createState() => _TakeawayDemoScreenState();
}

class _TakeawayDemoScreenState extends State<TakeawayDemoScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _initializeSampleCart();
  }

  void _initializeSampleCart() {
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
        title: const Text('Enhanced Takeaway System Demo'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[400]!, Colors.orange[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Enhanced Takeaway System',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
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
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Features Grid
            _buildFeaturesGrid(),

            const SizedBox(height: 24),

            // Cart Preview
            _buildCartPreview(),

            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),

            const SizedBox(height: 24),

            // System Information
            _buildSystemInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            _buildFeatureCard(
              'Order Now',
              'Immediate processing',
              Icons.flash_on,
              Colors.green,
            ),
            _buildFeatureCard(
              'Schedule Order',
              'Future date/time',
              Icons.schedule,
              Colors.blue,
            ),
            _buildFeatureCard(
              'Full Payment',
              'Complete amount',
              Icons.payment,
              Colors.purple,
            ),
            _buildFeatureCard(
              'Partial Payment',
              'Advance + balance',
              Icons.payments,
              Colors.orange,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
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
            blurRadius: 8,
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
              const Text(
                'Sample Cart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
          const SizedBox(height: 16),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          )).toList(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: TextStyle(color: Colors.black87)),
              Text(
                '₹${subtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (taxAmount > 0) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tax (5%)', style: TextStyle(color: Colors.black87)),
                Text(
                  '₹${taxAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu),
                SizedBox(width: 8),
                Text(
                  'Start Enhanced Takeaway Order',
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
                onPressed: () => _showFeaturesDialog(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('View Features'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showSetupDialog(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Setup Guide'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSystemInfo() {
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
              Icon(Icons.info, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                'System Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• Dual ordering: Order Now vs Schedule Order\n'
            '• Flexible payments: Full vs Partial payment\n'
            '• Multi-method support: Cash, Card, UPI, Digital\n'
            '• Real-time order tracking with Supabase\n'
            '• Complete order lifecycle management\n'
            '• Time slot booking for scheduled orders',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  void _showFeaturesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enhanced Takeaway Features'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Order Types:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Order Now - Immediate processing\n'
                   '• Schedule Order - Future date/time selection'),
              SizedBox(height: 12),
              Text(
                'Payment Options:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Full Payment - Complete amount upfront\n'
                   '• Partial Payment - Advance + balance due'),
              SizedBox(height: 12),
              Text(
                'Additional Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Time slot management\n'
                   '• Multi-method payments\n'
                   '• Real-time status updates\n'
                   '• Customer details capture\n'
                   '• Special instructions support'),
            ],
          ),
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

  void _showSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setup Instructions'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Database Setup:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('1. Deploy enhanced_takeaway_schema.sql to Supabase\n'
                   '2. Configure credentials in supabase_config.dart\n'
                   '3. Enable Row Level Security'),
              SizedBox(height: 12),
              Text(
                'Dependencies:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• flutter_riverpod: ^2.4.9\n'
                   '• supabase_flutter: ^2.0.0'),
              SizedBox(height: 12),
              Text(
                'Testing:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Use the test app to validate features\n'
                   '• Test both order types and payment options\n'
                   '• Verify database integration'),
            ],
          ),
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
