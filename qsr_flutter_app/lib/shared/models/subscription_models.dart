// Subscription and Freemium Models
// Manages subscription plans, limits, and premium features

enum SubscriptionPlan {
  free,
  premium,
  enterprise;

  String get displayName {
    switch (this) {
      case SubscriptionPlan.free:
        return 'Free';
      case SubscriptionPlan.premium:
        return 'Premium';
      case SubscriptionPlan.enterprise:
        return 'Enterprise';
    }
  }

  String get displayNameHindi {
    switch (this) {
      case SubscriptionPlan.free:
        return 'निःशुल्क';
      case SubscriptionPlan.premium:
        return 'प्रीमियम';
      case SubscriptionPlan.enterprise:
        return 'एंटरप्राइज';
    }
  }
}

enum SubscriptionFeature {
  menuItemLimit,
  orderHistory,
  analyticsReports,
  multipleDevices,
  prioritySupport,
  customization,
  advancedReports,
  apiAccess;

  String get displayName {
    switch (this) {
      case SubscriptionFeature.menuItemLimit:
        return 'Menu Items';
      case SubscriptionFeature.orderHistory:
        return 'Order History';
      case SubscriptionFeature.analyticsReports:
        return 'Analytics & Reports';
      case SubscriptionFeature.multipleDevices:
        return 'Multiple Devices';
      case SubscriptionFeature.prioritySupport:
        return 'Priority Support';
      case SubscriptionFeature.customization:
        return 'Advanced Customization';
      case SubscriptionFeature.advancedReports:
        return 'Advanced Reports';
      case SubscriptionFeature.apiAccess:
        return 'API Access';
    }
  }

  String get displayNameHindi {
    switch (this) {
      case SubscriptionFeature.menuItemLimit:
        return 'मेन्यू आइटम';
      case SubscriptionFeature.orderHistory:
        return 'ऑर्डर इतिहास';
      case SubscriptionFeature.analyticsReports:
        return 'विश्लेषण और रिपोर्ट';
      case SubscriptionFeature.multipleDevices:
        return 'कई डिवाइस';
      case SubscriptionFeature.prioritySupport:
        return 'प्राथमिकता समर्थन';
      case SubscriptionFeature.customization:
        return 'उन्नत अनुकूलन';
      case SubscriptionFeature.advancedReports:
        return 'उन्नत रिपोर्ट';
      case SubscriptionFeature.apiAccess:
        return 'API पहुंच';
    }
  }
}

class SubscriptionLimits {
  final int maxMenuItems;
  final int maxOrderHistoryDays;
  final bool analyticsEnabled;
  final bool multiDeviceSync;
  final bool prioritySupport;
  final bool customizationEnabled;
  final bool advancedReportsEnabled;
  final bool apiAccessEnabled;

  const SubscriptionLimits({
    required this.maxMenuItems,
    required this.maxOrderHistoryDays,
    this.analyticsEnabled = false,
    this.multiDeviceSync = false,
    this.prioritySupport = false,
    this.customizationEnabled = false,
    this.advancedReportsEnabled = false,
    this.apiAccessEnabled = false,
  });

  static const SubscriptionLimits free = SubscriptionLimits(
    maxMenuItems: 10,
    maxOrderHistoryDays: 7,
    analyticsEnabled: false,
    multiDeviceSync: false,
    prioritySupport: false,
    customizationEnabled: false,
    advancedReportsEnabled: false,
    apiAccessEnabled: false,
  );

  static const SubscriptionLimits premium = SubscriptionLimits(
    maxMenuItems: -1, // Unlimited
    maxOrderHistoryDays: 365,
    analyticsEnabled: true,
    multiDeviceSync: true,
    prioritySupport: true,
    customizationEnabled: true,
    advancedReportsEnabled: true,
    apiAccessEnabled: false,
  );

  static const SubscriptionLimits enterprise = SubscriptionLimits(
    maxMenuItems: -1, // Unlimited
    maxOrderHistoryDays: -1, // Unlimited
    analyticsEnabled: true,
    multiDeviceSync: true,
    prioritySupport: true,
    customizationEnabled: true,
    advancedReportsEnabled: true,
    apiAccessEnabled: true,
  );

  // Helper method to check if unlimited menu items
  bool get hasUnlimitedMenuItems => maxMenuItems == -1;
  
