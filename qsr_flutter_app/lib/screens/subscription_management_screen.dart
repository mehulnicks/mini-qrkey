import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';
import '../core/theme/qrkey_theme.dart';

class SubscriptionManagementScreen extends ConsumerStatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  ConsumerState<SubscriptionManagementScreen> createState() => _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState extends ConsumerState<SubscriptionManagementScreen> {
  UserSubscription? _currentSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    final subscription = SubscriptionService.getCurrentSubscription();
    setState(() {
      _currentSubscription = subscription;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Management'),
        backgroundColor: QRKeyTheme.primarySaffron, // Blue color
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_currentSubscription == null) {
      return _buildErrorState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentPlanCard(),
          const SizedBox(height: 20),
          if (_currentSubscription!.plan != SubscriptionPlan.free)
            _buildPlanManagementCard(),
          const SizedBox(height: 20),
          _buildUsageCard(),
          const SizedBox(height: 20),
          _buildUpgradeOptionsCard(),
          const SizedBox(height: 20),
          _buildBillingHistoryCard(),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanCard() {
    final plan = _currentSubscription!.plan;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Current Plan',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                _buildPlanBadge(plan),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              plan.displayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${_currentSubscription!.status.displayName}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            if (_currentSubscription!.nextBillingDate != null) ...[
              const SizedBox(height: 8),
              Text(
                'Next billing: ${_formatDate(_currentSubscription!.nextBillingDate!)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
            if (_currentSubscription!.daysRemaining != null) ...[
              const SizedBox(height: 16),
              Text(
                '${_currentSubscription!.daysRemaining} days remaining',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanManagementCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('Cancel Subscription'),
              subtitle: const Text('Downgrade to free plan'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showCancelDialog,
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.receipt, color: QRKeyTheme.primarySaffron),
              title: const Text('Billing Information'),
              subtitle: Text(
                'Billing cycle: ${_currentSubscription!.billingCycle.displayName}',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Billing management coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription'),
        content: const Text(
          'Are you sure you want to cancel your subscription? You will lose access to premium features and be downgraded to the free plan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Subscription'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processCancellation();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Subscription'),
          ),
        ],
      ),
    );
  }

  void _processCancellation() async {
    try {
      final success = await SubscriptionService.cancelSubscription();
      
      if (success) {
        // Reload subscription data
        await _loadSubscription();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription cancelled successfully. You are now on the free plan.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot cancel subscription. You may have too many menu items for the free plan.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cancelling subscription: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildUsageCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>>(
              future: SubscriptionService.getUsageStatistics(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final usage = snapshot.data!;
                final currentItems = usage['currentMenuItems'] as int;
                final maxItems = usage['maxMenuItems'] as int;
                final usagePercentage = usage['menuItemUsagePercentage'] as double;
                final hasUnlimited = usage['hasUnlimitedMenuItems'] as bool;
                
                return Column(
                  children: [
                    _buildUsageItem(
                      'Menu Items',
                      currentItems.toString(),
                      hasUnlimited ? 'Unlimited' : maxItems.toString(),
                      hasUnlimited ? 0.0 : usagePercentage / 100,
                    ),
                    const SizedBox(height: 12),
                    _buildUsageItem(
                      'Order History',
                      '150 orders',
                      _currentSubscription!.limits.hasUnlimitedOrderHistory 
                          ? 'Unlimited' 
                          : '${_currentSubscription!.limits.maxOrderHistoryDays} days',
                      0.3,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageItem(String title, String used, String limit, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('$used / $limit', style: const TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress > 0.8 ? Colors.red : QRKeyTheme.primarySaffron, // Blue color
          ),
        ),
      ],
    );
  }

  Widget _buildUpgradeOptionsCard() {
    if (_currentSubscription!.plan == SubscriptionPlan.enterprise) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upgrade Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (_currentSubscription!.plan == SubscriptionPlan.free) ...[
              _buildUpgradeOption(
                SubscriptionPlan.premium,
                SubscriptionPricing.premiumPricing,
              ),
              const SizedBox(height: 12),
            ],
            _buildUpgradeOption(
              SubscriptionPlan.enterprise,
              SubscriptionPricing.enterprisePricing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeOption(SubscriptionPlan plan, SubscriptionPricing pricing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                plan.displayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _buildPlanBadge(plan),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            pricing.formattedMonthlyPrice,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _upgradeToplan(plan),
              child: Text('Upgrade to ${plan.displayName}'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingHistoryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Billing History',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Detailed billing history coming soon!')),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_currentSubscription!.plan == SubscriptionPlan.free)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.receipt_outlined, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text(
                      'No billing history',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const Text(
                      'You are on the free plan',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              )
            else ...[
              _buildBillingItem(
                _formatDate(_currentSubscription!.startDate),
                '${_currentSubscription!.plan.displayName} Plan',
                _currentSubscription!.pricing.formattedMonthlyPrice.split('/')[0],
              ),
              _buildBillingItem('Sep 2025', 'Premium Plan', '₹499'),
              _buildBillingItem('Aug 2025', 'Free Plan', '₹0'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBillingItem(String date, String plan, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(plan, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            ],
          ),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Unable to load subscription information'),
        ],
      ),
    );
  }

  Widget _buildPlanBadge(SubscriptionPlan plan) {
    Color badgeColor;
    switch (plan) {
      case SubscriptionPlan.free:
        badgeColor = Colors.grey;
        break;
      case SubscriptionPlan.premium:
        badgeColor = Colors.orange;
        break;
      case SubscriptionPlan.enterprise:
        badgeColor = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
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

  void _upgradeToplan(SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upgrade to ${plan.displayName}'),
        content: Text('Are you sure you want to upgrade to the ${plan.displayName} plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processUpgrade(plan);
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  void _processUpgrade(SubscriptionPlan plan) async {
    try {
      bool success = false;
      if (plan == SubscriptionPlan.premium) {
        success = await SubscriptionService.upgradeToPremium(
          billingCycle: SubscriptionBillingCycle.monthly,
        );
      } else if (plan == SubscriptionPlan.enterprise) {
        success = await SubscriptionService.upgradeToEnterprise(
          billingCycle: SubscriptionBillingCycle.monthly,
        );
      }

      if (success) {
        // Reload subscription data
        await _loadSubscription();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully upgraded to ${plan.displayName}!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upgrade failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
