import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subscription_models.dart';
import '../../services/subscription_service.dart';

// Premium Upgrade Screen
class PremiumUpgradeScreen extends ConsumerStatefulWidget {
  final SubscriptionFeature? requiredFeature;
  final bool showCloseButton;

  const PremiumUpgradeScreen({
    super.key,
    this.requiredFeature,
    this.showCloseButton = true,
  });

  @override
  ConsumerState<PremiumUpgradeScreen> createState() => _PremiumUpgradeScreenState();
}

class _PremiumUpgradeScreenState extends ConsumerState<PremiumUpgradeScreen> {
  SubscriptionBillingCycle selectedBillingCycle = SubscriptionBillingCycle.yearly;
  SubscriptionPlan selectedPlan = SubscriptionPlan.premium;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.showCloseButton 
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'Choose Your Plan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.requiredFeature != null) ...[
              _buildFeatureRequiredHeader(),
              const SizedBox(height: 24),
            ],
            _buildPlanComparison(),
            const SizedBox(height: 24),
            _buildBillingCycleSelector(),
            const SizedBox(height: 24),
            _buildSelectedPlanSummary(),
            const SizedBox(height: 32),
            _buildUpgradeButton(),
            const SizedBox(height: 16),
            _buildFeaturesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRequiredHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.lock, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Feature Required',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.requiredFeature!.displayName} is available in Premium plan',
                  style: TextStyle(color: Colors.orange.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanComparison() {
    final plans = PlanComparison.getAllPlans();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Plan',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...plans.map((plan) => _buildPlanCard(plan)),
      ],
    );
  }

  Widget _buildPlanCard(PlanComparison plan) {
    final isSelected = selectedPlan == plan.plan;
    final canSelect = plan.plan != SubscriptionPlan.free;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? const Color(0xFFFF9933) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: plan.plan == SubscriptionPlan.free 
            ? Colors.grey.shade100 
            : isSelected 
                ? const Color(0xFFFF9933).withOpacity(0.05)
                : Colors.white,
      ),
      child: Stack(
        children: [
          if (plan.isRecommended)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9933),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  'RECOMMENDED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<SubscriptionPlan>(
                      value: plan.plan,
                      groupValue: selectedPlan,
                      onChanged: canSelect ? (value) {
                        if (value != null) {
                          setState(() => selectedPlan = value);
                        }
                      } : null,
                      activeColor: const Color(0xFFFF9933),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.plan.displayName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (plan.plan != SubscriptionPlan.free) ...[
                            const SizedBox(height: 4),
                            Text(
                              selectedBillingCycle == SubscriptionBillingCycle.monthly
                                  ? plan.pricing.formattedMonthlyPrice
                                  : plan.pricing.formattedYearlyPrice,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF9933),
                              ),
                            ),
                            if (selectedBillingCycle == SubscriptionBillingCycle.yearly)
                              Text(
                                'Save ₹${plan.pricing.monthlySavings.toStringAsFixed(0)}/year',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ] else
                            const Text(
                              'Free Forever',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...plan.features.take(4).map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: 16,
                        color: plan.plan == SubscriptionPlan.free 
                            ? Colors.grey.shade600 
                            : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 13,
                            color: plan.plan == SubscriptionPlan.free 
                                ? Colors.grey.shade600 
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                if (plan.features.length > 4)
                  Text(
                    '+${plan.features.length - 4} more features',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingCycleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedBillingCycle = SubscriptionBillingCycle.monthly),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedBillingCycle == SubscriptionBillingCycle.monthly
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Monthly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: selectedBillingCycle == SubscriptionBillingCycle.monthly
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedBillingCycle = SubscriptionBillingCycle.yearly),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedBillingCycle == SubscriptionBillingCycle.yearly
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Yearly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: selectedBillingCycle == SubscriptionBillingCycle.yearly
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (selectedBillingCycle == SubscriptionBillingCycle.yearly)
                      Text(
                        'Save 17%',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPlanSummary() {
    if (selectedPlan == SubscriptionPlan.free) return const SizedBox.shrink();
    
    final pricing = selectedPlan == SubscriptionPlan.premium 
        ? SubscriptionPricing.premiumPricing 
        : SubscriptionPricing.enterprisePricing;
    
    final amount = selectedBillingCycle == SubscriptionBillingCycle.monthly
        ? pricing.monthlyPrice
        : pricing.yearlyPrice;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9933).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF9933).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${selectedPlan.displayName} ${selectedBillingCycle.displayName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9933),
                ),
              ),
            ],
          ),
          if (selectedBillingCycle == SubscriptionBillingCycle.yearly) ...[
            const SizedBox(height: 8),
            Text(
              'That\'s just ₹${(amount / 12).toStringAsFixed(0)}/month',
              style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpgradeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isProcessing ? null : _handleUpgrade,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9933),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                selectedPlan == SubscriptionPlan.free 
                    ? 'Continue with Free Plan'
                    : 'Upgrade to ${selectedPlan.displayName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What you get with Premium:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(Icons.restaurant_menu, 'Unlimited Menu Items', 'Add as many dishes as you want'),
        _buildFeatureItem(Icons.analytics, 'Advanced Analytics', 'Detailed sales reports and insights'),
        _buildFeatureItem(Icons.sync, 'Multi-Device Sync', 'Access from multiple devices'),
        _buildFeatureItem(Icons.support_agent, 'Priority Support', '24/7 customer support'),
        _buildFeatureItem(Icons.palette, 'Custom Branding', 'Personalize your restaurant app'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9933).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFFFF9933),
            ),
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
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleUpgrade() async {
    if (selectedPlan == SubscriptionPlan.free) {
      Navigator.pop(context);
      return;
    }

    setState(() => isProcessing = true);

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));
      
      bool success = false;
      if (selectedPlan == SubscriptionPlan.premium) {
        success = await SubscriptionService.upgradeToPremium(
          billingCycle: selectedBillingCycle,
          transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        );
      } else if (selectedPlan == SubscriptionPlan.enterprise) {
        success = await SubscriptionService.upgradeToEnterprise(
          billingCycle: selectedBillingCycle,
          transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully upgraded to ${selectedPlan.displayName}!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upgrade failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }
}

