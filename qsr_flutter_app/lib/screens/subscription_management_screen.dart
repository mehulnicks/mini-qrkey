import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';

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
        backgroundColor: Colors.blue.shade600,
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
            _buildUsageItem(
              'Menu Items',
              '8',
              _currentSubscription!.limits.hasUnlimitedMenuItems 
                  ? 'Unlimited' 
                  : _currentSubscription!.limits.maxMenuItems.toString(),
              0.8,
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
            progress > 0.8 ? Colors.red : Colors.blue,
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
            Text(
              'Billing History',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildBillingItem('Oct 2025', 'Premium Plan', '₹499'),
            _buildBillingItem('Sep 2025', 'Premium Plan', '₹499'),
            _buildBillingItem('Aug 2025', 'Free Plan', '₹0'),
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

  void _processUpgrade(SubscriptionPlan plan) {
    // Simulate upgrade process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Upgrade to ${plan.displayName} initiated! Check your email for payment instructions.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
