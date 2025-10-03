import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../clean_qsr_main.dart' as original_app;
import '../kot_screen.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';
import '../shared/widgets/premium_upgrade_widgets.dart';
import 'freemium_demo_screen.dart';
import 'supabase_demo_screen.dart';
import 'subscription_management_screen.dart';
import 'cloud_features_screen.dart';

/// Enhanced main screen that integrates freemium and Supabase features
/// without disturbing the existing QSR system UI
class EnhancedMainScreen extends ConsumerStatefulWidget {
  const EnhancedMainScreen({super.key});

  @override
  ConsumerState<EnhancedMainScreen> createState() => _EnhancedMainScreenState();
        return _buildCloudScreen();

class _EnhancedMainScreenState extends ConsumerState<EnhancedMainScreen> {
  UserSubscription? _subscription;
  Map<String, dynamic>? _usageStats;
  bool _isLoadingSubscription = true;
  int _selectedIndex = 0;

  Widget _buildCloudScreen() {
    return const CloudFeaturesScreen();
  }
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
            Text('Loading QSR Management...'),
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
      selectedItemColor: Colors.blue[600],
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentUser?.displayName ?? 
                currentUser?.email?.split('@').first ?? 
                'Restaurant Owner',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        _buildPlanBadge(),
      ],
    );
  }

  Widget _buildPlanBadge() {
    if (_subscription == null) return const SizedBox.shrink();
    
    final plan = _subscription!.plan;
    Color badgeColor;
    switch (plan) {
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
        plan.displayName.toUpperCase(),
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
    }
    
    return _buildPremiumStatusBanner();
  }

  Widget _buildUpgradeBanner() {
    final menuItemsUsed = _usageStats?['menuItemsUsed'] ?? 0;
    final menuItemsLimit = _subscription?.limits.maxMenuItems ?? 10;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Unlock Premium Features',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: _showUpgradeDialog,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Upgrade'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'You\'re using $menuItemsUsed of $menuItemsLimit menu items',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: menuItemsUsed / menuItemsLimit,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green.shade600,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_subscription!.plan.displayName} Plan Active',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                if (_subscription!.nextBillingDate != null)
                  Text(
                    'Next billing: ${_formatDate(_subscription!.nextBillingDate!)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade600,
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
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildQuickActionCard(
              icon: Icons.restaurant_menu,
              title: 'QSR System',
              subtitle: 'Manage orders & menu',
              color: Colors.blue,
              onTap: () => _navigateToQSRSystem(),
            ),
            _buildQuickActionCard(
              icon: Icons.print,
              title: 'KOT Screen',
              subtitle: 'Kitchen orders',
              color: Colors.orange,
              onTap: () => _navigateToKOTScreen(),
            ),
            _buildQuickActionCard(
              icon: Icons.cloud,
              title: 'Cloud Sync',
              subtitle: 'Backup & sync data',
              color: Colors.purple,
              isPremium: true,
              onTap: () => _navigateToCloudFeatures(),
            ),
            _buildQuickActionCard(
              icon: Icons.analytics,
              title: 'Analytics',
              subtitle: 'Reports & insights',
              color: Colors.green,
              isPremium: true,
              onTap: () => _showAnalyticsFeature(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    final canAccess = !isPremium || 
        (_subscription?.plan != SubscriptionPlan.free);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: canAccess ? onTap : () => _showPremiumRequired(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  if (isPremium && !canAccess)
                    Icon(
                      Icons.lock,
                      color: Colors.grey.shade400,
                      size: 16,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: canAccess ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: canAccess ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _navigateToQSRSystem(),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildActivityCard(
          'Order #1234 completed',
          '2 minutes ago',
          Icons.check_circle,
          Colors.green,
        ),
        _buildActivityCard(
          'New menu item added',
          '1 hour ago',
          Icons.restaurant_menu,
          Colors.blue,
        ),
        _buildActivityCard(
          'Daily report generated',
          '1 day ago',
          Icons.analytics,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildActivityCard(String title, String time, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(time, style: const TextStyle(fontSize: 12)),
        dense: true,
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
            const Text(
              'All Features',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
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
        final canAccess = !feature.isPremium || 
            (_subscription?.plan != SubscriptionPlan.free);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              feature.icon,
              color: canAccess ? Colors.blue : Colors.grey,
            ),
            title: Text(
              feature.title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: canAccess ? Colors.black87 : Colors.grey,
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
              backgroundColor: Colors.blue.shade100,
              backgroundImage: currentUser?.photoURL != null 
                  ? NetworkImage(currentUser!.photoURL!) 
                  : null,
              child: currentUser?.photoURL == null
                  ? Icon(Icons.person, size: 40, color: Colors.blue.shade600)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              currentUser?.displayName ?? 'Restaurant Owner',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (currentUser?.email != null)
              Text(
                currentUser!.email!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Plan: ${_subscription!.plan.displayName}'),
                const Spacer(),
                _buildPlanBadge(),
              ],
            ),
            const SizedBox(height: 8),
            Text('Status: ${_subscription!.status.displayName}'),
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
              MaterialPageRoute(builder: (_) => const FreemiumDemoScreen()),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.cloud),
            title: const Text('Supabase Demo'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SupabaseDemoScreen()),
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
        _navigateToQSRSystem();
        break;
      case 'KOT System':
        _navigateToKOTScreen();
        break;
      case 'Cloud Sync':
        _navigateToCloudFeatures();
        break;
      default:
        _showComingSoon(feature.title);
    }
  }

  // Dialog methods
  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => const PremiumUpgradeDialog(),
    );
  }

  void _showPremiumRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text(
          'This feature is available with Premium or Enterprise plans. '
          'Upgrade your subscription to unlock advanced features.',
        ),
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

  void _showAnalyticsFeature() {
    if (_subscription?.plan == SubscriptionPlan.free) {
      _showPremiumRequired();
    } else {
      _showComingSoon('Analytics');
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
