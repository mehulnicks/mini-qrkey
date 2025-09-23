# Manual Firebase Configuration Steps

Since the FlutterFire CLI is having issues, here's how to manually get your Firebase configuration:

## Step 1: Go to Firebase Console
1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **qsr-management-app**

## Step 2: Enable Authentication
1. Click on "Authentication" in the left sidebar
2. Click "Get started" if not already enabled
3. Go to "Sign-in method" tab
4. Enable "Email/Password" - toggle it ON
5. Enable "Google" - click on Google, toggle it ON, add your support email

## Step 3: Enable Firestore Database
1. Click on "Firestore Database" in the left sidebar
2. Click "Create database" if not already created
3. Choose "Start in test mode" for now
4. Select your preferred location (choose closest to your users)

## Step 4: Get Configuration Keys

### For Android:
1. In Firebase Console, click the gear icon (⚙️) → "Project settings"
2. Scroll down to "Your apps" section
3. Click on the Android app icon or "Add app" if no Android app exists
4. Enter package name: `com.example.qsr_flutter_app`
5. Download the `google-services.json` file
6. Place it in: `android/app/google-services.json`

### For Web (if needed):
1. In Project settings, add a web app or click on existing web app
2. Copy the configuration object that looks like:
```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "qsr-management-app.firebaseapp.com",
  projectId: "qsr-management-app",
  storageBucket: "qsr-management-app.appspot.com",
  messagingSenderId: "123...",
  appId: "1:123..."
};
```

## Step 5: Update firebase_options.dart
Replace the placeholder values in `lib/firebase_options.dart` with your actual values:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_ANDROID_API_KEY',
  appId: 'YOUR_ACTUAL_ANDROID_APP_ID', 
  messagingSenderId: 'YOUR_ACTUAL_MESSAGING_SENDER_ID',
  projectId: 'qsr-management-app',
  storageBucket: 'qsr-management-app.appspot.com',
);
```

## Step 6: Test the Configuration
After updating the configuration, run:
```bash
flutter run lib/firebase_main.dart
```

The app should now connect to Firebase successfully!

## Current Status
✅ Firebase project created: qsr-management-app
✅ Project initialized in Flutter app
✅ Basic project ID configured
⏳ **NEXT:** Get API keys from Firebase Console and update firebase_options.dart

## What to do next:
1. Follow steps above to get your Firebase configuration keys
2. Update the firebase_options.dart file with real values
3. Test the app with Firebase integration

Let me know when you've completed these steps and I can help test the Firebase integration!
