import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';
import '../shared/widgets/premium_upgrade_widgets.dart';
import '../screens/freemium_menu_screen.dart';

// Freemium Demo & Test Screen
class FreemiumDemoScreen extends ConsumerStatefulWidget {
  const FreemiumDemoScreen({super.key});

  @override
  ConsumerState<FreemiumDemoScreen> createState() => _FreemiumDemoScreenState();
}

class _FreemiumDemoScreenState extends ConsumerState<FreemiumDemoScreen> {
  Map<String, dynamic>? subscriptionInfo;
  Map<String, dynamic>? usageStats;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionData();
  }

  Future<void> _loadSubscriptionData() async {
    final info = SubscriptionService.getSubscriptionInfo();
    final usage = await SubscriptionService.getUsageStatistics();
    
    setState(() {
      subscriptionInfo = info;
      usageStats = usage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'QSR Freemium Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 16),
            _buildSubscriptionStatusCard(),
            const SizedBox(height: 16),
            _buildUsageStatsCard(),
            const SizedBox(height: 16),
            _buildFeaturesCard(),
            const SizedBox(height: 16),
            _buildActionsCard(),
            const SizedBox(height: 16),
            _buildTestingCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9933), Color(0xFFFFB366)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to QSR Management!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start with our free plan and upgrade anytime for unlimited features.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FreemiumMenuScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFFF9933),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Manage Menu Items',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionStatusCard() {
    if (subscriptionInfo == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final plan = subscriptionInfo!['plan'] as String;
    final isValid = subscriptionInfo!['isValid'] as bool;
    final features = subscriptionInfo!['features'] as List<String>;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  plan == 'Free' ? Icons.free_breakfast : Icons.star,
                  color: plan == 'Free' ? Colors.grey.shade600 : const Color(0xFFFF9933),
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Plan: $plan',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isValid ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isValid ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isValid ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Included Features:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (features.isEmpty)
              Text(
                'No active features',
                style: TextStyle(color: Colors.grey.shade600),
              )
            else
              ...features.take(3).map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 16, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    Text(feature),
                  ],
                ),
              )),
            if (features.length > 3)
              Text(
                '+${features.length - 3} more features',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageStatsCard() {
    if (usageStats == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final currentItems = usageStats!['currentMenuItems'] as int;
    final remaining = usageStats!['remainingMenuItems'] as String;
    final percentage = usageStats!['menuItemUsagePercentage'] as double;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.restaurant_menu, color: Color(0xFFFF9933)),
                const SizedBox(width: 8),
                const Text(
                  'Menu Items Usage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Items: $currentItems',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Remaining: $remaining',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                CircularProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage > 80 ? Colors.red : const Color(0xFFFF9933),
                  ),
                ),
              ],
            ),
            if (percentage > 80) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You\'re approaching your limit. Consider upgrading to Premium.',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    final plans = PlanComparison.getAllPlans();
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.star, color: Color(0xFFFF9933)),
                SizedBox(width: 8),
                Text(
                  'Plan Comparison',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...plans.map((plan) => _buildPlanComparisonRow(plan)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanComparisonRow(PlanComparison plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: plan.plan == SubscriptionPlan.free 
            ? Colors.grey.shade50 
            : plan.isRecommended 
                ? const Color(0xFFFF9933).withOpacity(0.05)
                : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: plan.isRecommended 
              ? const Color(0xFFFF9933).withOpacity(0.3)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                plan.plan.displayName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (plan.isRecommended) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9933),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'RECOMMENDED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                plan.plan == SubscriptionPlan.free 
                    ? 'Free' 
                    : plan.pricing.formattedMonthlyPrice,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: plan.plan == SubscriptionPlan.free 
                      ? Colors.grey.shade600 
                      : const Color(0xFFFF9933),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...plan.features.take(2).map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              children: [
                Icon(
                  Icons.check,
                  size: 14,
                  color: plan.plan == SubscriptionPlan.free 
                      ? Colors.grey.shade600 
                      : Colors.green,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.settings, color: Color(0xFFFF9933)),
                SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              'Menu Management',
              'Add, edit, and manage your menu items',
              Icons.restaurant_menu,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FreemiumMenuScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'Upgrade to Premium',
              'Unlock unlimited menu items and advanced features',
              Icons.upgrade,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PremiumUpgradeScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              'View Subscription',
              'Check your current plan and usage',
              Icons.info_outline,
              () {
                _showSubscriptionDetails();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9933).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: const Color(0xFFFF9933), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTestingCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.science, color: Color(0xFFFF9933)),
                SizedBox(width: 8),
                Text(
                  'Testing & Demo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Use these controls to test the freemium functionality:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await SubscriptionService.setMenuItemCountForTesting(9);
                      _loadSubscriptionData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Set to 9 items (near limit)')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Set Near Limit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await SubscriptionService.setMenuItemCountForTesting(10);
                      _loadSubscriptionData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Set to 10 items (at limit)')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Set At Limit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await SubscriptionService.resetToFree();
                  _loadSubscriptionData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reset to free plan with 0 items')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reset to Free (0 items)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subscription Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subscriptionInfo != null) ...[
                _buildDetailRow('Plan', subscriptionInfo!['plan']),
                _buildDetailRow('Status', subscriptionInfo!['status']),
                _buildDetailRow('Valid', subscriptionInfo!['isValid'].toString()),
                const SizedBox(height: 12),
                const Text('Limits:', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildDetailRow('Max Menu Items', subscriptionInfo!['limits']['maxMenuItems']),
                _buildDetailRow('Order History', subscriptionInfo!['limits']['maxOrderHistoryDays']),
              ],
              if (usageStats != null) ...[
                const SizedBox(height: 12),
                const Text('Usage:', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildDetailRow('Current Items', usageStats!['currentMenuItems'].toString()),
                _buildDetailRow('Remaining', usageStats!['remainingMenuItems']),
              ],
            ],
          ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