  // Helper method to check if unlimited order history
  bool get hasUnlimitedOrderHistory => maxOrderHistoryDays == -1;

  Map<String, dynamic> toJson() => {
    'maxMenuItems': maxMenuItems,
    'maxOrderHistoryDays': maxOrderHistoryDays,
    'analyticsEnabled': analyticsEnabled,
    'multiDeviceSync': multiDeviceSync,
    'prioritySupport': prioritySupport,
    'customizationEnabled': customizationEnabled,
    'advancedReportsEnabled': advancedReportsEnabled,
    'apiAccessEnabled': apiAccessEnabled,
  };

  factory SubscriptionLimits.fromJson(Map<String, dynamic> json) => SubscriptionLimits(
    maxMenuItems: json['maxMenuItems'],
    maxOrderHistoryDays: json['maxOrderHistoryDays'],
    analyticsEnabled: json['analyticsEnabled'] ?? false,
    multiDeviceSync: json['multiDeviceSync'] ?? false,
    prioritySupport: json['prioritySupport'] ?? false,
    customizationEnabled: json['customizationEnabled'] ?? false,
    advancedReportsEnabled: json['advancedReportsEnabled'] ?? false,
    apiAccessEnabled: json['apiAccessEnabled'] ?? false,
  );
}

class SubscriptionPricing {
  final double monthlyPrice;
  final double yearlyPrice;
  final String currency;
  final double yearlyDiscountPercentage;

  const SubscriptionPricing({
    required this.monthlyPrice,
    required this.yearlyPrice,
    this.currency = '₹',
    this.yearlyDiscountPercentage = 20.0,
  });

  static const SubscriptionPricing freePricing = SubscriptionPricing(
    monthlyPrice: 0.0,
    yearlyPrice: 0.0,
    yearlyDiscountPercentage: 0.0,
  );

  static const SubscriptionPricing premiumPricing = SubscriptionPricing(
    monthlyPrice: 499.0,
    yearlyPrice: 4990.0, // ~₹416/month with ~17% discount
    yearlyDiscountPercentage: 17.0,
  );

  static const SubscriptionPricing enterprisePricing = SubscriptionPricing(
    monthlyPrice: 1499.0,
    yearlyPrice: 14990.0, // ~₹1249/month with ~17% discount
    yearlyDiscountPercentage: 17.0,
  );

  // Helper methods for formatted prices
  String get formattedMonthlyPrice => '₹${monthlyPrice.toStringAsFixed(0)}/month';
  
  String get formattedYearlyPrice => '₹${yearlyPrice.toStringAsFixed(0)}/year';
  
  double get monthlySavings => (monthlyPrice * 12) - yearlyPrice;

  Map<String, dynamic> toJson() => {
    'monthlyPrice': monthlyPrice,
    'yearlyPrice': yearlyPrice,
    'currency': currency,
    'yearlyDiscountPercentage': yearlyDiscountPercentage,
  };

  factory SubscriptionPricing.fromJson(Map<String, dynamic> json) => SubscriptionPricing(
    monthlyPrice: json['monthlyPrice'].toDouble(),
    yearlyPrice: json['yearlyPrice'].toDouble(),
    currency: json['currency'] ?? '₹',
    yearlyDiscountPercentage: json['yearlyDiscountPercentage']?.toDouble() ?? 0.0,
  );
}

enum SubscriptionBillingCycle {
  monthly,
  yearly;

  String get displayName {
    switch (this) {
      case SubscriptionBillingCycle.monthly:
        return 'Monthly';
      case SubscriptionBillingCycle.yearly:
        return 'Yearly';
    }
  }

  String get displayNameHindi {
    switch (this) {
      case SubscriptionBillingCycle.monthly:
        return 'मासिक';
      case SubscriptionBillingCycle.yearly:
        return 'वार्षिक';
    }
  }
}

enum SubscriptionStatus {
  active,
  cancelled,
  expired,
  suspended,
  trial;

  String get displayName {
    switch (this) {
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
      case SubscriptionStatus.expired:
        return 'Expired';
      case SubscriptionStatus.suspended:
        return 'Suspended';
      case SubscriptionStatus.trial:
        return 'Trial';
    }
  }

