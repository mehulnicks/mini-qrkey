# QRKEY Flutter App - AI Coding Agent Instructions

## 🎯 Project Overview
QRKEY is a comprehensive Quick Service Restaurant (QSR) management system with hybrid cloud architecture featuring Firebase authentication, Supabase integration, and a sophisticated freemium subscription model. The app uses **consistent saffron theming** (`#FF9933`) and supports bilingual localization (English/Hindi).

## 🏗️ Architecture Patterns

### Multi-Entry Point Architecture
The app has **multiple main files** for different deployment scenarios:
- `lib/main.dart` - **Primary entry point** with QRKEY branding, Firebase + Supabase integration
- `lib/clean_qsr_main.dart` - Monolithic QSR system (15,000+ lines, complete standalone implementation)
- `lib/firebase_main.dart` - Firebase-only integration
- `lib/main_with_supabase.dart` - Supabase-focused integration

**Key Pattern**: Always use `flutter run -t lib/main.dart` unless specifically testing other versions.

### Current Navigation Structure (Enhanced Main Screen)
The primary app uses a **simplified 2-tab structure**:
- **Tab 0**: Dashboard - Quick metrics, subscription status, recent activity, quick actions
- **Tab 1**: QSR System - Complete restaurant management (embedded `clean_qsr_main.dart`)

**Settings Integration**: All configuration is accessed through the QSR System's Settings tab, which includes:
- Analytics & Reports (Premium features with subscription gating)
- Subscription Management 
- Profile settings
- App configuration

### Hybrid State Management & Cloud Integration
- **Riverpod** for reactive state management with providers
- **Firebase Auth** for user authentication (Google Sign-in, email/password, anonymous)
- **Supabase** for real-time database (optional, graceful fallback)
- **SharedPreferences** for local persistence and subscription state

### Freemium Subscription System
Central service: `lib/services/subscription_service.dart`
```dart
// Critical validation pattern used throughout
final validation = await SubscriptionService.validateAddMenuItem();
if (!validation.isValid) {
  return PremiumUpgradeDialog(feature: validation.requiredFeature);
}

// Special user auto-upgrade pattern
const String _premiumUserEmail = 'mehulnicks@gmail.com';
// Auto-detects and upgrades mehulnicks@gmail.com to premium (10-year subscription)
```

**Subscription Plans**: Free (10 menu items), Premium (unlimited), Enterprise (API access)

### Comprehensive Localization System
**Pattern**: `lib/clean_qsr_main.dart` contains complete localization implementation
```dart
// Usage: l10n(ref, 'key') - respects user language preference
final currentLanguage = ref.watch(currentLanguageProvider); // 'en' or 'hi'
final text = l10n(ref, 'dashboard'); // Returns "Dashboard" or "डैशबोर्ड"
```

