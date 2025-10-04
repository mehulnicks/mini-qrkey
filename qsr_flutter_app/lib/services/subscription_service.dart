import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/models/subscription_models.dart';

// Subscription Service for managing freemium features
class SubscriptionService {
  static const String _subscriptionKey = 'user_subscription';
  static const String _menuItemCountKey = 'menu_item_count';
  
  // Premium user email
  static const String _premiumUserEmail = 'mehulnicks@gmail.com';
  
  static UserSubscription? _currentSubscription;
  
  // Initialize with free subscription if none exists
  static Future<void> initialize() async {
    _currentSubscription = await _loadSubscription();
    
    // Check if current user is the premium email
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email == _premiumUserEmail) {
      // Automatically upgrade to premium for this specific email
      await _upgradeToPremiumForSpecialUser();
    } else if (_currentSubscription == null) {
      _currentSubscription = UserSubscription.free();
      await _saveSubscription(_currentSubscription!);
    }
  }
  
  // Private method to upgrade specific user to premium
  static Future<void> _upgradeToPremiumForSpecialUser() async {
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 365 * 10)); // 10 years from now
    
    final premiumSubscription = UserSubscription(
      id: 'special_premium_user',
      plan: SubscriptionPlan.premium,
      status: SubscriptionStatus.active,
      startDate: now,
      endDate: endDate,
      billingCycle: SubscriptionBillingCycle.yearly,
      nextBillingDate: endDate,
      transactionId: 'special_premium_user',
      limits: SubscriptionLimits.premium,
      pricing: SubscriptionPricing.premiumPricing,
    );
    
    _currentSubscription = premiumSubscription;
    await _saveSubscription(premiumSubscription);
    print('Premium subscription activated for special user: $_premiumUserEmail');
  }
  
  // Get current subscription
  static UserSubscription? get currentSubscription => _currentSubscription;
  
  // Get current subscription (method version for compatibility)
  static UserSubscription? getCurrentSubscription() => _currentSubscription;
  
  // Get current subscription plan
  static SubscriptionPlan get currentPlan => _currentSubscription?.plan ?? SubscriptionPlan.free;
  
  // Check if user is on free plan
  static bool get isFreeUser => currentPlan == SubscriptionPlan.free;
  
  // Check if user is on premium plan
  static bool get isPremiumUser => currentPlan == SubscriptionPlan.premium;
  
  // Check if user is on enterprise plan
  static bool get isEnterpriseUser => currentPlan == SubscriptionPlan.enterprise;
  
  // Get current subscription limits
  static SubscriptionLimits get currentLimits => _currentSubscription?.limits ?? SubscriptionLimits.free;
  
  // Validate if user can add a new menu item
  static Future<SubscriptionValidation> validateAddMenuItem() async {
    if (_currentSubscription == null) {
      await initialize();
    }
    
    final currentCount = await getCurrentMenuItemCount();
    final subscription = _currentSubscription!;
    
    if (!subscription.isValid) {
      return const SubscriptionValidation.invalid(
        errorMessage: 'Your subscription has expired. Please renew to continue adding menu items.',
        errorMessageHindi: 'आपकी सदस्यता समाप्त हो गई है। मेन्यू आइटम जोड़ना जारी रखने के लिए कृपया नवीनीकरण करें।',
        requiredFeature: SubscriptionFeature.menuItemLimit,
        suggestedPlan: SubscriptionPlan.premium,
      );
    }
    
    if (!subscription.canAddMenuItem(currentCount)) {
      if (subscription.plan == SubscriptionPlan.free) {
        return const SubscriptionValidation.invalid(
          errorMessage: 'Free plan limit reached! You can add up to 10 menu items. Upgrade to Premium for unlimited items.',
          errorMessageHindi: 'निःशुल्क योजना सीमा पूरी हो गई! आप 10 तक मेन्यू आइटम जोड़ सकते हैं। असीमित आइटम के लिए प्रीमियम में अपग्रेड करें।',
          requiredFeature: SubscriptionFeature.menuItemLimit,
          suggestedPlan: SubscriptionPlan.premium,
        );
      } else {
        return const SubscriptionValidation.invalid(
          errorMessage: 'Menu item limit reached for your current plan.',
          errorMessageHindi: 'आपकी वर्तमान योजना के लिए मेन्यू आइटम सीमा पूरी हो गई।',
          requiredFeature: SubscriptionFeature.menuItemLimit,
        );
      }
    }
    
    return const SubscriptionValidation.valid();
  }
  
  // Validate if user can access a specific feature
  static SubscriptionValidation validateFeatureAccess(SubscriptionFeature feature) {
    if (_currentSubscription == null) {
      return const SubscriptionValidation.invalid(
        errorMessage: 'No subscription found. Please restart the app.',
        errorMessageHindi: 'कोई सदस्यता नहीं मिली। कृपया ऐप को पुनः आरंभ करें।',
      );
    }
    
    if (!_currentSubscription!.hasFeature(feature)) {
      switch (feature) {
        case SubscriptionFeature.analyticsReports:
          return SubscriptionValidation.invalid(
            errorMessage: 'Analytics & Reports are available in Premium plan.',
            errorMessageHindi: 'विश्लेषण और रिपोर्ट प्रीमियम योजना में उपलब्ध हैं।',
            requiredFeature: feature,
            suggestedPlan: SubscriptionPlan.premium,
          );
        case SubscriptionFeature.multipleDevices:
          return SubscriptionValidation.invalid(
            errorMessage: 'Multiple device sync is available in Premium plan.',
            errorMessageHindi: 'कई डिवाइस सिंक प्रीमियम योजना में उपलब्ध है।',
            requiredFeature: feature,
            suggestedPlan: SubscriptionPlan.premium,
          );
        case SubscriptionFeature.prioritySupport:
          return SubscriptionValidation.invalid(
            errorMessage: 'Priority support is available in Premium plan.',
            errorMessageHindi: 'प्राथमिकता समर्थन प्रीमियम योजना में उपलब्ध है।',
            requiredFeature: feature,
            suggestedPlan: SubscriptionPlan.premium,
          );
        case SubscriptionFeature.advancedReports:
          return SubscriptionValidation.invalid(
            errorMessage: 'Advanced reports are available in Premium plan.',
            errorMessageHindi: 'उन्नत रिपोर्ट प्रीमियम योजना में उपलब्ध हैं।',
            requiredFeature: feature,
            suggestedPlan: SubscriptionPlan.premium,
          );
        case SubscriptionFeature.apiAccess:
          return SubscriptionValidation.invalid(
            errorMessage: 'API access is available in Enterprise plan.',
            errorMessageHindi: 'API पहुंच एंटरप्राइज योजना में उपलब्ध है।',
            requiredFeature: feature,
            suggestedPlan: SubscriptionPlan.enterprise,
          );
        default:
          return SubscriptionValidation.invalid(
            errorMessage: 'This feature requires a premium subscription.',
            errorMessageHindi: 'इस सुविधा के लिए प्रीमियम सदस्यता की आवश्यकता है।',
            requiredFeature: feature,
            suggestedPlan: SubscriptionPlan.premium,
          );
      }
    }
    
    return const SubscriptionValidation.valid();
  }
  
  // Get current menu item count
  static Future<int> getCurrentMenuItemCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_menuItemCountKey) ?? 0;
  }
  
  // Update menu item count
  static Future<void> updateMenuItemCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_menuItemCountKey, count);
  }
  
  // Increment menu item count
  static Future<void> incrementMenuItemCount() async {
    final currentCount = await getCurrentMenuItemCount();
    await updateMenuItemCount(currentCount + 1);
  }
  
  // Decrement menu item count
  static Future<void> decrementMenuItemCount() async {
    final currentCount = await getCurrentMenuItemCount();
    await updateMenuItemCount((currentCount - 1).clamp(0, double.infinity).toInt());
  }
  
  // Get remaining menu item slots for current user
  static Future<int> getRemainingMenuItemSlots() async {
    if (_currentSubscription == null) {
      await initialize();
    }
    
    final currentCount = await getCurrentMenuItemCount();
    return _currentSubscription!.getRemainingMenuItemSlots(currentCount);
  }
  
  // Check if user can add more menu items
  static Future<bool> canAddMoreMenuItems() async {
    final remaining = await getRemainingMenuItemSlots();
    return remaining == -1 || remaining > 0; // -1 means unlimited
  }
  
  // Upgrade subscription
  static Future<bool> upgradeToPremium({
    required SubscriptionBillingCycle billingCycle,
    String? transactionId,
  }) async {
    if (_currentSubscription == null) {
      await initialize();
    }
    
    final now = DateTime.now();
    final endDate = billingCycle == SubscriptionBillingCycle.monthly
        ? now.add(const Duration(days: 30))
        : now.add(const Duration(days: 365));
    
    final upgradedSubscription = _currentSubscription!.copyWith(
      plan: SubscriptionPlan.premium,
      status: SubscriptionStatus.active,
      billingCycle: billingCycle,
      endDate: endDate,
      nextBillingDate: endDate,
      transactionId: transactionId,
      limits: SubscriptionLimits.premium,
      pricing: SubscriptionPricing.premiumPricing,
    );
    
    _currentSubscription = upgradedSubscription;
    await _saveSubscription(upgradedSubscription);
    
    return true;
  }
  
  // Upgrade to enterprise
  static Future<bool> upgradeToEnterprise({
    required SubscriptionBillingCycle billingCycle,
    String? transactionId,
  }) async {
    if (_currentSubscription == null) {
      await initialize();
    }
    
    final now = DateTime.now();
    final endDate = billingCycle == SubscriptionBillingCycle.monthly
        ? now.add(const Duration(days: 30))
        : now.add(const Duration(days: 365));
    
    final upgradedSubscription = _currentSubscription!.copyWith(
      plan: SubscriptionPlan.enterprise,
      status: SubscriptionStatus.active,
      billingCycle: billingCycle,
      endDate: endDate,
      nextBillingDate: endDate,
      transactionId: transactionId,
      limits: SubscriptionLimits.enterprise,
      pricing: SubscriptionPricing.enterprisePricing,
    );
    
    _currentSubscription = upgradedSubscription;
    await _saveSubscription(upgradedSubscription);
    
    return true;
  }
  
  // Cancel subscription (revert to free)
  static Future<bool> cancelSubscription() async {
    if (_currentSubscription == null) {
      await initialize();
    }
    
    // Check if menu items exceed free limit
    final currentCount = await getCurrentMenuItemCount();
    if (currentCount > SubscriptionLimits.free.maxMenuItems) {
      return false; // Cannot downgrade if exceeding free limits
    }
    
    final cancelledSubscription = UserSubscription.free();
    _currentSubscription = cancelledSubscription;
    await _saveSubscription(cancelledSubscription);
    
    return true;
  }
  
  // Get subscription status info
  static Map<String, dynamic> getSubscriptionInfo() {
    if (_currentSubscription == null) {
      return {
        'plan': 'Unknown',
        'status': 'Unknown',
        'isValid': false,
        'daysRemaining': null,
        'features': <String>[],
      };
    }
    
    final sub = _currentSubscription!;
    return {
      'plan': sub.plan.displayName,
      'status': sub.status.displayName,
      'isValid': sub.isValid,
      'daysRemaining': sub.daysRemaining,
      'features': _getAvailableFeatures(),
      'limits': {
        'maxMenuItems': sub.limits.maxMenuItems == -1 ? 'Unlimited' : sub.limits.maxMenuItems.toString(),
        'maxOrderHistoryDays': sub.limits.maxOrderHistoryDays == -1 ? 'Unlimited' : sub.limits.maxOrderHistoryDays.toString(),
      },
    };
  }
  
  // Private helper methods
  static Future<UserSubscription?> _loadSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionJson = prefs.getString(_subscriptionKey);
      if (subscriptionJson != null) {
        return UserSubscription.fromJson(jsonDecode(subscriptionJson));
      }
    } catch (e) {
      print('Error loading subscription: $e');
    }
    return null;
  }
  
  static Future<void> _saveSubscription(UserSubscription subscription) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_subscriptionKey, jsonEncode(subscription.toJson()));
    } catch (e) {
      print('Error saving subscription: $e');
    }
  }
  
  static List<String> _getAvailableFeatures() {
    if (_currentSubscription == null) return [];
    
    final features = <String>[];
    for (final feature in SubscriptionFeature.values) {
      if (_currentSubscription!.hasFeature(feature)) {
        features.add(feature.displayName);
      }
    }
    return features;
  }
  
  // Reset subscription to free (for testing)
  static Future<void> resetToFree() async {
    _currentSubscription = UserSubscription.free();
    await _saveSubscription(_currentSubscription!);
    await updateMenuItemCount(0);
  }
  
  // Get limits for a specific plan
  static SubscriptionLimits getLimitsForPlan(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return const SubscriptionLimits(
          maxMenuItems: 10,
          maxOrderHistoryDays: 7,
          analyticsEnabled: false,
          multiDeviceSync: false,
          prioritySupport: false,
          customizationEnabled: false,
          advancedReportsEnabled: false,
          apiAccessEnabled: false,
        );
      case SubscriptionPlan.premium:
        return const SubscriptionLimits(
          maxMenuItems: -1,
          maxOrderHistoryDays: -1,
          analyticsEnabled: true,
          multiDeviceSync: true,
          prioritySupport: true,
          customizationEnabled: true,
          advancedReportsEnabled: true,
          apiAccessEnabled: false,
        );
      case SubscriptionPlan.enterprise:
        return const SubscriptionLimits(
          maxMenuItems: -1,
          maxOrderHistoryDays: -1,
          analyticsEnabled: true,
          multiDeviceSync: true,
          prioritySupport: true,
          customizationEnabled: true,
          advancedReportsEnabled: true,
          apiAccessEnabled: true,
        );
    }
  }
  
    // Get usage statistics
  static Future<Map<String, dynamic>> getUsageStatistics() async {
    if (_currentSubscription == null) {
      await initialize();
    }
    
    final currentMenuItems = await getCurrentMenuItemCount();
    final subscription = _currentSubscription!;
    
    String remainingMenuItems;
    double usagePercentage;
    
    if (subscription.limits.hasUnlimitedMenuItems) {
      remainingMenuItems = 'Unlimited';
      usagePercentage = 0.0;
    } else {
      final remaining = subscription.limits.maxMenuItems - currentMenuItems;
      remainingMenuItems = remaining.toString();
      usagePercentage = (currentMenuItems / subscription.limits.maxMenuItems) * 100;
    }
    
    return {
      'currentMenuItems': currentMenuItems,
      'maxMenuItems': subscription.limits.hasUnlimitedMenuItems ? -1 : subscription.limits.maxMenuItems,
      'remainingMenuItems': remainingMenuItems,
      'menuItemUsagePercentage': usagePercentage,
      'hasUnlimitedMenuItems': subscription.limits.hasUnlimitedMenuItems,
      'canAddMoreItems': subscription.canAddMenuItem(currentMenuItems),
    };
  }
  
  // Simulate menu item count for testing
  static Future<void> simulateMenuItemCount(int count) async {
    await updateMenuItemCount(count);
  }

  // Set menu item count for testing (alias for simulateMenuItemCount)
  static Future<void> setMenuItemCountForTesting(int count) async {
    await updateMenuItemCount(count);
  }

  // Quick upgrade to premium for testing
  static Future<bool> upgradeToTestPremium() async {
    return await upgradeToPremium(
      billingCycle: SubscriptionBillingCycle.monthly,
      transactionId: 'test_upgrade_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // Quick upgrade to enterprise for testing
  static Future<bool> upgradeToTestEnterprise() async {
    return await upgradeToEnterprise(
      billingCycle: SubscriptionBillingCycle.monthly,
      transactionId: 'test_enterprise_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
  
  // Clear all cached subscription data (for logout)
  static Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_subscriptionKey);
      await prefs.remove(_menuItemCountKey);
      _currentSubscription = null;
    } catch (e) {
      print('Error clearing subscription cache: $e');
    }
  }
}
