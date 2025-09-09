import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../shared/providers/app_providers.dart';

enum DateFilter {
  today,
  yesterday,
  thisWeek,
  last7Days,
  thisMonth,
  last30Days,
  thisYear,
  customRange,
}

extension DateFilterExtension on DateFilter {
  String get label {
    switch (this) {
      case DateFilter.today:
        return 'Today';
      case DateFilter.yesterday:
        return 'Yesterday';
      case DateFilter.thisWeek:
        return 'This Week';
      case DateFilter.last7Days:
        return 'Last 7 Days';
      case DateFilter.thisMonth:
        return 'This Month';
      case DateFilter.last30Days:
        return 'Last 30 Days';
      case DateFilter.thisYear:
        return 'This Year';
      case DateFilter.customRange:
        return 'Custom Range';
    }
  }

  DateTimeRange get dateRange {
    final now = DateTime.now();
    switch (this) {
      case DateFilter.today:
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        return DateTimeRange(start: startOfDay, end: endOfDay);
      
      case DateFilter.yesterday:
        final yesterday = now.subtract(const Duration(days: 1));
        final startOfDay = DateTime(yesterday.year, yesterday.month, yesterday.day);
        final endOfDay = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        return DateTimeRange(start: startOfDay, end: endOfDay);
      
      case DateFilter.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        return DateTimeRange(start: startOfDay, end: endOfDay);
      
      case DateFilter.last7Days:
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        final startOfDay = DateTime(sevenDaysAgo.year, sevenDaysAgo.month, sevenDaysAgo.day);
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        return DateTimeRange(start: startOfDay, end: endOfDay);
      
      case DateFilter.thisMonth:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        return DateTimeRange(start: startOfMonth, end: endOfDay);
      
      case DateFilter.last30Days:
        final thirtyDaysAgo = now.subtract(const Duration(days: 30));
        final startOfDay = DateTime(thirtyDaysAgo.year, thirtyDaysAgo.month, thirtyDaysAgo.day);
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        return DateTimeRange(start: startOfDay, end: endOfDay);
      
      case DateFilter.thisYear:
        final startOfYear = DateTime(now.year, 1, 1);
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        return DateTimeRange(start: startOfYear, end: endOfDay);
      
      case DateFilter.customRange:
        // Default to today for custom range
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        return DateTimeRange(start: startOfDay, end: endOfDay);
    }
  }
}

final reportsProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  final database = ref.watch(databaseProvider);
  return ReportsNotifier(database);
});

class ReportsState {
  final DateFilter selectedFilter;
  final DateTimeRange dateRange;
  final double totalSales;
  final int totalOrders;
  final int totalItemsSold;
  final double averageOrderValue;
  final List<Map<String, dynamic>> topItems;
  final bool isLoading;
  final String? error;

