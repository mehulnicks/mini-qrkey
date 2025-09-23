import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_wrapper.dart';
import '../services/data_migration_service.dart';
import '../services/firestore_service.dart';
import '../providers/firebase_providers.dart';

class FirebaseEnhancedSettingsScreen extends ConsumerStatefulWidget {
  const FirebaseEnhancedSettingsScreen({super.key});

  @override
  ConsumerState<FirebaseEnhancedSettingsScreen> createState() => _FirebaseEnhancedSettingsScreenState();
}

class _FirebaseEnhancedSettingsScreenState extends ConsumerState<FirebaseEnhancedSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final businessId = ref.watch(currentBusinessIdProvider);
    final businessSettings = ref.watch(firebaseBusinessSettingsProvider(businessId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
        actions: [
          if (user != null)
            IconButton(
              onPressed: () => _showSyncDialog(context),
              icon: const Icon(Icons.cloud_sync),
              tooltip: 'Sync Data',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            if (user != null) _buildUserProfileSection(user),
            
            // Business Settings Section
            _buildBusinessSettingsSection(businessSettings),
            
            // Data Management Section
            _buildDataManagementSection(),
            
            // App Settings Section
            _buildAppSettingsSection(),
            
            // About Section
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(user) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFFF9933),
              backgroundImage: user.photoURL != null 
                  ? NetworkImage(user.photoURL!) 
                  : null,
              child: user.photoURL == null
                  ? Text(
                      (user.displayName?.isNotEmpty == true 
                          ? user.displayName![0].toUpperCase()
                          : user.email?[0].toUpperCase() ?? 'U'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            title: Text(user.displayName ?? 'User'),
            subtitle: Text(user.email ?? ''),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.business, color: Colors.grey),
            title: const Text('Business Profile'),
            subtitle: const Text('Manage your business information'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showBusinessProfileDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessSettingsSection(AsyncValue<Map<String, dynamic>> businessSettings) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              'Business Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          businessSettings.when(
            data: (settings) => Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restaurant_menu, color: Colors.grey),
                  title: const Text('Menu Management'),
                  subtitle: const Text('Manage your menu items and categories'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToMenuManagement(),
                ),
                ListTile(
                  leading: const Icon(Icons.receipt, color: Colors.grey),
                  title: const Text('Order Settings'),
                  subtitle: Text('Tax: ${settings['taxRate'] ?? 0}%, Service: ${settings['serviceChargeRate'] ?? 0}%'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showOrderSettingsDialog(settings),
                ),
                ListTile(
                  leading: const Icon(Icons.print, color: Colors.grey),
                  title: const Text('Printer Settings'),
                  subtitle: Text('Paper: ${settings['printerSettings']?['paperSize'] ?? '58mm'}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showPrinterSettingsDialog(settings),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ListTile(
              title: Text('Error loading settings: $error'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              'Data Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload, color: Colors.blue),
            title: const Text('Sync to Cloud'),
            subtitle: const Text('Upload local data to cloud storage'),
            onTap: () => _syncToCloud(),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_download, color: Colors.green),
            title: const Text('Download from Cloud'),
            subtitle: const Text('Download latest data from cloud'),
            onTap: () => _syncFromCloud(),
          ),
          ListTile(
            leading: const Icon(Icons.backup, color: Colors.orange),
            title: const Text('Export Data'),
            subtitle: const Text('Export your data as backup'),
            onTap: () => _exportData(),
          ),
          ListTile(
            leading: const Icon(Icons.restore, color: Colors.purple),
            title: const Text('Reset Migration'),
            subtitle: const Text('Reset data migration status (for testing)'),
            onTap: () => _resetMigration(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              'App Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.grey),
            title: const Text('Language'),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showLanguageSelector(),
          ),
          ListTile(
            leading: const Icon(Icons.palette, color: Colors.grey),
            title: const Text('Theme'),
            subtitle: const Text('Light'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showThemeSelector(),
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.grey),
            title: const Text('Notifications'),
            subtitle: const Text('Order alerts and reminders'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showNotificationSettings(),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.grey),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0 (Firebase Edition)'),
          ),
          ListTile(
            leading: const Icon(Icons.support, color: Colors.grey),
            title: const Text('Support'),
            subtitle: const Text('Get help and contact support'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showSupportDialog(),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.grey),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showPrivacyPolicy(),
          ),
        ],
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Data'),
        content: const Text('Choose sync direction:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _syncToCloud();
            },
            child: const Text('Upload to Cloud'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _syncFromCloud();
            },
            child: const Text('Download from Cloud'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showBusinessProfileDialog() {
    // TODO: Implement business profile management
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Business profile management coming soon!')),
    );
  }

  void _navigateToMenuManagement() {
    // TODO: Navigate to Firebase-aware menu management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Firebase menu management coming soon!')),
    );
  }

  void _showOrderSettingsDialog(Map<String, dynamic> settings) {
    // TODO: Implement order settings dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order settings dialog coming soon!')),
    );
  }

  void _showPrinterSettingsDialog(Map<String, dynamic> settings) {
    // TODO: Implement printer settings dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Printer settings dialog coming soon!')),
    );
  }

  Future<void> _syncToCloud() async {
    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        // Show loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Syncing to cloud...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );

        await DataMigrationService.migrateLocalDataToFirestore(user.uid);
        
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Data synced to cloud successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Sync failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _syncFromCloud() async {
    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Downloading from cloud...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );

        await DataMigrationService.syncFirestoreToLocal(user.uid);
        
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Data downloaded from cloud successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _exportData() {
    // TODO: Implement data export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data export feature coming soon!')),
    );
  }

  Future<void> _resetMigration() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Migration'),
        content: const Text('This will reset the migration status. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DataMigrationService.resetMigrationStatus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Migration status reset successfully'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showLanguageSelector() {
    // TODO: Implement language selector
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language selector coming soon!')),
    );
  }

  void _showThemeSelector() {
    // TODO: Implement theme selector
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme selector coming soon!')),
    );
  }

  void _showNotificationSettings() {
    // TODO: Implement notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings coming soon!')),
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QSR Management App'),
            SizedBox(height: 8),
            Text('Firebase Edition v1.0.0'),
            SizedBox(height: 16),
            Text('Features:'),
            Text('• Cloud Authentication'),
            Text('• Real-time Data Sync'),
            Text('• Multi-device Support'),
            Text('• Offline Capability'),
            Text('• Automatic Backup'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Your data is securely stored in Firebase Cloud Firestore. '
            'We use industry-standard encryption and security measures to protect your information. '
            'Your business data is private and only accessible to you and authorized users of your business account.\n\n'
            'Data collected:\n'
            '• User account information (email, name)\n'
            '• Business data (orders, menu items, customers)\n'
            '• Usage analytics (anonymous)\n\n'
            'We do not share your data with third parties without your consent.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
