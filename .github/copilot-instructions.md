# QRKEY Flutter App - AI Coding Agent Instructions

## 🎯 Project Overview
QRKEY is a comprehensive Quick Service Restaurant (QSR) management system with hybrid cloud architecture. The app has been **completely rebranded from "QSR System" to "QRKEY"** with consistent blue theming (`#1976D2`) to match the main app.

## 🏗️ Architecture Patterns

### Multi-Entry Point Architecture
The app has **multiple main files** for different deployment scenarios:
- `lib/main.dart` - **Primary entry point** with QRKEY branding, Firebase + Supabase integration
- `lib/clean_qsr_main.dart` - Standalone QSR system (3,366 lines, single-file architecture)
- `lib/firebase_main.dart` - Firebase-only integration
- `lib/main_with_supabase.dart` - Supabase-focused integration

**Key Pattern**: Always use `flutter run -t lib/main.dart` unless specifically testing other versions.

### Hybrid State Management
- **Riverpod** for reactive state management
- **Firebase Auth** for user authentication with Google Sign-in
- **Supabase** for real-time database (optional, graceful fallback)
- **SharedPreferences** for local persistence

### Freemium Subscription System
Central service: `lib/services/subscription_service.dart`
```dart
// Usage pattern throughout the app
final canAccess = SubscriptionService.isPremiumUser;
if (!canAccess) {
  return PremiumUpgradeDialog(feature: SubscriptionFeature.analytics);
}
```

## 🎨 Theme System
**Centralized theming**: `lib/core/theme/qrkey_theme.dart`
- **Primary**: `QRKeyTheme.primaryBlue` (#1976D2) - matches main app
- **Never use saffron colors** - fully migrated from #FF9933 to blue theme
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
- Essential for testing subscription flows and theme changes

### Database Code Generation (if using Drift)
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 🔧 Integration Patterns

### Firebase Setup
```dart
// Standard initialization in main()
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

### Supabase Configuration
Config file: `lib/core/config/supabase_config.dart` (replace credentials for production)
```dart
// Graceful fallback pattern
try {
  await SupabaseConfig.initialize();
} catch (e) {
  print('Supabase initialization error: $e');
  // App continues with local functionality
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
- `lib/screens/enhanced_main_screen.dart` - **Main app interface** with 4-tab navigation
- **Tab 0**: QSR System (integrated `clean_qsr_main.dart`)
- **Tab 1**: KOT Screen (Kitchen Order Tickets)
- **Tab 2**: Premium Demo/Analytics (subscription-gated)
- **Tab 3**: Profile/Subscription Management

### Reusable Components
- `lib/widgets/qrkey_logo.dart` - Logo system with QR fallbacks
- `lib/shared/widgets/premium_upgrade_widgets.dart` - Subscription prompts
- Feature availability controlled by `SubscriptionService.currentPlan`

## 📱 Platform-Specific Considerations

### Android Configuration
- Bluetooth permissions in `android/app/src/main/AndroidManifest.xml`
- App name: "QRKEY" (updated from "QSR System")
- Thermal printer support via ESC/POS commands

### Development Testing
- Always test subscription flows: Free → Premium → Enterprise
- Firebase auth requires Google Services setup
- Supabase features need valid credentials in config

## 🎯 Critical Patterns

### Error Handling
```dart
// Subscription validation pattern
final validation = await SubscriptionService.validateAddMenuItem();
if (!validation.isValid) {
  showUpgradeDialog(context, validation.requiredFeature);
  return;
}
```

### Theme Consistency
```dart
// Always use theme system, never hardcode colors
selectedItemColor: QRKeyTheme.primaryBlue,
backgroundColor: QRKeyTheme.primaryBlue.withOpacity(0.1),
```

### Feature Gating
```dart
// Standard pattern for premium features
Widget _buildPremiumFeature() {
  if (!SubscriptionService.isPremiumUser) {
    return PremiumFeaturePlaceholder(feature: SubscriptionFeature.analytics);
  }
  return ActualFeatureWidget();
}
```

## 🔍 Debugging & Testing

### Key Log Messages to Monitor
- "Firebase initialized successfully"
- "Supabase initialized successfully" 
- "Subscription service initialized"

### Common Issues
- **Color inconsistency**: Ensure all UI uses `QRKeyTheme.primaryBlue` not saffron
- **Subscription state**: Always check `SubscriptionService.currentPlan` in premium features
- **Authentication**: Firebase auth state changes drive main navigation flow

### Testing Subscription Features
Use `lib/screens/subscription_management_screen.dart` to test plan changes and feature availability without actual payments.

## 📚 File Organization Priority
1. **Primary**: `lib/main.dart`, `lib/screens/enhanced_main_screen.dart`
2. **Core**: `lib/core/theme/qrkey_theme.dart`, `lib/services/subscription_service.dart`
3. **Integration**: `lib/core/config/supabase_config.dart`, `firebase_options.dart`
4. **Legacy**: `lib/clean_qsr_main.dart` (read-only, integrated via import)

When modifying features, always ensure changes maintain the freemium model, blue theme consistency, and graceful fallbacks for cloud services.