  String get displayNameHindi {
    switch (this) {
      case SubscriptionStatus.active:
        return 'सक्रिय';
      case SubscriptionStatus.cancelled:
        return 'रद्द';
      case SubscriptionStatus.expired:
        return 'समाप्त';
      case SubscriptionStatus.suspended:
        return 'निलंबित';
      case SubscriptionStatus.trial:
        return 'परीक्षण';
    }
  }

  bool get isActive => this == SubscriptionStatus.active || this == SubscriptionStatus.trial;
}

class UserSubscription {
  final String id;
  final SubscriptionPlan plan;
  final SubscriptionStatus status;
  final SubscriptionBillingCycle billingCycle;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? nextBillingDate;
  final String? transactionId;
  final SubscriptionLimits limits;
  final SubscriptionPricing pricing;

  const UserSubscription({
    required this.id,
    required this.plan,
    required this.status,
    required this.billingCycle,
    required this.startDate,
    this.endDate,
    this.nextBillingDate,
    this.transactionId,
    required this.limits,
    required this.pricing,
  });

  // Factory for creating a free subscription
  factory UserSubscription.free() {
    return UserSubscription(
      id: 'free_${DateTime.now().millisecondsSinceEpoch}',
      plan: SubscriptionPlan.free,
      status: SubscriptionStatus.active,
      billingCycle: SubscriptionBillingCycle.monthly,
      startDate: DateTime.now(),
      limits: SubscriptionLimits.free,
      pricing: SubscriptionPricing.freePricing,
    );
  }

  // Check if subscription is valid and active
  bool get isValid {
    if (!status.isActive) return false;
    if (endDate != null && DateTime.now().isAfter(endDate!)) return false;
    return true;
  }

  // Check if subscription is expired
  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  // Days remaining in subscription
  int? get daysRemaining {
    if (endDate == null) return null;
    final now = DateTime.now();
    if (now.isAfter(endDate!)) return 0;
    return endDate!.difference(now).inDays;
  }

  // Check if specific feature is available
  bool hasFeature(SubscriptionFeature feature) {
    if (!isValid) return false;

    switch (feature) {
      case SubscriptionFeature.menuItemLimit:
        return true; // All plans have some menu item limit
      case SubscriptionFeature.orderHistory:
        return limits.maxOrderHistoryDays > 0;
      case SubscriptionFeature.analyticsReports:
        return limits.analyticsEnabled;
      case SubscriptionFeature.multipleDevices:
        return limits.multiDeviceSync;
      case SubscriptionFeature.prioritySupport:
        return limits.prioritySupport;
      case SubscriptionFeature.customization:
        return limits.customizationEnabled;
      case SubscriptionFeature.advancedReports:
        return limits.advancedReportsEnabled;
      case SubscriptionFeature.apiAccess:
        return limits.apiAccessEnabled;
    }
  }

  // Check if can add more menu items
  bool canAddMenuItem(int currentMenuItemCount) {
    if (!isValid) return false;
    if (limits.hasUnlimitedMenuItems) return true;
    return currentMenuItemCount < limits.maxMenuItems;
  }

  // Get remaining menu item slots
  int getRemainingMenuItemSlots(int currentMenuItemCount) {
    if (!isValid) return 0;
    if (limits.hasUnlimitedMenuItems) return -1; // Unlimited
    return (limits.maxMenuItems - currentMenuItemCount).clamp(0, limits.maxMenuItems);
  }

  UserSubscription copyWith({
    String? id,
    SubscriptionPlan? plan,
    SubscriptionStatus? status,
    SubscriptionBillingCycle? billingCycle,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextBillingDate,
    String? transactionId,
    SubscriptionLimits? limits,
    SubscriptionPricing? pricing,
  }) {
    return UserSubscription(
      id: id ?? this.id,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      billingCycle: billingCycle ?? this.billingCycle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      transactionId: transactionId ?? this.transactionId,
      limits: limits ?? this.limits,
      pricing: pricing ?? this.pricing,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'plan': plan.name,
    'status': status.name,
    'billingCycle': billingCycle.name,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'nextBillingDate': nextBillingDate?.toIso8601String(),
    'transactionId': transactionId,
    'limits': limits.toJson(),
    'pricing': pricing.toJson(),
  };

  factory UserSubscription.fromJson(Map<String, dynamic> json) => UserSubscription(
    id: json['id'],
    plan: SubscriptionPlan.values.firstWhere((e) => e.name == json['plan']),
    status: SubscriptionStatus.values.firstWhere((e) => e.name == json['status']),
    billingCycle: SubscriptionBillingCycle.values.firstWhere((e) => e.name == json['billingCycle']),
    startDate: DateTime.parse(json['startDate']),
    endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    nextBillingDate: json['nextBillingDate'] != null ? DateTime.parse(json['nextBillingDate']) : null,
    transactionId: json['transactionId'],
    limits: SubscriptionLimits.fromJson(json['limits']),
    pricing: SubscriptionPricing.fromJson(json['pricing']),
  );
}

// Subscription validation result
class SubscriptionValidation {
  final bool isValid;
  final String? errorMessage;
  final String? errorMessageHindi;
  final SubscriptionFeature? requiredFeature;
  final SubscriptionPlan? suggestedPlan;

