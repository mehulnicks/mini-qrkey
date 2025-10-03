import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';
import '../shared/widgets/premium_upgrade_widgets.dart';

// Enhanced Menu Management Screen with Freemium Integration
class FreemiumMenuScreen extends ConsumerStatefulWidget {
  const FreemiumMenuScreen({super.key});

  @override
  ConsumerState<FreemiumMenuScreen> createState() => _FreemiumMenuScreenState();
}

class _FreemiumMenuScreenState extends ConsumerState<FreemiumMenuScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This would connect to your existing menu provider
    // For demo purposes, I'm using a static list
    final menuItems = _getDemoMenuItems();
    
    final filteredItems = _searchQuery.isEmpty
        ? menuItems
        : menuItems.where((item) => 
            item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.category.toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Menu Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
          IconButton(
            icon: const Icon(Icons.upgrade),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PremiumUpgradeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Subscription Status Widget
          const SubscriptionStatusWidget(),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search menu items...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          
          // Menu Items List
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _buildMenuItemCard(item, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemDialog,
        backgroundColor: const Color(0xFFFF9933),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Item',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(MenuItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showItemDetails(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getCategoryColor(item.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(item.category),
                  color: _getCategoryColor(item.category),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: item.isAvailable
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.isAvailable ? 'Available' : 'Unavailable',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: item.isAvailable
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9933),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Stock: ${item.stockQuantity}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    if (item.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Actions Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) => _handleMenuAction(value, item),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit, size: 20),
                      title: Text('Edit'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'stock',
                    child: ListTile(
                      leading: Icon(Icons.inventory, size: 20),
                      title: Text('Update Stock'),
                      dense: true,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle',
                    child: ListTile(
                      leading: Icon(
                        item.isAvailable ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      title: Text(item.isAvailable ? 'Make Unavailable' : 'Make Available'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, size: 20, color: Colors.red),
                      title: Text('Delete', style: TextStyle(color: Colors.red)),
                      dense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isEmpty ? 'No menu items yet' : 'No items found',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Add your first menu item to get started'
                : 'Try searching with different keywords',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          if (_searchQuery.isEmpty)
            ElevatedButton.icon(
              onPressed: _showAddItemDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9933),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Item'),
            ),
        ],
      ),
    );
  }

  Future<void> _showAddItemDialog() async {
    // Check subscription limits before showing dialog
    final validation = await SubscriptionService.validateAddMenuItem();
    
    if (!validation.isValid) {
      showDialog(
        context: context,
        builder: (context) => MenuItemLimitDialog(validation: validation),
      );
      return;
    }
    
    _showItemDialog(null);
  }

  void _showItemDialog(MenuItem? item) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final priceController = TextEditingController(text: item?.price.toString() ?? '');
    final descriptionController = TextEditingController(text: item?.description ?? '');
    final stockController = TextEditingController(text: item?.stockQuantity.toString() ?? '10');
    String selectedCategory = item?.category ?? 'Main';
    bool isAvailable = item?.isAvailable ?? true;
    
    final categories = ['Main', 'Sides', 'Drinks', 'Desserts', 'Snacks'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          item == null ? 'Add Menu Item' : 'Edit Menu Item',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name *',
                  prefixIcon: Icon(Icons.restaurant),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (₹) *',
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(
                  labelText: 'Stock Quantity',
                  prefixIcon: Icon(Icons.inventory),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Available'),
                subtitle: const Text('Is this item currently available?'),
                value: isAvailable,
                onChanged: (value) {
                  setState(() => isAvailable = value);
                },
                activeColor: const Color(0xFFFF9933),
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
            onPressed: () async {
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                if (item == null) {
                  // Adding new item - increment count
                  await SubscriptionService.incrementMenuItemCount();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Menu item added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Editing existing item
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Menu item updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                
                Navigator.pop(context);
                setState(() {}); // Refresh the UI
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in required fields'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9933),
              foregroundColor: Colors.white,
            ),
            child: Text(item == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, MenuItem item) {
    switch (action) {
      case 'edit':
        _showItemDialog(item);
        break;
      case 'stock':
        _showStockDialog(item);
        break;
      case 'toggle':
        _toggleItemAvailability(item);
        break;
      case 'delete':
        _showDeleteDialog(item);
        break;
    }
  }

  void _showStockDialog(MenuItem item) {
    final stockController = TextEditingController(text: item.stockQuantity.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock - ${item.name}'),
        content: TextField(
          controller: stockController,
          decoration: const InputDecoration(
            labelText: 'Stock Quantity',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Update stock logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Stock updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9933),
              foregroundColor: Colors.white,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _toggleItemAvailability(MenuItem item) {
    // Toggle availability logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          item.isAvailable 
              ? '${item.name} marked as unavailable'
              : '${item.name} marked as available',
        ),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {});
  }

  void _showDeleteDialog(MenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Delete item and decrement count
              await SubscriptionService.decrementMenuItemCount();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menu item deleted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(MenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Category', item.category),
            _buildDetailRow('Price', '₹${item.price.toStringAsFixed(0)}'),
            _buildDetailRow('Stock', item.stockQuantity.toString()),
            _buildDetailRow('Status', item.isAvailable ? 'Available' : 'Unavailable'),
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(item.description),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showItemDialog(item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9933),
              foregroundColor: Colors.white,
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Menu Management Help'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Free Plan: Up to 10 menu items'),
            Text('Premium Plan: Unlimited menu items'),
            SizedBox(height: 12),
            Text('Features:'),
            Text('• Add, edit, and delete menu items'),
            Text('• Manage stock quantities'),
            Text('• Toggle item availability'),
            Text('• Organize by categories'),
          ],
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

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'main':
        return Colors.red;
      case 'sides':
        return Colors.orange;
      case 'drinks':
        return Colors.blue;
      case 'desserts':
        return Colors.purple;
      case 'snacks':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'main':
        return Icons.restaurant;
      case 'sides':
        return Icons.food_bank;
      case 'drinks':
        return Icons.local_drink;
      case 'desserts':
        return Icons.cake;
      case 'snacks':
        return Icons.fastfood;
      default:
        return Icons.restaurant_menu;
    }
  }

  // Demo data - replace with your actual data source
  List<MenuItem> _getDemoMenuItems() {
    return [
      MenuItem(
        name: 'Butter Chicken',
        price: 280.0,
        category: 'Main',
        description: 'Creamy tomato-based curry with tender chicken pieces',
        isAvailable: true,
        stockQuantity: 50,
      ),
      MenuItem(
        name: 'Paneer Butter Masala',
        price: 220.0,
        category: 'Main',
        description: 'Rich and creamy paneer curry',
        isAvailable: true,
        stockQuantity: 30,
      ),
      MenuItem(
        name: 'Masala Chai',
        price: 25.0,
        category: 'Drinks',
        description: 'Traditional spiced tea',
        isAvailable: true,
        stockQuantity: 100,
      ),
      MenuItem(
        name: 'Samosa',
        price: 15.0,
        category: 'Snacks',
        description: 'Crispy pastry with spiced potato filling',
        isAvailable: false,
        stockQuantity: 0,
      ),
      MenuItem(
        name: 'Gulab Jamun',
        price: 60.0,
        category: 'Desserts',
        description: 'Sweet milk dumplings in sugar syrup',
        isAvailable: true,
        stockQuantity: 25,
      ),
    ];
  }
}

// Demo MenuItem class - replace with your actual model
class MenuItem {
  final String name;
  final double price;
  final String category;
  final String description;
  final bool isAvailable;
  final int stockQuantity;

  MenuItem({
    required this.name,
    required this.price,
    required this.category,
    this.description = '',
    this.isAvailable = true,
    this.stockQuantity = 0,
  });
}
