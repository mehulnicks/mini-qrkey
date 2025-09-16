import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'clean_qsr_main.dart';

// KOT (Kitchen Order Ticket) Screen
class KOTScreen extends ConsumerWidget {
  const KOTScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final settings = ref.watch(settingsProvider);

    // Filter orders that are open (need to be prepared)
    final openOrders = orders.where((order) => order.status == OrderStatus.preparing).toList();
    print('DEBUG KOT: Total orders: ${orders.length}');
    print('DEBUG KOT: Orders with preparing status: ${openOrders.length}');
    for (final order in orders) {
      print('DEBUG KOT: Order ${order.id.substring(order.id.length - 6)} - Status: ${order.status}');
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Order Tickets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.summarize),
            tooltip: 'KOT Summary',
            onPressed: () => _showKOTSummaryDialog(context, orders, settings.businessName),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh the orders
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Orders refreshed')),
              );
            },
          ),
        ],
      ),
      body: openOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.kitchen, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No pending orders',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All orders have been completed!',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: openOrders.length,
              itemBuilder: (context, index) {
                final order = openOrders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  child: Column(
                    children: [
                      // Order Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: order.type == OrderType.dineIn 
                              ? Colors.blue[50] 
                              : Colors.orange[50],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              order.type == OrderType.dineIn 
                                  ? Icons.restaurant 
                                  : Icons.takeout_dining,
                              color: order.type == OrderType.dineIn 
                                  ? Colors.blue[700] 
                                  : Colors.orange[700],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${order.id.substring(order.id.length - 6)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${order.type.name.toUpperCase()} • ${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'PREPARE',
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Order Items
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ...order.items.map((item) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${item.quantity}x',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.menuItem.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          item.menuItem.category,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            
                            // Order Notes
                            if (order.notes != null && order.notes!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.yellow[200]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Special Instructions:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      order.notes!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            
                            const SizedBox(height: 16),
                            
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _printKOT(context, order, settings),
                                    icon: const Icon(Icons.print),
                                    label: const Text('Print KOT'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _markOrderReady(ref, order),
                                    icon: const Icon(Icons.restaurant),
                                    label: const Text('Mark Ready'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _printKOT(BuildContext context, Order order, AppSettings settings) {
    // Generate KOT content
    final kotContent = _generateKOTContent(order, settings);
    
    // Show print preview dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('KOT Print Preview'),
        content: SingleChildScrollView(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              kotContent,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('KOT sent to printer')),
              );
            },
            icon: const Icon(Icons.print),
            label: const Text('Print'),
          ),
        ],
      ),
    );
  }

  String _generateKOTContent(Order order, AppSettings settings) {
    final now = DateTime.now();
    final buffer = StringBuffer();
    
    buffer.writeln('================================');
    buffer.writeln('    KITCHEN ORDER TICKET');
    buffer.writeln('================================');
    buffer.writeln('Business: ${settings.businessName}');
    buffer.writeln('Order: #${order.id.substring(order.id.length - 6)}');
    buffer.writeln('Type: ${order.type.name.toUpperCase()}');
    buffer.writeln('Time: ${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}');
    buffer.writeln('--------------------------------');
    
    for (final item in order.items) {
      buffer.writeln('${item.quantity}x ${item.menuItem.name}');
      buffer.writeln('   Category: ${item.menuItem.category}');
      
      // Show discount information if applicable
      if (item.hasDiscount) {
        final discountType = item.discount!.type == DiscountType.percentage 
            ? '${item.discount!.value.toStringAsFixed(0)}%' 
            : '₹${item.discount!.value.toStringAsFixed(2)}';
        buffer.writeln('   DISCOUNT: $discountType (-₹${item.discountAmount.toStringAsFixed(2)})');
        if (item.discount?.reason != null) {
          buffer.writeln('   Reason: ${item.discount!.reason}');
        }
      }
      buffer.writeln('');
    }
    
    if (order.notes != null && order.notes!.isNotEmpty) {
      buffer.writeln('SPECIAL INSTRUCTIONS:');
      buffer.writeln(order.notes!);
      buffer.writeln('');
    }
    
    // Show order-level discount information
    if (order.hasOrderDiscount) {
      buffer.writeln('ORDER DISCOUNT:');
      final discountType = order.orderDiscount!.type == DiscountType.percentage 
          ? '${order.orderDiscount!.value.toStringAsFixed(0)}%' 
          : '₹${order.orderDiscount!.value.toStringAsFixed(2)}';
      buffer.writeln('Type: $discountType');
      buffer.writeln('Amount: -₹${order.orderDiscountAmount.toStringAsFixed(2)}');
      if (order.orderDiscount?.reason != null) {
        buffer.writeln('Reason: ${order.orderDiscount!.reason}');
      }
      buffer.writeln('');
    }
    
    buffer.writeln('--------------------------------');
    buffer.writeln('Total Items: ${order.items.fold(0, (sum, item) => sum + item.quantity)}');
    
    // Show total savings if applicable
    if (order.hasDiscounts) {
      buffer.writeln('Total Savings: ₹${order.totalDiscountAmount.toStringAsFixed(2)}');
    }
    buffer.writeln('================================');
    
    return buffer.toString();
  }

  void _markOrderReady(WidgetRef ref, Order order) {
    ref.read(ordersProvider.notifier).updateOrderStatus(order.id, OrderStatus.ready);
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(
        content: Text('Order #${order.id.substring(order.id.length - 6)} marked as ready'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showKOTSummaryDialog(BuildContext context, List<Order> orders, String businessName) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    
    // Filter orders for today
    final todaysOrders = orders.where((order) =>
        order.createdAt.isAfter(startOfDay) &&
        order.createdAt.isBefore(endOfDay)).toList();
    
    final summaryContent = _formatKOTSummaryReport(todaysOrders, businessName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.summarize, color: Color(0xFFFF9933)),
            const SizedBox(width: 8),
            const Text('KOT Summary'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'TODAY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Text(
                summaryContent,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              print('Printing KOT Summary...\n$summaryContent');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('KOT Summary sent to printer')),
              );
            },
            icon: const Icon(Icons.print),
            label: const Text('Print'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9933),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatKOTSummaryReport(List<Order> orders, String businessName) {
    final now = DateTime.now();
    final buffer = StringBuffer();
    
    buffer.writeln('=== KOT SUMMARY REPORT ===');
    buffer.writeln('================================');
    buffer.writeln('     KOT SUMMARY - Today');
    buffer.writeln('================================');
    buffer.writeln('Generated: ${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}');
    buffer.writeln('--------------------------------');
    
    final totalOrders = orders.length;
    final preparingOrders = orders.where((o) => o.status == OrderStatus.preparing).length;
    final readyOrders = orders.where((o) => o.status == OrderStatus.ready).length;
    final completedOrders = orders.where((o) => o.status == OrderStatus.completed).length;
    final totalItems = orders.fold(0, (sum, order) => sum + order.items.fold(0, (itemSum, item) => itemSum + item.quantity));
    
    // Discount analytics
    final ordersWithDiscounts = orders.where((o) => o.hasDiscounts).length;
    final totalDiscountAmount = orders.fold(0.0, (sum, order) => sum + order.totalDiscountAmount);
    final totalRevenue = orders.fold(0.0, (sum, order) => sum + order.grandTotal);
    
    buffer.writeln('KITCHEN METRICS:');
    buffer.writeln('Total Orders: $totalOrders');
    buffer.writeln('Preparing: $preparingOrders');
    buffer.writeln('Ready: $readyOrders'); 
    buffer.writeln('Completed: $completedOrders');
    buffer.writeln('Total Items: $totalItems');
    buffer.writeln('--------------------------------');
    buffer.writeln('DISCOUNT SUMMARY:');
    buffer.writeln('Orders with Discounts: $ordersWithDiscounts');
    buffer.writeln('Total Discount Amount: ₹${totalDiscountAmount.toStringAsFixed(2)}');
    buffer.writeln('Total Revenue: ₹${totalRevenue.toStringAsFixed(2)}');
    if (totalDiscountAmount > 0) {
      final discountPercentage = (totalDiscountAmount / (totalRevenue + totalDiscountAmount)) * 100;
      buffer.writeln('Discount Rate: ${discountPercentage.toStringAsFixed(1)}%');
    }
    buffer.writeln('--------------------------------');
    
    if (orders.isNotEmpty) {
      buffer.writeln('ORDER DETAILS:');
      for (final order in orders) {
        final statusIcon = order.status == OrderStatus.preparing ? '⏳' :
                          order.status == OrderStatus.ready ? '✅' : '🏁';
        buffer.writeln('$statusIcon Order #${order.id.substring(order.id.length - 6)} - ${order.type.name.toUpperCase()}');
        buffer.writeln('   Time: ${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}');
        buffer.writeln('   Items: ${order.items.fold(0, (sum, item) => sum + item.quantity)}');
        buffer.writeln('   Total: ₹${order.grandTotal.toStringAsFixed(2)}');
        if (order.hasDiscounts) {
          buffer.writeln('   💸 Discount: ₹${order.totalDiscountAmount.toStringAsFixed(2)}');
        }
        buffer.writeln('');
      }
    }
    
    buffer.writeln('--------------------------------');
    buffer.writeln('Store: $businessName');
    buffer.writeln('KOT Terminal');
    buffer.writeln('================================');
    
    return buffer.toString();
  }
}