  const SubscriptionValidation({
    required this.isValid,
    this.errorMessage,
    this.errorMessageHindi,
    this.requiredFeature,
    this.suggestedPlan,
  });

  const SubscriptionValidation.valid() : this(isValid: true);

  const SubscriptionValidation.invalid({
    required String errorMessage,
    String? errorMessageHindi,
    SubscriptionFeature? requiredFeature,
    SubscriptionPlan? suggestedPlan,
  }) : this(
    isValid: false,
    errorMessage: errorMessage,
    errorMessageHindi: errorMessageHindi,
    requiredFeature: requiredFeature,
    suggestedPlan: suggestedPlan,
  );
}

// Plan comparison data for upgrade UI
class PlanComparison {
  final SubscriptionPlan plan;
  final SubscriptionLimits limits;
  final SubscriptionPricing pricing;
  final List<String> features;
  final List<String> featuresHindi;
  final bool isRecommended;

  const PlanComparison({
    required this.plan,
    required this.limits,
    required this.pricing,
    required this.features,
    required this.featuresHindi,
    this.isRecommended = false,
  });

  static List<PlanComparison> getAllPlans() {
    return [
      PlanComparison(
        plan: SubscriptionPlan.free,
        limits: SubscriptionLimits.free,
        pricing: SubscriptionPricing.freePricing,
        features: [
          'Up to 10 menu items',
          '7 days order history',
          'Basic order management',
          'Receipt printing',
          'Local data storage',
        ],
        featuresHindi: [
          '10 तक मेन्यू आइटम',
          '7 दिन का ऑर्डर इतिहास',
          'बुनियादी ऑर्डर प्रबंधन',
          'रसीद प्रिंटिंग',
          'स्थानीय डेटा संग्रहण',
        ],
      ),
      PlanComparison(
        plan: SubscriptionPlan.premium,
        limits: SubscriptionLimits.premium,
        pricing: SubscriptionPricing.premiumPricing,
        features: [
          'Unlimited menu items',
          '1 year order history',
          'Advanced analytics & reports',
          'Multiple device sync',
          'Priority customer support',
          'Custom themes & branding',
          'Advanced reporting features',
        ],
        featuresHindi: [
          'असीमित मेन्यू आइटम',
          '1 साल का ऑर्डर इतिहास',
          'उन्नत विश्लेषण और रिपोर्ट',
          'कई डिवाइस सिंक',
          'प्राथमिकता ग्राहक सहायता',
          'कस्टम थीम और ब्रांडिंग',
          'उन्नत रिपोर्टिंग सुविधाएं',
        ],
        isRecommended: true,
      ),
      PlanComparison(
        plan: SubscriptionPlan.enterprise,
        limits: SubscriptionLimits.enterprise,
        pricing: SubscriptionPricing.enterprisePricing,
        features: [
          'Everything in Premium',
          'Unlimited order history',
          'API access for integrations',
          'Dedicated account manager',
          'Custom feature development',
          'White-label solutions',
          'Advanced security features',
        ],
        featuresHindi: [
          'प्रीमियम में सब कुछ',
          'असीमित ऑर्डर इतिहास',
          'एकीकरण के लिए API पहुंच',
          'समर्पित खाता प्रबंधक',
          'कस्टम फीचर विकास',
          'व्हाइट-लेबल समाधान',
          'उन्नत सुरक्षा सुविधाएं',
        ],
      ),
    ];
  }
}
