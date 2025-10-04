import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../clean_qsr_main.dart' as original_app;
import '../kot_screen.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';
import '../core/theme/qrkey_theme.dart';
import 'freemium_demo_screen.dart';
import 'supabase_demo_screen.dart';
import 'subscription_management_screen.dart';
import 'cloud_features_screen.dart';
import '../widgets/qrkey_logo.dart';

/// Enhanced main screen that integrates freemium and Supabase features
/// without disturbing the existing QSR system UI
class EnhancedMainScreen extends ConsumerStatefulWidget {
  const EnhancedMainScreen({super.key});

  @override
  ConsumerState<EnhancedMainScreen> createState() => _EnhancedMainScreenState();
}

class _EnhancedMainScreenState extends ConsumerState<EnhancedMainScreen> {
  UserSubscription? _subscription;
  Map<String, dynamic>? _usageStats;
  bool _isLoadingSubscription = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionData();
  }

  Future<void> _loadSubscriptionData() async {
    try {
      final subscription = SubscriptionService.getCurrentSubscription();
      final usage = await SubscriptionService.getUsageStatistics();
      
      setState(() {
        _subscription = subscription;
        _usageStats = usage;
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
    final currentUser = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      body: _isLoadingSubscription 
        ? _buildLoadingScreen()
        : _buildMainContent(currentUser),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading QRKEY...'),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(User? currentUser) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeScreen(currentUser);
      case 1:
        return _buildFeaturesScreen();
      case 2:
        return _buildCloudScreen();
      case 3:
        return _buildProfileScreen(currentUser);
      default:
        return _buildHomeScreen(currentUser);
    }
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: QRKeyTheme.primaryBlue, // Main app blue color
      unselectedItemColor: Colors.grey[600],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Features',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud),
          label: 'Cloud',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildHomeScreen(User? currentUser) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(currentUser),
            const SizedBox(height: 20),
            _buildSubscriptionBanner(),
            const SizedBox(height: 20),
            _buildQuickActions(),
            const SizedBox(height: 20),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(User? currentUser) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: QRKeyTheme.primaryBlue.withOpacity(0.1), // Blue background
                  child: Text(
                    (currentUser?.displayName?.isNotEmpty == true) 
                        ? currentUser!.displayName!.substring(0, 1).toUpperCase()
                        : (currentUser?.email?.isNotEmpty == true)
                            ? currentUser!.email!.substring(0, 1).toUpperCase() 
                            : 'U',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: QRKeyTheme.primaryBlue, // Blue color
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        currentUser?.displayName ?? 
                        currentUser?.email ?? 
                        'Restaurant Manager',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildPlanBadge(),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      onPressed: _showLogoutDialog,
                      tooltip: 'Logout',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
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

  Widget _buildSubscriptionBanner() {
    if (_subscription == null) return const SizedBox.shrink();
    
    if (_subscription!.plan == SubscriptionPlan.free) {
      return _buildUpgradeBanner();
    } else {
      return _buildPremiumStatusBanner();
    }
  }

  Widget _buildUpgradeBanner() {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.star, color: Colors.orange.shade600, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Premium',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Unlock advanced analytics, cloud sync, and more!',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 14,
                    ),
                  ),
                  if (_subscription!.nextBillingDate != null)
                    Text(
                      'Next billing: ${_formatDate(_subscription!.nextBillingDate!)}',
                      style: TextStyle(
                        color: Colors.orange.shade600,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _showUpgradeDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Upgrade'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumStatusBanner() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_subscription!.plan.displayName} Plan Active',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You have access to all premium features!',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 14,
                    ),
                  ),
                  if (_subscription!.daysRemaining != null)
                    Text(
                      '${_subscription!.daysRemaining} days remaining',
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _navigateToSubscriptionManagement(),
              child: const Text('Manage'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildQuickActionCard(
                  icon: Icons.restaurant_menu,
                  title: 'QRKEY System',
                  subtitle: 'Full restaurant management',
                  onTap: () => _navigateToQSRSystem(),
                ),
                _buildQuickActionCard(
                  icon: Icons.print,
                  title: 'KOT Screen',
                  subtitle: 'Kitchen order tickets',
                  onTap: () => _navigateToKOTScreen(),
                ),
                _buildQuickActionCard(
                  icon: Icons.cloud,
                  title: 'Cloud Features',
                  subtitle: 'Sync and backup',
                  onTap: () => _navigateToCloudFeatures(),
                ),
                _buildQuickActionCard(
                  icon: Icons.analytics,
                  title: 'Analytics',
                  subtitle: 'Sales insights',
                  onTap: () => _showAnalyticsFeature(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool canAccess = true,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: canAccess ? onTap : () => _showPremiumRequired(),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: canAccess ? QRKeyTheme.primaryBlue : Colors.grey.shade400, // Blue color
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: canAccess ? Colors.black87 : Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: canAccess ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _navigateToQSRSystem(),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActivityCard(
              'Order #1234 completed',
              '2 minutes ago',
              Icons.check_circle,
              Colors.green,
            ),
            _buildActivityCard(
              'New menu item added',
              '15 minutes ago',
              Icons.restaurant_menu,
              QRKeyTheme.primaryBlue, // Blue color
            ),
            _buildActivityCard(
              'KOT printed for Table 5',
              '1 hour ago',
              Icons.print,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesScreen() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Features',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildFeaturesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      FeatureInfo('Order Management', 'Create and track orders', Icons.shopping_cart, false),
      FeatureInfo('Menu Management', 'Organize your menu items', Icons.restaurant_menu, false),
      FeatureInfo('KOT System', 'Kitchen order tickets', Icons.print, false),
      FeatureInfo('Analytics', 'Sales reports and insights', Icons.analytics, true),
      FeatureInfo('Cloud Sync', 'Backup and synchronization', Icons.cloud, true),
      FeatureInfo('Multi-device', 'Access from multiple devices', Icons.devices, true),
      FeatureInfo('API Access', 'Integration capabilities', Icons.api, true),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        final canAccess = !feature.isPremium || (_subscription?.plan != SubscriptionPlan.free);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              feature.icon,
              color: canAccess ? QRKeyTheme.primaryBlue : Colors.grey.shade400, // Blue color
            ),
            title: Text(
              feature.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: canAccess ? Colors.black87 : Colors.grey.shade500,
              ),
            ),
            subtitle: Text(
              feature.description,
              style: TextStyle(
                color: canAccess ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
            ),
            trailing: feature.isPremium && !canAccess
                ? Icon(Icons.lock, color: Colors.grey.shade400)
                : const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: canAccess ? () => _openFeature(feature) : () => _showPremiumRequired(),
          ),
        );
      },
    );
  }

  Widget _buildCloudScreen() {
    return const CloudFeaturesScreen();
  }

  Widget _buildProfileScreen(User? currentUser) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(currentUser),
            const SizedBox(height: 20),
            _buildSubscriptionInfo(),
            const SizedBox(height: 20),
            _buildProfileOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User? currentUser) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: QRKeyTheme.primaryBlue.withOpacity(0.1), // Blue background
              child: Text(
                (currentUser?.displayName?.isNotEmpty == true) 
                    ? currentUser!.displayName!.substring(0, 1).toUpperCase()
                    : (currentUser?.email?.isNotEmpty == true)
                        ? currentUser!.email!.substring(0, 1).toUpperCase() 
                        : 'U',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: QRKeyTheme.primaryBlue, // Blue color
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentUser?.displayName ?? currentUser?.email ?? 'Restaurant Manager',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
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
    );
  }

  Widget _buildSubscriptionInfo() {
    if (_subscription == null) return const SizedBox.shrink();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Subscription',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                _buildPlanBadge(),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Current Plan: ${_subscription!.plan.displayName}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_subscription!.nextBillingDate != null) ...[
              const SizedBox(height: 8),
              Text('Next billing: ${_formatDate(_subscription!.nextBillingDate!)}'),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToSubscriptionManagement,
                child: const Text('Manage Subscription'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Freemium Demo'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FreemiumDemoScreen()),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text('Supabase Demo'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SupabaseDemoScreen()),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showComingSoon('Settings'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showComingSoon('Help & Support'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade600),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red.shade600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLogoutDialog(),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToQSRSystem() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => original_app.QSRApp()),
    );
  }

  void _navigateToKOTScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const KOTScreen()),
    );
  }

  void _navigateToCloudFeatures() {
    if (_subscription?.plan == SubscriptionPlan.free) {
      _showPremiumRequired();
    } else {
      setState(() => _selectedIndex = 2);
    }
  }

  void _navigateToSubscriptionManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SubscriptionManagementScreen()),
    );
  }

  void _openFeature(FeatureInfo feature) {
    switch (feature.title) {
      case 'Order Management':
      case 'Menu Management':
      case 'KOT System':
        _navigateToQSRSystem();
        break;
      case 'Cloud Sync':
        _navigateToCloudFeatures();
        break;
      default:
        _showComingSoon(feature.title);
    }
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Premium'),
        content: const Text('Unlock all premium features including analytics, cloud sync, and more!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showUpgradeDialog();
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
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

  void _showAnalyticsFeature() {
    if (_subscription?.plan == SubscriptionPlan.free) {
      _showPremiumRequired();
    } else {
      _showComingSoon('Analytics');
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature feature coming soon!')),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class FeatureInfo {
  final String title;
  final String description;
  final IconData icon;
  final bool isPremium;

  FeatureInfo(this.title, this.description, this.icon, this.isPremium);
}
