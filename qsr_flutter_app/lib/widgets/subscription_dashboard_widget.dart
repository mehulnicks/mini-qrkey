import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/qrkey_theme.dart';
import '../providers/subscription_provider.dart';
import '../shared/models/subscription_models.dart';
import '../screens/subscription_management_screen.dart';
import '../shared/widgets/premium_upgrade_widgets.dart';

class SubscriptionDashboardWidget extends ConsumerWidget {
  const SubscriptionDashboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(currentSubscriptionProvider);
    final usageStats = ref.watch(usageStatisticsProvider);

    if (subscription == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, subscription),
            const SizedBox(height: 16),
            _buildStatusIndicator(subscription),
            const SizedBox(height: 16),
            usageStats.when(
              data: (stats) => _buildUsageIndicator(stats, subscription),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error loading usage: $error'),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(context, subscription),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserSubscription subscription) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getPlanColor(subscription.plan).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getPlanIcon(subscription.plan),
            color: _getPlanColor(subscription.plan),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${subscription.plan.displayName} Plan',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subscription.status.displayName,
                style: TextStyle(
                  fontSize: 14,
                  color: _getStatusColor(subscription.status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (subscription.plan != SubscriptionPlan.enterprise)
          _buildPlanBadge(subscription.plan),
      ],
    );
  }

  Widget _buildStatusIndicator(UserSubscription subscription) {
    if (subscription.plan == SubscriptionPlan.free) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Upgrade to unlock unlimited features and premium support',
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ),
          ],
        ),
      );
    }

    if (subscription.daysRemaining != null && subscription.daysRemaining! <= 7) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_outlined, color: Colors.red.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Your subscription expires in ${subscription.daysRemaining} days',
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              subscription.nextBillingDate != null
                  ? 'Next billing on ${_formatDate(subscription.nextBillingDate!)}'
                  : 'Subscription is active',
              style: TextStyle(color: Colors.green.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageIndicator(Map<String, dynamic> stats, UserSubscription subscription) {
    final currentItems = stats['currentMenuItems'] as int;
    final maxItems = stats['maxMenuItems'] as int;
    final usagePercentage = stats['menuItemUsagePercentage'] as double;
    final hasUnlimited = stats['hasUnlimitedMenuItems'] as bool;

    if (hasUnlimited) {
      return Row(
        children: [
          Icon(Icons.all_inclusive, color: QRKeyTheme.primarySaffron),
          const SizedBox(width: 8),
          Text(
            'Unlimited menu items ($currentItems items)',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      );
    }

    final color = usagePercentage > 80 ? Colors.red : QRKeyTheme.primarySaffron;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menu Items Usage',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '$currentItems / $maxItems',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: usagePercentage / 100,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        Text(
          usagePercentage > 90
              ? 'Almost at limit! Consider upgrading.'
              : '${(maxItems - currentItems)} remaining',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, UserSubscription subscription) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionManagementScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
            label: const Text('Manage'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: QRKeyTheme.primarySaffron),
              foregroundColor: QRKeyTheme.primarySaffron,
            ),
          ),
        ),
        if (subscription.plan == SubscriptionPlan.free) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PremiumUpgradeScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.upgrade),
              label: const Text('Upgrade'),
              style: ElevatedButton.styleFrom(
                backgroundColor: QRKeyTheme.primarySaffron,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlanBadge(SubscriptionPlan plan) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPlanColor(plan),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        plan.displayName.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getPlanColor(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return Colors.grey;
      case SubscriptionPlan.premium:
        return Colors.orange;
      case SubscriptionPlan.enterprise:
        return Colors.purple;
    }
  }

  IconData _getPlanIcon(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return Icons.free_breakfast;
      case SubscriptionPlan.premium:
        return Icons.star;
      case SubscriptionPlan.enterprise:
        return Icons.business;
    }
  }

  Color _getStatusColor(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return Colors.green;
      case SubscriptionStatus.trial:
        return Colors.blue;
      case SubscriptionStatus.expired:
        return Colors.red;
      case SubscriptionStatus.cancelled:
        return Colors.orange;
      case SubscriptionStatus.suspended:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Compact subscription status widget for dashboard
class CompactSubscriptionWidget extends ConsumerWidget {
  const CompactSubscriptionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(currentSubscriptionProvider);

    if (subscription == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: subscription.plan == SubscriptionPlan.free
            ? Colors.grey.shade100
            : QRKeyTheme.primarySaffron.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: subscription.plan == SubscriptionPlan.free
              ? Colors.grey.shade300
              : QRKeyTheme.primarySaffron.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            subscription.plan == SubscriptionPlan.free ? Icons.free_breakfast : Icons.star,
            size: 16,
            color: subscription.plan == SubscriptionPlan.free
                ? Colors.grey.shade600
                : QRKeyTheme.primarySaffron,
          ),
          const SizedBox(width: 6),
          Text(
            subscription.plan.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: subscription.plan == SubscriptionPlan.free
                  ? Colors.grey.shade600
                  : QRKeyTheme.primarySaffron,
            ),
          ),
          if (subscription.plan == SubscriptionPlan.free) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PremiumUpgradeScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: QRKeyTheme.primarySaffron,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'UPGRADE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
