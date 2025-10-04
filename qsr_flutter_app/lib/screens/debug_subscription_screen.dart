import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';
import '../core/theme/qrkey_theme.dart';
import '../providers/subscription_provider.dart';

class DebugSubscriptionScreen extends ConsumerStatefulWidget {
  const DebugSubscriptionScreen({super.key});

  @override
  ConsumerState<DebugSubscriptionScreen> createState() => _DebugSubscriptionScreenState();
}

class _DebugSubscriptionScreenState extends ConsumerState<DebugSubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    final subscription = ref.watch(currentSubscriptionProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Subscription'),
        backgroundColor: QRKeyTheme.primarySaffron,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Subscription Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (subscription != null) ...[
                      _buildStatusItem('Plan', subscription.plan.displayName),
                      _buildStatusItem('Status', subscription.status.displayName),
                      _buildStatusItem('Start Date', _formatDate(subscription.startDate)),
                      if (subscription.endDate != null)
                        _buildStatusItem('End Date', _formatDate(subscription.endDate!)),
                      _buildStatusItem('Menu Items Limit', 
                        subscription.limits.hasUnlimitedMenuItems 
                          ? 'Unlimited' 
                          : '${subscription.limits.maxMenuItems}'),
                    ] else ...[
                      const Text('No subscription data found'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _upgradeToPremium(),
                        icon: const Icon(Icons.star),
                        label: const Text('Upgrade to Premium'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: QRKeyTheme.primarySaffron,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _upgradeToEnterprise(),
                        icon: const Icon(Icons.business),
                        label: const Text('Upgrade to Enterprise'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _resetToFree(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset to Free Plan'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade600),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Features',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureTest('Analytics', () => _testAnalytics()),
                    _buildFeatureTest('API Access', () => _testApiAccess()),
                    _buildFeatureTest('Priority Support', () => _testPrioritySupport()),
                    _buildFeatureTest('Advanced Reports', () => _testAdvancedReports()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildFeatureTest(String feature, VoidCallback onTest) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(feature),
          ElevatedButton(
            onPressed: onTest,
            style: ElevatedButton.styleFrom(
              backgroundColor: QRKeyTheme.primarySaffron,
              foregroundColor: Colors.white,
              minimumSize: const Size(60, 36),
            ),
            child: const Text('Test'),
          ),
        ],
      ),
    );
  }

  Future<void> _upgradeToPremium() async {
    try {
      final success = await SubscriptionService.upgradeToTestPremium();
      if (success) {
        // Refresh the provider
        ref.invalidate(currentSubscriptionProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully upgraded to Premium!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upgrade failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _upgradeToEnterprise() async {
    try {
      final success = await SubscriptionService.upgradeToTestEnterprise();
      if (success) {
        // Refresh the provider
        ref.invalidate(currentSubscriptionProvider);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully upgraded to Enterprise!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upgrade failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resetToFree() async {
    try {
      await SubscriptionService.clearCache();
      await SubscriptionService.initialize();
      
      // Refresh the provider
      ref.invalidate(currentSubscriptionProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset to Free plan successfully!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reset failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _testAnalytics() {
    final subscription = ref.read(currentSubscriptionProvider);
    if (subscription?.limits.analyticsEnabled == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Analytics access granted!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Analytics requires Premium or Enterprise plan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _testApiAccess() {
    final subscription = ref.read(currentSubscriptionProvider);
    if (subscription?.limits.apiAccessEnabled == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ API access granted!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ API access requires Enterprise plan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _testPrioritySupport() {
    final subscription = ref.read(currentSubscriptionProvider);
    if (subscription?.limits.prioritySupport == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Priority support available!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Priority support requires Premium or Enterprise plan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _testAdvancedReports() {
    final subscription = ref.read(currentSubscriptionProvider);
    if (subscription?.limits.advancedReportsEnabled == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Advanced reports access granted!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Advanced reports require Premium or Enterprise plan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
