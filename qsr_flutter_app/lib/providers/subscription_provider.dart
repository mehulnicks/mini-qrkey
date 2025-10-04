import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';

// Current subscription provider
final currentSubscriptionProvider = StateNotifierProvider<SubscriptionNotifier, UserSubscription?>((ref) {
  return SubscriptionNotifier();
});

// Usage statistics provider
final usageStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await SubscriptionService.getUsageStatistics();
});

// Subscription info provider
final subscriptionInfoProvider = Provider<Map<String, dynamic>>((ref) {
  return SubscriptionService.getSubscriptionInfo();
});

class SubscriptionNotifier extends StateNotifier<UserSubscription?> {
  SubscriptionNotifier() : super(null) {
    _initialize();
  }

  Future<void> _initialize() async {
    await SubscriptionService.initialize();
    state = SubscriptionService.getCurrentSubscription();
  }

  Future<void> refresh() async {
    await _initialize();
  }

  Future<bool> upgradeToPremium({
    required SubscriptionBillingCycle billingCycle,
    String? transactionId,
  }) async {
    final success = await SubscriptionService.upgradeToPremium(
      billingCycle: billingCycle,
      transactionId: transactionId,
    );
    
    if (success) {
      state = SubscriptionService.getCurrentSubscription();
    }
    
    return success;
  }

  Future<bool> upgradeToEnterprise({
    required SubscriptionBillingCycle billingCycle,
    String? transactionId,
  }) async {
    final success = await SubscriptionService.upgradeToEnterprise(
      billingCycle: billingCycle,
      transactionId: transactionId,
    );
    
    if (success) {
      state = SubscriptionService.getCurrentSubscription();
    }
    
    return success;
  }

  Future<bool> cancelSubscription() async {
    final success = await SubscriptionService.cancelSubscription();
    
    if (success) {
      state = SubscriptionService.getCurrentSubscription();
    }
    
    return success;
  }

  // Validation methods
  Future<SubscriptionValidation> validateAddMenuItem() async {
    return await SubscriptionService.validateAddMenuItem();
  }

  Future<SubscriptionValidation> validateFeatureAccess(SubscriptionFeature feature) async {
    return await SubscriptionService.validateFeatureAccess(feature);
  }

  // Helper getters
  bool get isFree => state?.plan == SubscriptionPlan.free;
  bool get isPremium => state?.plan == SubscriptionPlan.premium;
  bool get isEnterprise => state?.plan == SubscriptionPlan.enterprise;
  
  SubscriptionLimits get limits => state?.limits ?? SubscriptionLimits.free;
  SubscriptionPlan get plan => state?.plan ?? SubscriptionPlan.free;
}

// Menu item count provider
final menuItemCountProvider = StateNotifierProvider<MenuItemCountNotifier, int>((ref) {
  return MenuItemCountNotifier();
});

class MenuItemCountNotifier extends StateNotifier<int> {
  MenuItemCountNotifier() : super(0) {
    _loadCount();
  }

  Future<void> _loadCount() async {
    final count = await SubscriptionService.getCurrentMenuItemCount();
    state = count;
  }

  Future<void> increment() async {
    final newCount = state + 1;
    await SubscriptionService.updateMenuItemCount(newCount);
    state = newCount;
  }

  Future<void> decrement() async {
    if (state > 0) {
      final newCount = state - 1;
      await SubscriptionService.updateMenuItemCount(newCount);
      state = newCount;
    }
  }

  Future<void> setCount(int count) async {
    await SubscriptionService.updateMenuItemCount(count);
    state = count;
  }

  Future<void> refresh() async {
    await _loadCount();
  }
}

// Feature access providers for quick checks
final canAddMenuItemProvider = FutureProvider<bool>((ref) async {
  final validation = await SubscriptionService.validateAddMenuItem();
  return validation.isValid;
});

final hasAnalyticsAccessProvider = FutureProvider<bool>((ref) async {
  final validation = await SubscriptionService.validateFeatureAccess(SubscriptionFeature.analyticsReports);
  return validation.isValid;
});

final hasMultiDeviceAccessProvider = FutureProvider<bool>((ref) async {
  final validation = await SubscriptionService.validateFeatureAccess(SubscriptionFeature.multipleDevices);
  return validation.isValid;
});

final hasApiAccessProvider = FutureProvider<bool>((ref) async {
  final validation = await SubscriptionService.validateFeatureAccess(SubscriptionFeature.apiAccess);
  return validation.isValid;
});