  const ReportsState({
    this.selectedFilter = DateFilter.today,
    required this.dateRange,
    this.totalSales = 0.0,
    this.totalOrders = 0,
    this.totalItemsSold = 0,
    this.averageOrderValue = 0.0,
    this.topItems = const [],
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    DateFilter? selectedFilter,
    DateTimeRange? dateRange,
    double? totalSales,
    int? totalOrders,
    int? totalItemsSold,
    double? averageOrderValue,
    List<Map<String, dynamic>>? topItems,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      dateRange: dateRange ?? this.dateRange,
      totalSales: totalSales ?? this.totalSales,
      totalOrders: totalOrders ?? this.totalOrders,
      totalItemsSold: totalItemsSold ?? this.totalItemsSold,
      averageOrderValue: averageOrderValue ?? this.averageOrderValue,
      topItems: topItems ?? this.topItems,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ReportsNotifier extends StateNotifier<ReportsState> {
  final AppDatabase _database;

  ReportsNotifier(this._database) : super(
    ReportsState(dateRange: DateFilter.today.dateRange),
  ) {
    loadReports();
  }

  Future<void> setDateFilter(DateFilter filter, [DateTimeRange? customRange]) async {
    final dateRange = filter == DateFilter.customRange && customRange != null
        ? customRange
        : filter.dateRange;

    state = state.copyWith(
      selectedFilter: filter,
      dateRange: dateRange,
      isLoading: true,
      error: null,
    );

    await loadReports();
  }

  Future<void> loadReports() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final startEpoch = state.dateRange.start.millisecondsSinceEpoch;
      final endEpoch = state.dateRange.end.millisecondsSinceEpoch;

      final futures = await Future.wait([
        _database.getTotalSalesByDateRange(startEpoch, endEpoch),
        _database.getOrderCountByDateRange(startEpoch, endEpoch),
        _database.getTotalItemsSoldByDateRange(startEpoch, endEpoch),
        _database.getTopItemsByDateRange(startEpoch, endEpoch),
      ]);

      final totalSales = futures[0] as double;
      final totalOrders = futures[1] as int;
      final totalItemsSold = futures[2] as int;
      final topItems = futures[3] as List<Map<String, dynamic>>;

      final averageOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0.0;

      state = state.copyWith(
        totalSales: totalSales,
        totalOrders: totalOrders,
        totalItemsSold: totalItemsSold,
        averageOrderValue: averageOrderValue,
        topItems: topItems,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsState = ref.watch(reportsProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: Column(
        children: [
          // Date Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: DateFilter.values.length,
              itemBuilder: (context, index) {
                final filter = DateFilter.values[index];
                final isSelected = reportsState.selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter.label),
                    selected: isSelected,
                    onSelected: (selected) async {
                      if (filter == DateFilter.customRange) {
                        final dateRange = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          initialDateRange: reportsState.dateRange,
                        );
                        if (dateRange != null) {
                          ref.read(reportsProvider.notifier).setDateFilter(filter, dateRange);
                        }
                      } else {
                        ref.read(reportsProvider.notifier).setDateFilter(filter);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: reportsState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : reportsState.error != null
                    ? Center(child: Text('Error: ${reportsState.error}'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Summary Cards
                            Row(
                              children: [
                                Expanded(
                                  child: _SummaryCard(
                                    title: 'Total Sales',
                                    value: '${settings.currencySymbol}${reportsState.totalSales.toStringAsFixed(2)}',
                                    icon: Icons.attach_money,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _SummaryCard(
                                    title: 'Total Orders',
                                    value: '${reportsState.totalOrders}',
                                    icon: Icons.receipt_long,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _SummaryCard(
                                    title: 'Items Sold',
                                    value: '${reportsState.totalItemsSold}',
                                    icon: Icons.inventory,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _SummaryCard(
                                    title: 'Avg Order',
                                    value: '${settings.currencySymbol}${reportsState.averageOrderValue.toStringAsFixed(2)}',
                                    icon: Icons.trending_up,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Top Items Section
                            if (reportsState.topItems.isNotEmpty) ...[
                              Text(
                                'Top Selling Items',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 12),
                              Card(
                                child: Column(
                                  children: reportsState.topItems.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final item = entry.value;
                                    return ListTile(
                                      leading: CircleAvatar(
                                        child: Text('${index + 1}'),
                                      ),
                                      title: Text(item['name'] as String),
                                      trailing: Text(
                                        '${item['quantity']} sold',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _exportCSV(context, ref, reportsState, settings),
                                    icon: const Icon(Icons.download),
                                    label: const Text('Export CSV'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (settings.kotEnabled)
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () => _printSummary(context, ref, reportsState, settings),
                                      icon: const Icon(Icons.print),
                                      label: const Text('Print Summary'),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCSV(BuildContext context, WidgetRef ref, ReportsState state, SettingsState settings) async {
    try {
      final csvData = [
        ['Report Period', '${DateFormat('yyyy-MM-dd').format(state.dateRange.start)} to ${DateFormat('yyyy-MM-dd').format(state.dateRange.end)}'],
        ['Generated At', DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())],
        [''],
        ['Metric', 'Value'],
        ['Total Sales', '${settings.currencySymbol}${state.totalSales.toStringAsFixed(2)}'],
        ['Total Orders', '${state.totalOrders}'],
        ['Items Sold', '${state.totalItemsSold}'],
        ['Average Order Value', '${settings.currencySymbol}${state.averageOrderValue.toStringAsFixed(2)}'],
        [''],
        ['Top Items', 'Quantity Sold'],
        ...state.topItems.map((item) => [item['name'], '${item['quantity']}']),
      ];

      final csv = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/qsr_report_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csv);

      await Share.shareXFiles([XFile(file.path)], text: 'QSR Sales Report');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report exported successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting report: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _printSummary(BuildContext context, WidgetRef ref, ReportsState state, SettingsState settings) {
    // TODO: Implement printing summary to thermal printer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Print summary feature will be implemented')),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
