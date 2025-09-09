import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/app_providers.dart';
import '../../shared/models/order.dart';
import '../../../core/database/database.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final currentOrder = ref.watch(currentOrderProvider);
    final availableMenuItems = ref.watch(availableMenuItemsProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: Column(
        children: [
          // Order Type and Token/Table Selection
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<OrderType>(
                          segments: const [
                            ButtonSegment(
                              value: OrderType.dineIn,
                              label: Text('Dine In'),
                              icon: Icon(Icons.restaurant),
                            ),
                            ButtonSegment(
                              value: OrderType.takeaway,
                              label: Text('Takeaway'),
                              icon: Icon(Icons.takeout_dining),
                            ),
                          ],
                          selected: {currentOrder.orderType},
                          onSelectionChanged: (Set<OrderType> selection) {
                            ref.read(currentOrderProvider.notifier)
                              .setOrderType(selection.first);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: currentOrder.orderType == OrderType.dineIn 
                        ? 'Table Number' 
                        : 'Token Number',
                      prefixIcon: Icon(
                        currentOrder.orderType == OrderType.dineIn 
                          ? Icons.table_restaurant 
                          : Icons.confirmation_number,
                      ),
                    ),
                    onChanged: (value) {
                      ref.read(currentOrderProvider.notifier)
                        .setTokenOrTable(value);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Menu Items Grid
          Expanded(
            flex: 2,
            child: availableMenuItems.when(
              data: (items) => GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    child: InkWell(
                      onTap: () {
                        ref.read(currentOrderProvider.notifier)
                          .addItem(item);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fastfood,
                              size: 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleSmall,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${settings.currencySymbol}${item.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading menu: $error'),
              ),
            ),
          ),

          // Current Order Summary
          if (currentOrder.items.isNotEmpty) ...[
            Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Order',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '${settings.currencySymbol}${currentOrder.total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: currentOrder.items.length,
                      itemBuilder: (context, index) {
                        final item = currentOrder.items[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text('${item.quantity}'),
                          ),
                          title: Text(item.menuItem.name),
                          subtitle: item.notes != null 
                            ? Text(item.notes!)
                            : null,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${settings.currencySymbol}${item.lineTotal.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    ref.read(currentOrderProvider.notifier)
                                      .updateItemQuantity(index, item.quantity - 1);
                                  } else {
                                    ref.read(currentOrderProvider.notifier)
                                      .removeItem(index);
                                  }
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              IconButton(
                                onPressed: () {
                                  ref.read(currentOrderProvider.notifier)
                                    .updateItemQuantity(index, item.quantity + 1);
                                },
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ref.read(currentOrderProvider.notifier).clear();
                            },
                            child: const Text('Clear'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: currentOrder.tokenOrTable.isEmpty || currentOrder.isLoading
                              ? null
                              : () async {
                                  try {
                                    final orderId = await ref.read(currentOrderProvider.notifier).saveOrder();
                                    if (orderId != null && mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Order #$orderId saved successfully!'),
                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error saving order: $e'),
                                          backgroundColor: Theme.of(context).colorScheme.error,
                                        ),
                                      );
                                    }
                                  }
                                },
                            child: currentOrder.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Save Order'),
                          ),
                        ),
                        if (settings.kotEnabled) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: currentOrder.tokenOrTable.isEmpty || currentOrder.isLoading
                                ? null
                                : () async {
                                    try {
                                      final orderId = await ref.read(currentOrderProvider.notifier).saveOrder();
                                      if (orderId != null && mounted) {
                                        // TODO: Print KOT
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Order #$orderId saved and KOT printed!'),
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                            backgroundColor: Theme.of(context).colorScheme.error,
                                          ),
                                        );
                                      }
                                    }
                                  },
                              child: const Text('Save & Print'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
