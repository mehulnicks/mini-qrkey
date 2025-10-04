import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'clean_qsr_main.dart' as qsr;
import 'kot_screen.dart';
import 'core/theme/qrkey_theme.dart';
import 'services/subscription_service.dart';
import 'shared/models/subscription_models.dart';
import 'screens/analytics_screen.dart';
import 'screens/subscription_management_screen.dart';
import 'screens/cloud_features_screen.dart';
import 'widgets/qrkey_logo.dart';

/// Enhanced QSR Wrapper that integrates analytics and user management
/// into the existing QSR system's settings tab
class EnhancedQSRWrapper extends ConsumerStatefulWidget {
  const EnhancedQSRWrapper({super.key});

  @override
  ConsumerState<EnhancedQSRWrapper> createState() => _EnhancedQSRWrapperState();
}

class _EnhancedQSRWrapperState extends ConsumerState<EnhancedQSRWrapper> {
  UserSubscription? _subscription;
  bool _isLoadingSubscription = true;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionData();
  }

  Future<void> _loadSubscriptionData() async {
    try {
      final subscription = SubscriptionService.getCurrentSubscription();
      setState(() {
        _subscription = subscription;
        _isLoadingSubscription = false;
      });
    } catch (e) {
      setState(() {
        _subscription = UserSubscription.free();
        _isLoadingSubscription = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingSubscription) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading QRKEY System...'),
            ],
          ),
        ),
      );
    }

    // Return the enhanced QSR app with custom settings integration
    return EnhancedQSRApp(subscription: _subscription);
  }
}

/// Custom QSR App that overrides the settings screen
class EnhancedQSRApp extends StatefulWidget {
  final UserSubscription? subscription;
  
  const EnhancedQSRApp({super.key, this.subscription});

  @override
  State<EnhancedQSRApp> createState() => _EnhancedQSRAppState();
}

