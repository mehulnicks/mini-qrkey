import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../clean_qsr_main.dart' as qsr;
import '../kot_screen.dart';
import '../services/subscription_service.dart';
import '../shared/models/subscription_models.dart';
import '../core/theme/qrkey_theme.dart';
import 'freemium_demo_screen.dart';
import 'supabase_demo_screen.dart';
import 'subscription_management_screen.dart';
import 'cloud_features_screen.dart';
import 'sales_reports_screen.dart';
import 'business_insights_screen.dart';
import 'live_dashboard_screen.dart';
import '../widgets/qrkey_logo.dart';
import '../widgets/subscription_dashboard_widget.dart';
import '../widgets/subscription_metrics_widget.dart';
import '../providers/subscription_provider.dart';
import 'debug_subscription_screen.dart';

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
    
    return _isLoadingSubscription 
      ? _buildLoadingScreen()
      : _buildQSRSystemScreen();
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
        return _buildDashboardScreen(currentUser);
      case 1:
        return _buildQSRSystemScreen();
      default:
        return _buildDashboardScreen(currentUser);
    }
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: QRKeyTheme.primarySaffron, // Main app blue color
      unselectedItemColor: Colors.grey[600],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'QRKEY System',
        ),
      ],
    );
  }

  Widget _buildDashboardScreen(User? currentUser) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(currentUser),
            const SizedBox(height: 8),
            // Quick metrics overview
            const QuickMetricsWidget(),
            const SizedBox(height: 8),
            _buildQuickStats(),
            const SizedBox(height: 8),
            // Subscription Metrics Widget (compact version for overview)
            const SubscriptionMetricsWidget(compact: true),
            const SizedBox(height: 8),
            _buildQuickActions(),
            const SizedBox(height: 8),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Today\'s Orders',
                    '24',
                    Icons.receipt_long,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildStatCard(
                    'Revenue',
                    '\$1,250',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Pending Orders',
                    '3',
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildStatCard(
                    'Menu Items',
                    '45',
                    Icons.restaurant_menu,
                    QRKeyTheme.primarySaffron,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(User? currentUser) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: QRKeyTheme.primarySaffron.withOpacity(0.1), // Blue background
                  child: Text(
                    (currentUser?.displayName?.isNotEmpty == true) 
                        ? currentUser!.displayName!.substring(0, 1).toUpperCase()
                        : (currentUser?.email?.isNotEmpty == true)
                            ? currentUser!.email!.substring(0, 1).toUpperCase() 
                            : 'U',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: QRKeyTheme.primarySaffron, // Blue color
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        currentUser?.displayName ?? 
                        currentUser?.email ?? 
                        'Restaurant Manager',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // Compact Subscription Widget
                    const CompactSubscriptionWidget(),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: Icon(
                        Icons.bug_report,
                        color: QRKeyTheme.primarySaffron,
                        size: 16,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DebugSubscriptionScreen(),
                          ),
                        );
                      },
                      tooltip: 'Debug Subscription',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.restaurant_menu,
                    title: 'QRKEY System',
                    subtitle: 'Full restaurant management',
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.print,
                    title: 'KOT Screen',
                    subtitle: 'Kitchen orders only',
                    onTap: () => _navigateToKOTScreen(),
                  ),
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
                size: 28,
                color: canAccess ? QRKeyTheme.primarySaffron : Colors.grey.shade400, // Blue color
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: canAccess ? Colors.black87 : Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: canAccess ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
                textAlign: TextAlign.center,
              ),
              if (!canAccess)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Premium',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
        padding: const EdgeInsets.all(12),
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
            const SizedBox(height: 8),
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
              QRKeyTheme.primarySaffron, // Blue color
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

  // Navigation methods
  void _navigateToQSRSystem() {
    setState(() => _selectedIndex = 1);
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
              color: canAccess ? QRKeyTheme.primarySaffron : Colors.grey.shade400, // Blue color
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

  Widget _buildQSRSystemScreen() {
    // Directly return the QSR MainScreen without MaterialApp wrapper
    return qsr.MainScreen();
  }

  Widget _buildAnalyticsScreen() {
    if (_subscription?.plan == SubscriptionPlan.free) {
      return _buildPremiumFeatureScreen(
        'Analytics',
        'Advanced analytics and reporting features are available with premium subscription.',
        Icons.analytics,
      );
    }
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.analytics,
                      size: 64,
                      color: QRKeyTheme.primarySaffron,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Advanced Analytics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Real-time sales reports, customer insights, and business intelligence features are coming soon!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFeatureScreen(String featureName, String description, IconData icon) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              '$featureName Feature',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _navigateToSubscriptionManagement,
              icon: const Icon(Icons.star),
              label: const Text('Upgrade to Premium'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsScreen(User? currentUser) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            
            // Profile Section
            _buildSettingsSection(
              title: 'Profile',
              children: [
                _buildSettingsHeader(currentUser),
                const SizedBox(height: 8),
                _buildSettingsTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () => _showComingSoon('Edit Profile'),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Subscription Section
            _buildSettingsSection(
              title: 'Subscription',
              children: [
                _buildSubscriptionStatusTile(),
                _buildSettingsTile(
                  icon: Icons.star_outline,
                  title: 'Manage Subscription',
                  subtitle: 'View plans and billing information',
                  onTap: _navigateToSubscriptionManagement,
                ),
                _buildSettingsTile(
                  icon: Icons.analytics_outlined,
                  title: 'Usage Statistics',
                  subtitle: 'View your app usage data',
                  onTap: () => _showUsageStats(),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Analytics & Reports Section
            _buildSettingsSection(
              title: 'Analytics & Reports',
              children: [
                _buildSettingsTile(
                  icon: Icons.bar_chart,
                  title: 'Sales Reports',
                  subtitle: 'Detailed sales analysis and reports',
                  onTap: () => _navigateToSalesReports(),
                  premium: _subscription?.plan == SubscriptionPlan.free,
                ),
                _buildSettingsTile(
                  icon: Icons.insights,
                  title: 'Business Insights',
                  subtitle: 'AI-powered business intelligence',
                  onTap: () => _navigateToBusinessInsights(),
                  premium: _subscription?.plan == SubscriptionPlan.free,
                ),
                _buildSettingsTile(
                  icon: Icons.dashboard,
                  title: 'Live Dashboard',
                  subtitle: 'Real-time business monitoring',
                  onTap: () => _navigateToLiveDashboard(),
                  premium: _subscription?.plan == SubscriptionPlan.free,
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // App Settings Section
            _buildSettingsSection(
              title: 'App Settings',
              children: [
                _buildSettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: () => _showComingSoon('Notifications'),
                ),
                _buildSettingsTile(
                  icon: Icons.backup_outlined,
                  title: 'Backup & Sync',
                  subtitle: 'Manage cloud backup settings',
                  onTap: () => _navigateToCloudFeatures(),
                  premium: _subscription?.plan == SubscriptionPlan.free,
                ),
                _buildSettingsTile(
                  icon: Icons.security_outlined,
                  title: 'Privacy & Security',
                  subtitle: 'App security and privacy settings',
                  onTap: () => _showComingSoon('Privacy & Security'),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Support Section
            _buildSettingsSection(
              title: 'Support',
              children: [
                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () => _showComingSoon('Help Center'),
                ),
                _buildSettingsTile(
                  icon: Icons.bug_report_outlined,
                  title: 'Report Issue',
                  subtitle: 'Report bugs or issues',
                  onTap: () => _showComingSoon('Report Issue'),
                ),
                _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () => _showAboutDialog(),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Logout Section
            _buildSettingsSection(
              title: 'Account',
              children: [
                _buildSettingsTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  subtitle: 'Sign out from your account',
                  onTap: _showLogoutDialog,
                  destructive: true,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
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
              backgroundColor: QRKeyTheme.primarySaffron.withOpacity(0.1), // Blue background
              child: Text(
                (currentUser?.displayName?.isNotEmpty == true) 
                    ? currentUser!.displayName!.substring(0, 1).toUpperCase()
                    : (currentUser?.email?.isNotEmpty == true)
                        ? currentUser!.email!.substring(0, 1).toUpperCase() 
                        : 'U',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: QRKeyTheme.primarySaffron, // Blue color
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
                const CompactSubscriptionWidget(),
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

  // Settings screen helper methods
  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: QRKeyTheme.primarySaffron,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsHeader(User? currentUser) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: QRKeyTheme.primarySaffron.withOpacity(0.1),
          child: Text(
            (currentUser?.displayName?.isNotEmpty == true) 
                ? currentUser!.displayName!.substring(0, 1).toUpperCase()
                : (currentUser?.email?.isNotEmpty == true)
                    ? currentUser!.email!.substring(0, 1).toUpperCase() 
                    : 'U',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: QRKeyTheme.primarySaffron,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentUser?.displayName ?? currentUser?.email ?? 'Restaurant Manager',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                currentUser?.email ?? 'manager@restaurant.com',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const CompactSubscriptionWidget(),
      ],
    );
  }

  Widget _buildSubscriptionStatusTile() {
    if (_subscription == null) return const SizedBox.shrink();
    
    Color statusColor = _subscription!.plan == SubscriptionPlan.free 
        ? Colors.grey 
        : Colors.green;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            _subscription!.plan == SubscriptionPlan.free ? Icons.star_border : Icons.star,
            color: statusColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_subscription!.plan.displayName} Plan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
                if (_subscription!.plan != SubscriptionPlan.free && _subscription!.daysRemaining != null)
                  Text(
                    '${_subscription!.daysRemaining} days remaining',
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                    ),
                  ),
                if (_subscription!.plan == SubscriptionPlan.free)
                  Text(
                    'Upgrade to unlock premium features',
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
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
      onTap: premium ? () => _showPremiumRequired() : onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }

  void _showUsageStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usage Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_usageStats != null) ...[
              Text('Orders this month: ${_usageStats!['ordersThisMonth'] ?? 0}'),
              Text('Menu items: ${_usageStats!['menuItemsCount'] ?? 0}'),
              Text('Total revenue: \$${_usageStats!['totalRevenue'] ?? 0}'),
            ] else
              const Text('No usage data available yet.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CloudFeaturesScreen()),
      );
    }
  }

  void _navigateToSubscriptionManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SubscriptionManagementScreen()),
    );
  }

  void _navigateToSalesReports() {
    if (_subscription?.plan == SubscriptionPlan.free) {
      _showPremiumRequired();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SalesReportsScreen()),
      );
    }
  }

  void _navigateToBusinessInsights() {
    if (_subscription?.plan == SubscriptionPlan.free) {
      _showPremiumRequired();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BusinessInsightsScreen()),
      );
    }
  }

  void _navigateToLiveDashboard() {
    if (_subscription?.plan == SubscriptionPlan.free) {
      _showPremiumRequired();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LiveDashboardScreen()),
      );
    }
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
    setState(() => _selectedIndex = 2);
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
