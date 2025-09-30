# Supabase Integration for QSR Flutter App

This document provides step-by-step instructions to set up Supabase for your QSR (Quick Service Restaurant) Flutter application.

## 🚀 Quick Setup

### 1. Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or log in to your account
3. Click **"New Project"**
4. Fill in your project details:
   - **Project Name**: `qsr-flutter-app`
   - **Database Password**: Create a strong password
   - **Region**: Choose closest to your location
5. Click **"Create new project"**

### 2. Get Your Project Credentials

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL**
   - **Project API Keys** → **anon public**

### 3. Configure Flutter App

1. Open `lib/core/config/supabase_config.dart`
2. Replace the placeholder values:

```dart
class SupabaseConfig {
  static const String url = 'https://eftnhqazcdejdauaxfyx.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVmdG5ocWF6Y2RlamRhdWF4Znl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkyMTI3ODgsImV4cCI6MjA3NDc4ODc4OH0.VxtPb5XUFL7VOtSHSaW7wU-R65NkPKj9XkSnqgaBwHs';
  
  // ... rest of the code
}
```

### 4. Set Up Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Copy the contents of `supabase_schema.sql`
3. Paste it into the SQL editor
4. Click **"Run"** to execute the schema

### 5. Initialize Supabase in Your App

Update your main.dart file to initialize Supabase:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  runApp(const ProviderScope(child: MyApp()));
}
```

## 🛠️ Features Included

### Database Tables

- **orders**: Complete order management with status tracking
- **menu_items**: Restaurant menu with categories and pricing
- **categories**: Menu categorization
- **restaurant_tables**: Table management for dine-in orders
- **order_items**: Detailed order line items
- **customers**: Customer data and loyalty tracking
- **staff**: Staff management with role-based access

### Flutter Integration

- **Authentication**: Email/password sign-up and sign-in
- **Real-time Updates**: Live order status updates
- **State Management**: Riverpod providers for all Supabase operations
- **CRUD Operations**: Full Create, Read, Update, Delete functionality
- **File Storage**: Image upload capabilities for menu items

### Security Features

- **Row Level Security (RLS)**: Enabled on all tables
- **Role-based Access**: Different permissions for staff roles
- **Data Validation**: Constraints and checks on critical fields
- **Audit Trail**: Created/updated timestamps and user tracking

## 📱 Using the Integration

### Authentication

```dart
// Sign up a new user
await ref.read(authNotifierProvider.notifier)
    .signUpWithEmail('user@example.com', 'password');

// Sign in existing user
await ref.read(authNotifierProvider.notifier)
    .signInWithEmail('user@example.com', 'password');

// Sign out
await ref.read(authNotifierProvider.notifier).signOut();
```

### Managing Orders

```dart
// Create a new order
final orderData = {
  'order_number': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
  'customer_name': 'John Doe',
  'customer_phone': '+1234567890',
  'order_type': 'takeaway',
  'status': 'pending',
  'items': [], // Array of order items
  'total_amount': 25.99,
};

await ref.read(ordersNotifierProvider.notifier)
    .createOrder(orderData);

// Update order status
await ref.read(ordersNotifierProvider.notifier)
    .updateOrder(orderId, {'status': 'completed'});
```

### Real-time Subscriptions

```dart
// Listen to order updates
final subscription = SupabaseService.subscribeToOrders((orders) {
  // Handle real-time order updates
  print('Orders updated: ${orders.length}');
});

// Don't forget to cancel the subscription
subscription.unsubscribe();
```

## 🔧 Configuration Options

### Environment Variables

For production apps, consider using environment variables:

```dart
// Create a .env file (don't commit to git)
SUPABASE_URL=your_url_here
SUPABASE_ANON_KEY=your_key_here

// Use flutter_dotenv package to load
await dotenv.load(fileName: ".env");
```

### Custom Policies

You can modify the Row Level Security policies in the SQL editor:

```sql
-- Example: Restrict order access to specific users
CREATE POLICY "Users can only see their orders" ON orders 
FOR SELECT USING (created_by = auth.uid());
```

## 🚨 Important Notes

### Security Considerations

1. **Never commit API keys**: Use environment variables or secure storage
2. **RLS Policies**: Review and customize based on your security requirements
3. **API Rate Limits**: Monitor usage in your Supabase dashboard
4. **Database Backup**: Enable automated backups in Supabase settings

### Performance Tips

1. **Indexes**: The schema includes optimized indexes for common queries
2. **Pagination**: Use `range()` for large datasets
3. **Selective Queries**: Only fetch required columns with `select()`
4. **Connection Pooling**: Supabase handles this automatically

### Testing

1. Use the Supabase dashboard to test queries
2. Enable debug mode in development:
   ```dart
   await Supabase.initialize(
     url: url,
     anonKey: anonKey,
     debug: true, // Shows API calls in console
   );
   ```

## 📞 Support

- **Supabase Docs**: [https://supabase.com/docs](https://supabase.com/docs)
- **Flutter Integration**: [https://supabase.com/docs/reference/dart](https://supabase.com/docs/reference/dart)
- **Community**: [https://supabase.com/discord](https://supabase.com/discord)

## 🎯 Next Steps

1. Set up your Supabase project
2. Configure the credentials in your Flutter app
3. Run the database schema
4. Test the authentication screen: `SupabaseAuthScreen`
5. Integrate with your existing QSR features
6. Customize the database schema for your specific needs

Your QSR Flutter app is now ready for cloud-powered real-time operations! 🎉
