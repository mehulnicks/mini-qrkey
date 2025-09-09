    buffer.writeln('Order #: ${order.orderNumber}');
    buffer.writeln('Date: ${DateFormat('dd/MM/yyyy HH:mm').format(order.timestamp)}');
    buffer.writeln('Customer: ${order.customerName}');
    if (order.customerPhone != null) {
      buffer.writeln('Phone: ${order.customerPhone}');
    }
    buffer.writeln('-----------------------------');
    
    for (final item in order.items) {
      buffer.writeln('${item.quantity}x ${item.name}');
      if (item.specialInstructions != null) {
        buffer.writeln('   Note: ${item.specialInstructions}');
      }
    }
    
    if (order.notes != null) {
      buffer.writeln('-----------------------------');
      buffer.writeln('ORDER NOTES: ${order.notes}');
    }
    
    buffer.writeln('=============================');
    buffer.writeln('Time: ${DateFormat('HH:mm:ss').format(DateTime.now())}');
    
    return buffer.toString();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// Orders Screen
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    final pendingOrders = orders.where((order) => 
        order.status == OrderStatus.pending || order.status == OrderStatus.preparing).toList();
    final completedOrders = orders.where((order) => 
        order.status == OrderStatus.ready || order.status == OrderStatus.completed).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.get('orders')),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersList(context, ref, pendingOrders, showStatusUpdate: true),
            _buildOrdersList(context, ref, completedOrders, showStatusUpdate: false),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, WidgetRef ref, List<Order> orders, {required bool showStatusUpdate}) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No orders found',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: getStatusColor(order.status),
              child: Text(
                order.orderNumber.substring(3, 5),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(formatOrderNumber(order.orderNumber)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.customerName),
                Text(getStatusText(order.status)),
                Text(DateFormat('dd/MM/yyyy HH:mm').format(order.timestamp)),
              ],
            ),
            trailing: Text(
              formatCurrency(order.total),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('${item.quantity}x ${item.name}'),
                          ),
                          Text(formatCurrency(item.total)),
                        ],
                      ),
                    )),
                    if (order.notes?.isNotEmpty == true) ...[
                      const Divider(),
                      Text('Notes: ${order.notes}'),
                    ],
                    if (showStatusUpdate) ...[
                      const Divider(),
                      const Text(
                        'Order Status',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (order.status == OrderStatus.pending)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Preparing'),
                              onPressed: () {
                                ref.read(ordersProvider.notifier)
                                    .updateOrderStatus(order.id, OrderStatus.preparing);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Order ${order.orderNumber} started'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          if (order.status == OrderStatus.preparing)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Mark Ready'),
                              onPressed: () {
                                ref.read(ordersProvider.notifier).markOrderReady(order.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Order ${order.orderNumber} is ready!'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          if (order.status == OrderStatus.ready)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.done_all),
                              label: const Text('Complete'),
                              onPressed: () {
                                ref.read(ordersProvider.notifier).markOrderCompleted(order.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Order ${order.orderNumber} completed!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            onPressed: ref.read(ordersProvider.notifier).canUpdateOrder(order.id)
                                ? () => _showEditOrderDialog(context, ref, order)
                                : null,
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancel'),
                            onPressed: () => _showCancelOrderDialog(context, ref, order),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditOrderDialog(BuildContext context, WidgetRef ref, Order order) {
    if (!ref.read(ordersProvider.notifier).canUpdateOrder(order.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This order cannot be edited as it is already completed'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => EditOrderDialog(order: order),
    );
  }

  void _showCancelOrderDialog(BuildContext context, WidgetRef ref, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel order ${order.orderNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(ordersProvider.notifier)
                  .updateOrderStatus(order.id, OrderStatus.cancelled);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order ${order.orderNumber} cancelled'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

// Edit Order Dialog
class EditOrderDialog extends ConsumerStatefulWidget {
  final Order order;

  const EditOrderDialog({super.key, required this.order});

  @override
  ConsumerState<EditOrderDialog> createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends ConsumerState<EditOrderDialog> {
  late TextEditingController _customerNameController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;
  late List<OrderItem> _editableItems;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController(text: widget.order.customerName);
    _phoneController = TextEditingController(text: widget.order.customerPhone ?? '');
    _notesController = TextEditingController(text: widget.order.notes ?? '');
    _editableItems = List.from(widget.order.items);
  }

  @override
  Widget build(BuildContext context) {
    final total = _editableItems.fold(0.0, (sum, item) => sum + item.total);

    return AlertDialog(
      title: Text('Edit Order ${widget.order.orderNumber}'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Items
              const Text(
                'Order Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    ..._editableItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('${item.name} - ${formatCurrency(item.price)}'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: item.quantity > 1
                                  ? () => _updateItemQuantity(index, item.quantity - 1)
                                  : null,
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _updateItemQuantity(index, item.quantity + 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeItem(index),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatCurrency(total),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Add New Item Button
              ElevatedButton.icon(
                onPressed: () => _showAddItemDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              // Customer Information
              TextField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Special Instructions',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text('Update Order'),
          onPressed: _editableItems.isNotEmpty ? () => _updateOrder() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _updateItemQuantity(int index, int newQuantity) {
    setState(() {
      _editableItems[index] = _editableItems[index].copyWith(quantity: newQuantity);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _editableItems.removeAt(index);
    });
  }

  void _showAddItemDialog() {
    final menuItems = ref.read(menuProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item to Order'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              if (!item.isAvailable) return Container();
              
              return Card(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.description?.isNotEmpty == true)
                        Text(item.description!),
                      Text('${formatCurrency(item.price)} • ${item.category}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _addItemToOrder(item);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _addItemToOrder(MenuItem item) {
    setState(() {
      // Check if item already exists
      final existingIndex = _editableItems.indexWhere(
        (orderItem) => orderItem.name == item.name,
      );
      
      if (existingIndex != -1) {
        // Increase quantity if item exists
        _editableItems[existingIndex] = _editableItems[existingIndex].copyWith(
          quantity: _editableItems[existingIndex].quantity + 1,
        );
      } else {
        // Add new item
        _editableItems.add(OrderItem(
          menuItemId: item.id,
          name: item.name,
          price: item.price,
          quantity: 1,
        ));
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to order'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _updateOrder() async {
    if (_editableItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order must have at least one item'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final customerName = _customerNameController.text.isNotEmpty 
        ? _customerNameController.text 
        : 'Walk-in Customer';

    await ref.read(ordersProvider.notifier).updateOrder(
      widget.order.id,
      _editableItems,
      customerName,
      customerPhone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Order ${widget.order.orderNumber} updated successfully'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// KOT Screen (Kitchen Order Ticket)
class KOTScreen extends ConsumerWidget {
  const KOTScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    final activeOrders = orders.where((order) => 
        order.status == OrderStatus.pending || order.status == OrderStatus.preparing).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('kitchen_order_ticket')),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () => _showPrinterSettings(context, ref),
          ),
        ],
      ),
      body: activeOrders.isEmpty
          ? const Center(
              child: Text(
                'No active orders',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activeOrders.length,
              itemBuilder: (context, index) {
                final order = activeOrders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatOrderNumber(order.orderNumber),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.print),
                              label: const Text('Print KOT'),
                              onPressed: () => _printKOT(context, ref, order),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Customer: ${order.customerName}'),
                        Text('Time: ${DateFormat('HH:mm dd/MM').format(order.timestamp)}'),
                        if (order.customerPhone != null)
                          Text('Phone: ${order.customerPhone}'),
                        const Divider(),
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      color: Colors.white,
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
                                      item.name,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                        if (order.notes?.isNotEmpty == true) ...[
                          const Divider(),
                          Text(
                            'Special Instructions: ${order.notes}',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showPrinterSettings(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Printer Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Connect to Bluetooth Printer'),
            SizedBox(height: 16),
            Text('Available Printers:'),
            // TODO: Implement Bluetooth printer discovery
            ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text('No printers found'),
              subtitle: Text('Searching...'),
            ),
          ],
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

  void _printKOT(BuildContext context, WidgetRef ref, Order order) {
    // TODO: Implement actual printing to thermal printer
    final kotContent = _generateKOTContent(order);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('KOT Preview'),
        content: SingleChildScrollView(
          child: Text(
            kotContent,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('KOT sent to printer'),
                ),
              );
            },
            child: const Text('Print'),
          ),
        ],
      ),
    );
  }

  String _generateKOTContent(Order order) {
    final buffer = StringBuffer();
    buffer.writeln('================================');
    buffer.writeln('       KITCHEN ORDER TICKET');
    buffer.writeln('================================');
    buffer.writeln('Order: ${order.orderNumber}');
    buffer.writeln('Time: ${DateFormat('dd/MM/yyyy HH:mm').format(order.timestamp)}');
    buffer.writeln('Customer: ${order.customerName}');
    if (order.customerPhone != null) {
      buffer.writeln('Phone: ${order.customerPhone}');
    }
    buffer.writeln('--------------------------------');
    
    for (final item in order.items) {
      buffer.writeln('${item.quantity}x ${item.name}');
      if (item.specialInstructions?.isNotEmpty == true) {
        buffer.writeln('   * ${item.specialInstructions}');
      }
      buffer.writeln('');
    }
    
    if (order.notes?.isNotEmpty == true) {
      buffer.writeln('--------------------------------');
      buffer.writeln('Special Instructions:');
      buffer.writeln(order.notes);
    }
    
    buffer.writeln('================================');
    return buffer.toString();
  }
}

// Table Management Screen
class TableManagementScreen extends ConsumerWidget {
  const TableManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.watch(tablesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Management'),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: tables.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.table_restaurant, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tables configured',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final section = tables[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    title: Text(
                      section.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    subtitle: Text('${section.tables.length} tables'),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.table_restaurant, color: Colors.white),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: section.tables.length,
                          itemBuilder: (context, tableIndex) {
                            final table = section.tables[tableIndex];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              color: _getTableStatusColor(table.status),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => _showTableDetails(context, ref, table),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _getTableStatusIcon(table.status),
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        table.number,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${table.seatCount} seats',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Color _getTableStatusColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Colors.green;
      case TableStatus.occupied:
        return Colors.red;
      case TableStatus.reserved:
        return Colors.orange;
      case TableStatus.cleaning:
        return Colors.grey;
      case TableStatus.outOfOrder:
        return Colors.grey;
    }
  }

  IconData _getTableStatusIcon(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Icons.check_circle;
      case TableStatus.occupied:
        return Icons.person;
      case TableStatus.reserved:
        return Icons.schedule;
      case TableStatus.cleaning:
        return Icons.cleaning_services;
      case TableStatus.outOfOrder:
        return Icons.build;
    }
  }

  void _showTableDetails(BuildContext context, WidgetRef ref, RestaurantTable table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(table.number),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${table.status.name.toUpperCase()}'),
            Text('Capacity: ${table.seatCount} seats'),
            if (table.currentOrderId != null) 
              Text('Current Order: #${table.currentOrderId}'),
          ],
        ),
        actions: [
          if (table.status == TableStatus.occupied)
            TextButton(
              onPressed: () {
                ref.read(tablesProvider.notifier).updateTableStatus(
                  table.id,
                  TableStatus.available,
                );
                Navigator.pop(context);
              },
              child: const Text('Mark Available'),
            ),
          if (table.status == TableStatus.available)
            TextButton(
              onPressed: () {
                ref.read(tablesProvider.notifier).updateTableStatus(
                  table.id,
                  TableStatus.cleaning,
                );
                Navigator.pop(context);
              },
              child: const Text('Mark Cleaning'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Settings Screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Settings Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(
                    localizations.get('language'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.translate),
                  title: Text(localizations.get('select_language')),
                  trailing: DropdownButton<AppLanguage>(
                    value: language,
                    underline: Container(),
                    items: [
                      DropdownMenuItem(
                        value: AppLanguage.english,
                        child: Text(localizations.get('english')),
                      ),
                      DropdownMenuItem(
                        value: AppLanguage.hindi,
                        child: Text(localizations.get('hindi')),
                      ),
                    ],
                    onChanged: (AppLanguage? newLanguage) {
                      if (newLanguage != null) {
                        ref.read(languageProvider.notifier).setLanguage(newLanguage);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // KOT Settings Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(
                    'KOT Settings',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  title: Text(localizations.get('enable_kot')),
                  subtitle: Text(localizations.get('kot_feature_subtitle')),
                  value: settings.kotEnabled,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleKotEnabled();
                  },
                ),
                if (settings.kotEnabled)
                  SwitchListTile(
                    title: Text(localizations.get('auto_print_kot')),
                    subtitle: Text(localizations.get('auto_kot_subtitle')),
                    value: settings.autoKotOnOrder,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).toggleAutoKotOnOrder();
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // General Settings Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(
                    localizations.get('general_settings'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: Text(localizations.get('manage_menu')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showMenuManagement(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(localizations.get('printer_settings')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showPrinterSettings(context, ref, localizations),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Reports & Data Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.analytics),
                  title: Text(
                    localizations.get('reports_data'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.assessment),
                  title: Text(localizations.get('sales_report')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showSalesReport(context, ref, localizations),
                ),
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: Text(localizations.get('backup_data')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showBackupOptions(context, ref, localizations),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // About Section
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: Text(localizations.get('about')),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showAbout(context, localizations),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuManagement(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MenuManagementScreen()),
    );
  }

  void _showPrinterSettings(BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.get('printer_settings')),
        content: Text(localizations.get('printer_management_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.get('ok')),
          ),
        ],
      ),
    );
  }

  void _showSalesReport(BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    final orders = ref.read(ordersProvider);
    final completedOrders = orders.where((o) => o.status == OrderStatus.completed).toList();
    final totalSales = completedOrders.fold(0.0, (sum, order) => sum + order.total);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.get('sales_report')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${localizations.get('total_orders')}: ${completedOrders.length}'),
            Text('${localizations.get('total_revenue')}: ${formatCurrency(totalSales)}'),
            const SizedBox(height: 16),
            Text('Today: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}'),
            // TODO: Add more detailed analytics
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.get('close')),
          ),
        ],
      ),
    );
  }

  void _showBackupOptions(BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.get('backup_data')),
        content: Text(localizations.get('backup_restore_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.get('ok')),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context, AppLocalizations localizations) {
    showAboutDialog(
      context: context,
      applicationName: localizations.get('app_title'),
      applicationVersion: '1.0.0',
      applicationLegalese: 'Quick Service Restaurant Management App\nDesigned for Indian Restaurants',
      children: [
        Text('\n${localizations.get('features')}:'),
        Text('• ${localizations.get('mobile_first_design')}'),
        Text('• ${localizations.get('offline_support')}'),
        Text('• ${localizations.get('bluetooth_printing')}'),
        Text('• ${localizations.get('currency_formatting')}'),
        Text('• ${localizations.get('multi_language')}'),
      ],
    );
  }
}

// Menu Management Screen
class MenuManagementScreen extends ConsumerStatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  ConsumerState<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends ConsumerState<MenuManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final menu = ref.watch(menuProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddItemDialog(context, ref),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menu.length,
        itemBuilder: (context, index) {
          final item = menu[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(item.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item.category} • ${formatCurrency(item.price)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: item.isAvailable,
                    onChanged: (value) {
                      ref.read(menuProvider.notifier).updateItem(
                        item.copyWith(isAvailable: value),
                      );
                    },
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit\nसंपादित करें'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete\nहटाएं'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditItemDialog(context, ref, item);
                      } else if (value == 'delete') {
                        _confirmDelete(context, ref, item);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    _showItemDialog(context, ref, null);
  }

  void _showEditItemDialog(BuildContext context, WidgetRef ref, MenuItem item) {
    _showItemDialog(context, ref, item);
  }

  void _showItemDialog(BuildContext context, WidgetRef ref, MenuItem? item) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final priceController = TextEditingController(text: item?.price.toString() ?? '');
    final categoryController = TextEditingController(text: item?.category ?? '');
    final descriptionController = TextEditingController(text: item?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'Add Menu Item' : 'Edit Menu Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (₹) *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty) {
                final newItem = MenuItem(
                  id: item?.id ?? const Uuid().v4(),
                  name: nameController.text,
                  price: double.parse(priceController.text),
                  category: categoryController.text,
                  description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
                );

                if (item == null) {
                  ref.read(menuProvider.notifier).addItem(newItem);
                } else {
                  ref.read(menuProvider.notifier).updateItem(newItem);
                }

                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, MenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(menuProvider.notifier).removeItem(item.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
