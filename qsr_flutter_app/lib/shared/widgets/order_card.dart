import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/app_settings.dart';

/// Reusable order card widget to reduce nested widget complexity
class OrderCard extends StatelessWidget {
  final Order order;
  final AppSettings settings;
  final VoidCallback? onTap;
  final List<Widget>? actions;
  final Widget? trailing;
  final bool showStatus;
  final bool showCustomer;
  final bool compact;

  const OrderCard({
    super.key,
    required this.order,
    required this.settings,
    this.onTap,
    this.actions,
    this.trailing,
    this.showStatus = true,
    this.showCustomer = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              if (!compact) ...[
                const SizedBox(height: 8),
                _buildOrderDetails(),
              ],
              if (showCustomer && order.customer != null) ...[
                const SizedBox(height: 8),
                _buildCustomerInfo(),
              ],
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildActions(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #${order.id.substring(order.id.length - 8)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!compact) ...[
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(order.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showStatus) _buildStatusChip(),
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildStatusChip() {
    Color statusColor;
    String statusText;
    
    switch (order.status) {
      case OrderStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case OrderStatus.confirmed:
        statusColor = Colors.blue;
        statusText = 'Confirmed';
        break;
      case OrderStatus.preparing:
        statusColor = Colors.purple;
        statusText = 'Preparing';
        break;
      case OrderStatus.ready:
        statusColor = Colors.green;
        statusText = 'Ready';
        break;
      case OrderStatus.completed:
        statusColor = Colors.teal;
        statusText = 'Completed';
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.restaurant_menu, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              '${order.items.length} items',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Icon(
              _getOrderTypeIcon(),
              size: 14,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              _getOrderTypeLabel(),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Total: Rs.${order.getGrandTotal(settings).toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF9933),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.person, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              order.customer!.name ?? 'Guest',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (order.customer!.phone != null) ...[
            Icon(Icons.phone, size: 12, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              order.customer!.phone!,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: actions!,
    );
  }

  IconData _getOrderTypeIcon() {
    switch (order.type) {
      case OrderType.dineIn:
        return Icons.restaurant;
      case OrderType.takeaway:
        return Icons.takeout_dining;
      case OrderType.delivery:
        return Icons.delivery_dining;
    }
  }

  String _getOrderTypeLabel() {
    switch (order.type) {
      case OrderType.dineIn:
        return 'Dine-in';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.delivery:
        return 'Delivery';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Simple action button widget for order cards
class OrderActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onPressed;
  final bool isCompact;

  const OrderActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        color: color ?? Theme.of(context).primaryColor,
        tooltip: label,
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(0, 32),
      ),
    );
  }
}
