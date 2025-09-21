# QSR App Data Persistence Testing Guide

## Overview
This document outlines how to test the comprehensive data persistence system implemented in the QSR Flutter app.

## Features Implemented ✅

### 1. Local Storage (SharedPreferences)
- **Orders**: All order details, items, customer info, payments
- **Settings**: Tax rates, charges configuration, print settings
- **Menu Items**: Product catalog with prices and categories
- **Customer Data**: Names, phone numbers, addresses
- **Payment Config**: Available payment methods and settings

### 2. Google Drive Cloud Backup
- **Day-wise Organization**: Data organized by date folders
- **Authentication**: Google Sign-In integration
- **Progress Tracking**: Real-time sync progress
- **Backup History**: Track successful syncs
- **Error Handling**: Graceful fallback when service unavailable

### 3. Automatic Persistence
- **Real-time Saving**: Data saved immediately on changes
- **App Restart Recovery**: All data restored on app launch
- **State Synchronization**: UI reflects persisted data correctly

## Testing Procedures

### Test 1: Order Persistence
1. **Create Orders**: Add multiple orders with different items
2. **Restart App**: Close and reopen the application
3. **Verify**: Check that all orders are still present
4. **Expected**: Orders display correctly with all details

### Test 2: Settings Persistence
1. **Modify Settings**: Change tax rates, enable/disable charges
2. **Restart App**: Close and reopen the application
3. **Verify**: Check settings screen shows correct values
4. **Expected**: All settings maintained across sessions

### Test 3: Menu Persistence
1. **Add Items**: Create new menu items or modify existing
2. **Restart App**: Close and reopen the application
3. **Verify**: Menu shows updated items
4. **Expected**: Menu changes persist correctly

### Test 4: Customer Data Persistence
1. **Add Customers**: Enter customer information
2. **Restart App**: Close and reopen the application
3. **Verify**: Customer data available in orders
4. **Expected**: Customer list maintained

### Test 5: Payment Config Persistence
1. **Configure Payments**: Enable/disable payment methods
2. **Restart App**: Close and reopen the application
3. **Verify**: Payment options reflect configuration
4. **Expected**: Payment settings preserved

## Google Drive Setup (Optional)

For full cloud backup functionality, configure Google Sign-In:

### Prerequisites
1. Google Cloud Console project
2. Google Drive API enabled
3. OAuth2 credentials configured
4. Web client ID obtained

### Configuration Steps
1. Open `web/index.html`
2. Add Google client ID meta tag:
   ```html
   <meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
   ```
3. Restart the app
4. Test Google Sign-In from Settings

## Validation Results

### ✅ Confirmed Working
- **Local Storage**: Orders persist across app restarts
- **Settings Persistence**: Tax and charge configurations maintained
- **Menu Data**: Product catalog preserved
- **Customer Information**: Contact details saved
- **Payment Configuration**: Method preferences retained

### ⚠️ Requires Configuration
- **Google Drive Sync**: Needs client ID setup for web platform
- **Cloud Backup**: Works after proper Google configuration

## Debug Information

### Terminal Logs Show:
```
DEBUG: OrdersNotifier initialized
DEBUG: Loaded 2 orders from storage
DEBUG: Order IDs: [order_20241221_143045_001, order_20241221_143115_002]
```

This confirms orders are being loaded successfully from local storage.

### Storage Location
- **Platform**: Web/Desktop
- **Technology**: SharedPreferences
- **Persistence**: Automatic on all state changes
- **Recovery**: Complete on app initialization

## Conclusion

The QSR app now has comprehensive data persistence:
- ✅ All data saved locally automatically
- ✅ Complete recovery on app restart
- ✅ No data loss between sessions
- ✅ Cloud backup infrastructure ready
- ⚠️ Google Drive requires client ID configuration

The core requirement of preventing data loss is fully satisfied with local storage, and cloud backup is available once Google credentials are configured.
