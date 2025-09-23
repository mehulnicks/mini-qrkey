# Firebase Integration Setup Guide

## Firebase Project Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `qsr-management-app`
4. Enable Google Analytics (optional)
5. Create project

### 2. Enable Authentication
1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password"
5. Enable "Google" (follow setup instructions)

### 3. Enable Firestore Database
1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (or production mode with rules)
4. Select location closest to your users

### 4. Configure Firebase for Flutter

#### Option A: Using FlutterFire CLI (Recommended)
```bash
# Install FlutterFire CLI
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# Configure Firebase for your project
cd qsr_flutter_app
flutterfire configure
```

#### Option B: Manual Configuration
Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase configuration:

1. Go to Project Settings in Firebase Console
2. Add your Android/iOS/Web apps
3. Copy the configuration values

### 5. Android Configuration
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/` directory
3. The `pubspec.yaml` already includes required dependencies

### 6. iOS Configuration (if needed)
1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to `ios/Runner/` in Xcode

### 7. Web Configuration (if needed)
Update `web/index.html` with Firebase configuration script tags

## Security Rules

### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow business owners to manage their business data
    match /businesses/{businessId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.owners;
    }
    
    // Allow business users to manage orders
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.userId || 
         request.auth.uid in get(/databases/$(database)/documents/businesses/$(resource.data.businessId)).data.owners);
    }
    
    // Similar rules for menu items, customers, etc.
    match /menu_items/{itemId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in get(/databases/$(database)/documents/businesses/$(resource.data.businessId)).data.owners;
    }
  }
}
```

## Running the App

### With Firebase Integration
```bash
# Run with Firebase integration
flutter run lib/firebase_main.dart
```

### Without Firebase (Original App)
```bash
# Run original app without Firebase
flutter run lib/clean_qsr_main.dart
```

## Features Added

### Authentication
- Email/password sign-in and registration
- Google Sign-In integration
- Password reset functionality
- User profile management
- Automatic authentication state management

### Cloud Database
- User profiles stored in Firestore
- Business settings synchronization
- Order management with cloud backup
- Menu items stored in cloud
- Customer data management
- Real-time updates across devices

### Data Structure
```
users/{userId}
├── email: string
├── displayName: string
├── photoURL: string
├── businessIds: array
├── createdAt: timestamp
└── lastLoginAt: timestamp

businesses/{businessId}
├── name: string
├── owners: array
├── settings: object
├── createdAt: timestamp
└── updatedAt: timestamp

orders/{orderId}
├── businessId: string
├── userId: string
├── customerInfo: object
├── items: array
├── payments: array
├── status: string
├── orderType: string
├── createdAt: timestamp
└── updatedAt: timestamp
```

## Migration from Local Storage

The app automatically handles migration from SharedPreferences to Firestore:
1. On first login, local data is uploaded to Firestore
2. Subsequent sessions sync data from cloud
3. Offline functionality maintained with local caching

## Development Notes

- Firebase services are in `lib/services/`
- Authentication wrapper handles login/logout states
- Profile management integrated into settings
- All existing QSR functionality preserved
- Cloud sync happens automatically in background

## Testing

1. Create a test Firebase project
2. Use test authentication credentials
3. Test offline/online scenarios
4. Verify data synchronization
5. Test authentication flows

## Deployment

For production deployment:
1. Update Firebase security rules
2. Configure proper authentication domains
3. Set up production Firestore database
4. Update app configuration for production