## 🎨 Theme System
**Centralized theming**: `lib/core/theme/qrkey_theme.dart`
- **Primary**: `QRKeyTheme.primarySaffron` (#FF9933) - consistent saffron theme
- **Never use blue colors** - app uses saffron/orange branding consistently
- Import pattern: `import '../core/theme/qrkey_theme.dart';`

## 🚀 Essential Development Commands

### Running the App
```bash
cd qsr_flutter_app
flutter run -d chrome -t lib/main.dart          # Web development
flutter run -d 000783488002925 -t lib/main.dart # Android (replace device ID)
```

### Development Hot Reload
- `r` - Hot reload (preserves state)
- `R` - Hot restart (resets state) 
- Essential for testing subscription flows and localization changes

### Current Device Setup
- **Android Device**: A142 (ID: 000783488002925) - Currently configured and working
- **Directory**: Always run from `/Users/daminisonawane/Desktop/mini-qrkey/qsr_flutter_app`

## 🔧 Integration Patterns

### Firebase Setup
```dart
// Standard initialization in main()
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

### Supabase Configuration
Config file: `lib/core/config/supabase_config.dart` (replace credentials for production)
```dart
// Graceful fallback pattern - app continues without cloud services
try {
  await SupabaseConfig.initialize();
} catch (e) {
  print('Supabase initialization error: $e');
}
```

### Authentication Flow
Uses `AuthWrapper` pattern in `lib/main.dart`:
```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) => snapshot.hasData 
    ? const EnhancedMainScreen() 
    : const LoginScreen()
)
```

## 🏪 Component Structure

### Screen Architecture
- `lib/main.dart` - **Primary app entry** with enhanced authentication
- `lib/screens/enhanced_main_screen.dart` - **Main interface** with 2-tab navigation
- `lib/clean_qsr_main.dart` - **Complete QSR system** (15,000+ lines, integrated as Tab 1)

**Tab Structure (Current)**:
- Tab 0: Dashboard (Quick metrics, subscription status, recent activity)
- Tab 1: QSR System (complete restaurant management embedded)

**QSR System Internal Navigation** (5 tabs within Tab 1):
- Dashboard: Business overview with today's summary
- Menu: Order placement and menu management 
- Orders: Order history and management
- KOT: Kitchen Order Tickets
- Settings: Analytics, subscription, profile, app settings

### Reusable Components
- `lib/widgets/qrkey_logo.dart` - Logo system with QR fallbacks
- `lib/shared/widgets/premium_upgrade_widgets.dart` - Subscription prompts
- `lib/services/subscription_service.dart` - Feature gating and validation

## 🎯 Critical Patterns

### Freemium Feature Gating
```dart
// Standard validation before premium features
final validation = await SubscriptionService.validateFeatureAccess(
  SubscriptionFeature.analyticsReports
);
if (!validation.isValid) {
  showUpgradeDialog(context, validation.requiredFeature);
  return;
}
```

### Theme Consistency
```dart
// Always use theme system, never hardcode colors
color: QRKeyTheme.primarySaffron,
backgroundColor: QRKeyTheme.primarySaffron.withOpacity(0.1),
```

### Localization Pattern
```dart
// Dynamic language based on user settings
Text(l10n(ref, 'dashboard')), // Returns localized text
// Dashboard uses l10n keys: 'today_summary', 'today_orders', etc.
```

### Error Handling & Fallbacks
```dart
// Graceful degradation for cloud services
try {
  await cloudOperation();
} catch (e) {
  print('Cloud error: $e');
  // Continue with local functionality
}
```

## 🔍 Debugging & Testing

### Key Log Messages to Monitor
- "Firebase initialized successfully"
- "Supabase initialized successfully" 
- "Subscription service initialized"
- "User authenticated: [username]"

### Common Issues
- **Theme inconsistency**: Ensure all UI uses `QRKeyTheme.primarySaffron` (saffron theme)
- **Subscription state**: Always check `SubscriptionService.currentPlan` in premium features
- **Localization**: Use `l10n(ref, 'key')` instead of hardcoded bilingual text
- **Authentication**: Firebase auth state changes drive main navigation flow

### Testing Freemium Features
- Use `lib/screens/freemium_demo_screen.dart` for subscription testing
- Use `lib/screens/subscription_management_screen.dart` for plan management
- Test validation: Free (10 items) → Premium (unlimited) → Enterprise (API)

## 📚 File Organization Priority
1. **Primary**: `lib/main.dart`, `lib/screens/enhanced_main_screen.dart`
2. **Core**: `lib/core/theme/qrkey_theme.dart`, `lib/services/subscription_service.dart`
3. **Integration**: `lib/core/config/supabase_config.dart`, `firebase_options.dart`
4. **Complete System**: `lib/clean_qsr_main.dart` (15,000+ lines, self-contained QSR system)
5. **Models**: `lib/shared/models/subscription_models.dart` (freemium system models)

## 💡 Development Guidelines

When modifying features:
- Maintain freemium model with proper validation
- Use saffron theme consistency (`QRKeyTheme.primarySaffron`)
- Implement graceful fallbacks for cloud services
- Follow localization patterns with `l10n(ref, 'key')`
- Test subscription flows: Free → Premium → Enterprise
- Preserve the monolithic `clean_qsr_main.dart` as integrated system