// Menu Item Limit Dialog
class MenuItemLimitDialog extends StatelessWidget {
  final SubscriptionValidation validation;

  const MenuItemLimitDialog({
    super.key,
    required this.validation,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFFF9933),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Free Plan Limit Reached',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            validation.errorMessage ?? 'You have reached the limit for free plan.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF9933)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFFFF9933)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PremiumUpgradeScreen(
                          requiredFeature: validation.requiredFeature,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9933),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Upgrade'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Subscription Status Widget
class SubscriptionStatusWidget extends ConsumerWidget {
  const SubscriptionStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = SubscriptionService.currentSubscription;
    
    if (subscription == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: subscription.plan == SubscriptionPlan.free 
            ? Colors.grey.shade100 
            : const Color(0xFFFF9933).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: subscription.plan == SubscriptionPlan.free 
              ? Colors.grey.shade300 
              : const Color(0xFFFF9933).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                subscription.plan == SubscriptionPlan.free 
                    ? Icons.free_breakfast 
                    : Icons.star,
                color: subscription.plan == SubscriptionPlan.free 
                    ? Colors.grey.shade600 
                    : const Color(0xFFFF9933),
              ),
              const SizedBox(width: 8),
              Text(
                '${subscription.plan.displayName} Plan',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (subscription.plan == SubscriptionPlan.free)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PremiumUpgradeScreen(),
                      ),
                    );
                  },
                  child: const Text('Upgrade'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<Map<String, dynamic>>(
            future: SubscriptionService.getUsageStatistics(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator(strokeWidth: 2);
              }
              
              final usage = snapshot.data!;
              final currentItems = usage['currentMenuItems'] as int;
              final remaining = usage['remainingMenuItems'] as String;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu Items: $currentItems ${subscription.limits.hasUnlimitedMenuItems ? '' : '/ ${subscription.limits.maxMenuItems}'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (!subscription.limits.hasUnlimitedMenuItems) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (usage['menuItemUsagePercentage'] as double) / 100,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        (usage['menuItemUsagePercentage'] as double) > 80 
                            ? Colors.red 
                            : const Color(0xFFFF9933),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Remaining: $remaining',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
