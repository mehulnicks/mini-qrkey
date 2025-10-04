import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/qrkey_theme.dart';
import '../providers/subscription_provider.dart';
import '../shared/models/subscription_models.dart';
import '../services/subscription_service.dart';

class SubscriptionMetricsWidget extends ConsumerWidget {
  final bool showTitle;
  final bool compact;

  const SubscriptionMetricsWidget({
    super.key,
    this.showTitle = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(currentSubscriptionProvider);
    final usageStats = ref.watch(usageStatisticsProvider);

    if (subscription == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle) ...[
              Text(
                'Subscription Analytics',
                style: TextStyle(
                  fontSize: compact ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: compact ? 12 : 16),
            ],
            usageStats.when(
              data: (stats) => _buildMetrics(stats, subscription, compact),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error loading metrics: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetrics(Map<String, dynamic> stats, UserSubscription subscription, bool compact) {
    return Column(
      children: [
        _buildUsageMetrics(stats, compact),
        SizedBox(height: compact ? 12 : 16),
        _buildLimitMetrics(stats, subscription, compact),
        if (!compact) ...[
          const SizedBox(height: 16),
          _buildFeatureAvailability(subscription),
        ],
      ],
    );
  }

  Widget _buildUsageMetrics(Map<String, dynamic> stats, bool compact) {
    final currentItems = stats['currentMenuItems'] as int;
    final maxItems = stats['maxMenuItems'] as int;
    final usagePercentage = stats['menuItemUsagePercentage'] as double;
    final hasUnlimited = stats['hasUnlimitedMenuItems'] as bool;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Usage',
          style: TextStyle(
            fontSize: compact ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: compact ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Menu Items',
                hasUnlimited ? '$currentItems' : '$currentItems / $maxItems',
                hasUnlimited ? Icons.all_inclusive : Icons.restaurant_menu,
                usagePercentage > 80 && !hasUnlimited ? Colors.red : QRKeyTheme.primarySaffron,
                compact,
              ),
            ),
            SizedBox(width: compact ? 8 : 12),
            Expanded(
              child: _buildMetricCard(
                'Usage %',
                hasUnlimited ? '∞' : '${usagePercentage.toStringAsFixed(1)}%',
                Icons.pie_chart,
                usagePercentage > 80 && !hasUnlimited ? Colors.red : Colors.green,
                compact,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLimitMetrics(Map<String, dynamic> stats, UserSubscription subscription, bool compact) {
    final limits = SubscriptionService.getLimitsForPlan(subscription.plan);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan Limits',
          style: TextStyle(
            fontSize: compact ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: compact ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Max Items',
                limits.hasUnlimitedMenuItems ? '∞' : '${limits.maxMenuItems}',
                Icons.inventory,
                QRKeyTheme.primarySaffron,
                compact,
              ),
            ),
            SizedBox(width: compact ? 8 : 12),
            Expanded(
              child: _buildMetricCard(
                'Order History',
                limits.hasUnlimitedOrderHistory ? '∞' : '${limits.maxOrderHistoryDays} days',
                Icons.history,
                Colors.blue,
                compact,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureAvailability(UserSubscription subscription) {
    final features = _getAvailableFeatures(subscription.plan);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Features',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: features.map((feature) => _buildFeatureChip(feature)).toList(),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, bool compact) {
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: compact ? 18 : 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: compact ? 12 : 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 4 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: compact ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(FeatureInfo feature) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: feature.available ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: feature.available ? Colors.green.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            feature.available ? Icons.check_circle : Icons.lock,
            size: 16,
            color: feature.available ? Colors.green.shade600 : Colors.grey.shade500,
          ),
          const SizedBox(width: 6),
          Text(
            feature.name,
            style: TextStyle(
              fontSize: 12,
              color: feature.available ? Colors.green.shade700 : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<FeatureInfo> _getAvailableFeatures(SubscriptionPlan plan) {
    final allFeatures = [
      FeatureInfo('Menu Management', true),
      FeatureInfo('Order Processing', true),
      FeatureInfo('Basic Reports', true),
      FeatureInfo('Premium Analytics', plan != SubscriptionPlan.free),
      FeatureInfo('API Access', plan == SubscriptionPlan.enterprise),
      FeatureInfo('Priority Support', plan != SubscriptionPlan.free),
      FeatureInfo('Custom Branding', plan == SubscriptionPlan.enterprise),
      FeatureInfo('Advanced Integrations', plan == SubscriptionPlan.enterprise),
    ];

    return allFeatures;
  }
}

class FeatureInfo {
  final String name;
  final bool available;

  FeatureInfo(this.name, this.available);
}

// Quick metrics overview for main dashboard
class QuickMetricsWidget extends ConsumerWidget {
  const QuickMetricsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(currentSubscriptionProvider);
    final usageStats = ref.watch(usageStatisticsProvider);

    if (subscription == null) {
      return const SizedBox.shrink();
    }

    return usageStats.when(
      data: (stats) {
        final currentItems = stats['currentMenuItems'] as int;
        final maxItems = stats['maxMenuItems'] as int;
        final hasUnlimited = stats['hasUnlimitedMenuItems'] as bool;
        final usagePercentage = stats['menuItemUsagePercentage'] as double;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: QRKeyTheme.primarySaffron.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                hasUnlimited ? Icons.all_inclusive : Icons.restaurant_menu,
                color: QRKeyTheme.primarySaffron,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu Items',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      hasUnlimited ? '$currentItems items' : '$currentItems / $maxItems',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (!hasUnlimited) ...[
                const SizedBox(width: 8),
                CircularProgressIndicator(
                  value: usagePercentage / 100,
                  strokeWidth: 3,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    usagePercentage > 80 ? Colors.red : QRKeyTheme.primarySaffron,
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
