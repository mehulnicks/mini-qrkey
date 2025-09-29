import 'package:flutter/material.dart';
import '../models/table.dart';

/// Reusable table card widget for table management
class TableCard extends StatelessWidget {
  final TableModel table;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;
  final bool showStatus;
  final bool compact;

  const TableCard({
    super.key,
    required this.table,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.trailing,
    this.showStatus = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(compact ? 4 : 8),
      elevation: isSelected ? 4 : 1,
      color: _getCardColor(),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(compact ? 12 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected 
                ? Border.all(color: const Color(0xFFFF9933), width: 2)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTableIcon(),
              SizedBox(height: compact ? 4 : 8),
              _buildTableNumber(),
              if (showStatus && !compact) ...[
                const SizedBox(height: 4),
                _buildTableStatus(),
              ],
              if (table.currentOrder != null && !compact) ...[
                const SizedBox(height: 4),
                _buildOrderInfo(),
              ],
              if (trailing != null) ...[
                SizedBox(height: compact ? 4 : 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getCardColor() {
    if (isSelected) return const Color(0xFFFF9933).withOpacity(0.1);
    
    switch (table.status) {
      case TableStatus.available:
        return Colors.green.withOpacity(0.05);
      case TableStatus.occupied:
        return Colors.orange.withOpacity(0.05);
      case TableStatus.reserved:
        return Colors.blue.withOpacity(0.05);
      case TableStatus.cleaning:
        return Colors.purple.withOpacity(0.05);
      case TableStatus.outOfOrder:
        return Colors.red.withOpacity(0.05);
    }
  }

  Widget _buildTableIcon() {
    IconData icon;
    Color color;
    
    switch (table.status) {
      case TableStatus.available:
        icon = Icons.table_restaurant;
        color = Colors.green;
        break;
      case TableStatus.occupied:
        icon = Icons.people;
        color = Colors.orange;
        break;
      case TableStatus.reserved:
        icon = Icons.bookmark;
        color = Colors.blue;
        break;
      case TableStatus.cleaning:
        icon = Icons.cleaning_services;
        color = Colors.purple;
        break;
      case TableStatus.outOfOrder:
        icon = Icons.block;
        color = Colors.red;
        break;
    }

    return Icon(
      icon,
      size: compact ? 24 : 32,
      color: isSelected ? const Color(0xFFFF9933) : color,
    );
  }

  Widget _buildTableNumber() {
    return Text(
      'Table ${table.number}',
      style: TextStyle(
        fontSize: compact ? 12 : 14,
        fontWeight: FontWeight.bold,
        color: isSelected ? const Color(0xFFFF9933) : Colors.black87,
      ),
    );
  }

  Widget _buildTableStatus() {
    String statusText;
    Color statusColor;
    
    switch (table.status) {
      case TableStatus.available:
        statusText = 'Available';
        statusColor = Colors.green;
        break;
      case TableStatus.occupied:
        statusText = 'Occupied';
        statusColor = Colors.orange;
        break;
      case TableStatus.reserved:
        statusText = 'Reserved';
        statusColor = Colors.blue;
        break;
      case TableStatus.cleaning:
        statusText = 'Cleaning';
        statusColor = Colors.purple;
        break;
      case TableStatus.outOfOrder:
        statusText = 'Out of Order';
        statusColor = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    if (table.currentOrder == null) return const SizedBox.shrink();
    
    return Column(
      children: [
        Text(
          'Order #${table.currentOrder!.id.substring(table.currentOrder!.id.length - 6)}',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          'Rs.${table.currentOrder!.getGrandTotal().toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF9933),
          ),
        ),
      ],
    );
  }
}

/// Table grid view widget
class TableGridView extends StatelessWidget {
  final List<TableModel> tables;
  final TableModel? selectedTable;
  final Function(TableModel) onTableTap;
  final Function(TableModel)? onTableLongPress;
  final bool compact;
  final int crossAxisCount;

  const TableGridView({
    super.key,
    required this.tables,
    required this.onTableTap,
    this.selectedTable,
    this.onTableLongPress,
    this.compact = false,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: compact ? 1.2 : 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        return TableCard(
          table: table,
          isSelected: selectedTable?.id == table.id,
          onTap: () => onTableTap(table),
          onLongPress: onTableLongPress != null 
              ? () => onTableLongPress!(table)
              : null,
          compact: compact,
        );
      },
    );
  }
}

/// Table status filter widget
class TableStatusFilter extends StatelessWidget {
  final TableStatus? selectedStatus;
  final Function(TableStatus?) onStatusChanged;
  final bool showCounts;
  final Map<TableStatus, int>? statusCounts;

  const TableStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
    this.showCounts = false,
    this.statusCounts,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(
            label: 'All',
            isSelected: selectedStatus == null,
            onTap: () => onStatusChanged(null),
            count: showCounts ? _getTotalCount() : null,
          ),
          const SizedBox(width: 8),
          ...TableStatus.values.map((status) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildFilterChip(
              label: _getStatusLabel(status),
              isSelected: selectedStatus == status,
              onTap: () => onStatusChanged(status),
              color: _getStatusColor(status),
              count: showCounts ? (statusCounts?[status] ?? 0) : null,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
    int? count,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? (color ?? const Color(0xFFFF9933))
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? (color ?? const Color(0xFFFF9933))
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected 
                        ? (color ?? const Color(0xFFFF9933))
                        : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return 'Available';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.reserved:
        return 'Reserved';  
      case TableStatus.cleaning:
        return 'Cleaning';
      case TableStatus.outOfOrder:
        return 'Out of Order';
    }
  }

  Color _getStatusColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Colors.green;
      case TableStatus.occupied:
        return Colors.orange;
      case TableStatus.reserved:
        return Colors.blue;
      case TableStatus.cleaning:
        return Colors.purple;
      case TableStatus.outOfOrder:
        return Colors.red;
    }
  }

  int _getTotalCount() {
    if (statusCounts == null) return 0;
    return statusCounts!.values.fold(0, (sum, count) => sum + count);
  }
}