class _EnhancedQSRAppState extends State<EnhancedQSRApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const qsr.OrderPlacementScreen(), // Menu tab
    const qsr.OrderHistoryScreen(), // Orders tab  
    const KOTScreen(), // KOT tab - from kot_screen.dart
    const EnhancedSettingsScreen(), // Our enhanced settings
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: QRKeyTheme.primarySaffron, // Use QRKEY blue theme
            unselectedItemColor: Colors.grey[600],
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.restaurant_menu),
                label: qsr.l10n(ref, 'menu'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.receipt_long),
                label: qsr.l10n(ref, 'orders'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.kitchen),
                label: qsr.l10n(ref, 'kot'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: qsr.l10n(ref, 'settings'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Enhanced Settings Screen that integrates analytics and user management
class EnhancedSettingsScreen extends ConsumerStatefulWidget {
  const EnhancedSettingsScreen({super.key});

  @override
  ConsumerState<EnhancedSettingsScreen> createState() => _EnhancedSettingsScreenState();
}

class _EnhancedSettingsScreenState extends ConsumerState<EnhancedSettingsScreen> {
  UserSubscription? _subscription;
  Map<String, dynamic>? _usageStats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final subscription = SubscriptionService.getCurrentSubscription();
      final usage = await SubscriptionService.getUsageStatistics();
      
      setState(() {
        _subscription = subscription;
        _usageStats = usage;
      });
    } catch (e) {
      setState(() {
        _subscription = UserSubscription.free();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(qsr.l10n(ref, 'settings')),
        backgroundColor: QRKeyTheme.primarySaffron.withOpacity(0.1),
        foregroundColor: QRKeyTheme.primarySaffron,
        toolbarHeight: 48,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            _buildUserProfileSection(currentUser),
            const SizedBox(height: 20),
            
            // Analytics Section
            _buildAnalyticsSection(),
            const SizedBox(height: 20),
            
            // Subscription Management Section
            _buildSubscriptionSection(),
            const SizedBox(height: 20),
            
            // QSR Settings Section
            _buildQSRSettingsSection(),
            const SizedBox(height: 20),
            
            // App Settings Section
            _buildAppSettingsSection(),
            const SizedBox(height: 20),
            
            // Account Actions Section
            _buildAccountActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection(User? currentUser) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: QRKeyTheme.primarySaffron,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: QRKeyTheme.primarySaffron.withOpacity(0.1),
                  child: Text(
                    (currentUser?.displayName?.isNotEmpty == true) 
                        ? currentUser!.displayName!.substring(0, 1).toUpperCase()
                        : (currentUser?.email?.isNotEmpty == true)
                            ? currentUser!.email!.substring(0, 1).toUpperCase() 
                            : 'U',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: QRKeyTheme.primarySaffron,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.displayName ?? currentUser?.email ?? 'Restaurant Manager',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        currentUser?.email ?? 'manager@restaurant.com',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPlanBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanBadge() {
    if (_subscription == null) return const SizedBox.shrink();
    
    Color badgeColor;
    switch (_subscription!.plan) {
      case SubscriptionPlan.free:
        badgeColor = Colors.grey;
        break;
      case SubscriptionPlan.premium:
        badgeColor = Colors.orange;
        break;
      case SubscriptionPlan.enterprise:
        badgeColor = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        _subscription!.plan.displayName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    final canAccess = _subscription?.plan != SubscriptionPlan.free;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: QRKeyTheme.primarySaffron),
                const SizedBox(width: 8),
                Text(
                  'Analytics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: QRKeyTheme.primarySaffron,
                  ),
                ),
                const Spacer(),
                if (!canAccess)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Premium',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              canAccess 
                  ? 'View detailed sales reports, customer insights, and business analytics'
                  : 'Upgrade to premium to access advanced analytics and reporting features',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: canAccess ? _openAnalytics : _showUpgradeDialog,
                icon: Icon(canAccess ? Icons.analytics : Icons.star),
                label: Text(canAccess ? 'View Analytics' : 'Upgrade to Premium'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAccess ? QRKeyTheme.primarySaffron : Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: QRKeyTheme.primarySaffron),
                const SizedBox(width: 8),
                Text(
                  'Subscription',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: QRKeyTheme.primarySaffron,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_subscription != null) ...[
              Text(
                'Current Plan: ${_subscription!.plan.displayName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_subscription!.daysRemaining != null) ...[
                const SizedBox(height: 8),
                Text('${_subscription!.daysRemaining} days remaining'),
              ],
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openSubscriptionManagement,
                icon: const Icon(Icons.manage_accounts),
                label: const Text('Manage Subscription'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: QRKeyTheme.primarySaffron,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQSRSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant_menu, color: QRKeyTheme.primarySaffron),
                const SizedBox(width: 8),
                Text(
                  'Restaurant Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: QRKeyTheme.primarySaffron,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsTile(
              icon: Icons.print,
              title: 'Printer Settings',
              subtitle: 'Configure KOT and bill printing',
              onTap: () => _showComingSoon('Printer Settings'),
            ),
            _buildSettingsTile(
              icon: Icons.receipt,
              title: 'Bill Templates',
              subtitle: 'Customize bill formats',
              onTap: () => _showComingSoon('Bill Templates'),
            ),
            _buildSettingsTile(
              icon: Icons.language,
              title: 'Language & Currency',
              subtitle: 'App language and currency settings',
              onTap: () => _showComingSoon('Language & Currency'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: QRKeyTheme.primarySaffron),
                const SizedBox(width: 8),
                Text(
                  'App Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: QRKeyTheme.primarySaffron,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsTile(
              icon: Icons.cloud,
              title: 'Cloud Backup & Sync',
              subtitle: 'Manage data backup and synchronization',
              onTap: _openCloudFeatures,
              premium: _subscription?.plan == SubscriptionPlan.free,
            ),
            _buildSettingsTile(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Configure app notifications',
              onTap: () => _showComingSoon('Notifications'),
            ),
            _buildSettingsTile(
              icon: Icons.security,
              title: 'Privacy & Security',
              subtitle: 'App security settings',
              onTap: () => _showComingSoon('Privacy & Security'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, color: QRKeyTheme.primarySaffron),
                const SizedBox(width: 8),
                Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: QRKeyTheme.primarySaffron,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSettingsTile(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () => _showComingSoon('Help & Support'),
            ),
            _buildSettingsTile(
              icon: Icons.info,
              title: 'About QRKEY',
              subtitle: 'App information and version',
              onTap: _showAboutDialog,
            ),
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out from your account',
              onTap: _showLogoutDialog,
              destructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool premium = false,
    bool destructive = false,
  }) {
    Color iconColor = destructive 
        ? Colors.red.shade600 
        : premium 
            ? Colors.grey.shade400 
            : QRKeyTheme.primarySaffron;
    
    Color textColor = destructive 
        ? Colors.red.shade600 
        : premium 
            ? Colors.grey.shade500 
            : Colors.black87;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: premium ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
          if (premium)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Premium',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: premium ? _showPremiumRequired : onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }

  // Navigation methods
  void _openAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
    );
  }

  void _openSubscriptionManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SubscriptionManagementScreen()),
    );
  }

  void _openCloudFeatures() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CloudFeaturesScreen()),
    );
  }

  void _showPremiumRequired() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature requires a premium subscription'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: const Text('Unlock analytics, cloud sync, and advanced features!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openSubscriptionManagement();
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature feature coming soon!')),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'QRKEY',
      applicationVersion: '1.0.0',
      applicationIcon: const QRKeyLogo(width: 64, height: 64),
      children: [
        const Text('Enhanced Restaurant Management System'),
        const SizedBox(height: 8),
        const Text('Built with Flutter and Firebase'),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout from QRKEY?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performLogout();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Logging out...'),
            ],
          ),
        ),
      );

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      
      // Clear any cached subscription data
      await SubscriptionService.clearCache();
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged out'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if it's open
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
