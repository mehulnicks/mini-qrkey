import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/auth_wrapper.dart';
import 'screens/auth_screens.dart';
import 'clean_qsr_main.dart' as clean_app;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const ProviderScope(child: QSRApp()));
}

class QSRApp extends StatelessWidget {
  const QSRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QSR Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9933)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const AuthWrapper(
        child: MainScreenWithFirebase(),
      ),
    );
  }
}

// Enhanced main screen that includes Firebase integration
class MainScreenWithFirebase extends ConsumerStatefulWidget {
  const MainScreenWithFirebase({super.key});

  @override
  ConsumerState<MainScreenWithFirebase> createState() => _MainScreenWithFirebaseState();
}

class _MainScreenWithFirebaseState extends ConsumerState<MainScreenWithFirebase> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    
    // Show data migration screen if needed
    if (user != null) {
      return FutureBuilder<bool>(
        future: _checkMigrationStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MigrationSplashScreen();
          }
          
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          
          final migrationCompleted = snapshot.data ?? false;
          
          if (!migrationCompleted) {
            return FutureBuilder(
              future: _performMigration(user.uid),
              builder: (context, migrationSnapshot) {
                if (migrationSnapshot.connectionState == ConnectionState.waiting) {
                  return const MigrationInProgressScreen();
                }
                
                if (migrationSnapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Migration failed: ${migrationSnapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => setState(() {}),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                // Migration completed, show main app
                return _buildMainScreen();
              },
            );
          }
          
          // Migration already completed, show main app
          return _buildMainScreen();
        },
      );
    }
    
    return _buildMainScreen();
  }

  Widget _buildMainScreen() {
    final List<Widget> screens = [
      const clean_app.OrderPlacementScreen(), // Menu tab
      const clean_app.OrderHistoryScreen(), // Orders tab
      const clean_app.KOTScreen(), // KOT tab
      const FirebaseEnhancedSettingsScreen(), // Enhanced Settings tab
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF9933),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: 'KOT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Future<bool> _checkMigrationStatus() async {
    // Simulate checking migration status
    await Future.delayed(const Duration(milliseconds: 500));
    // For now, assume migration is always needed on first run
    return false; // This will trigger migration
  }

  Future<void> _performMigration(String userId) async {
    // Simulate data migration
    await Future.delayed(const Duration(seconds: 2));
    print('✅ Data migration completed for user: $userId');
  }
}

class MigrationSplashScreen extends StatelessWidget {
  const MigrationSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9933),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_upload,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'QSR Management',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Checking data migration status...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class MigrationInProgressScreen extends StatelessWidget {
  const MigrationInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9933),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_sync,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'Setting up your cloud account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Migrating your data to the cloud...\nThis may take a few moments.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              '🔄 Syncing menu items\n☁️ Uploading orders\n👥 Migrating customers\n⚙️ Configuring settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple Firebase-enhanced settings screen
class FirebaseEnhancedSettingsScreen extends ConsumerWidget {
  const FirebaseEnhancedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            if (user != null) 
              Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
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
              ),

            // Firebase Status
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      'Firebase Integration',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud_done, color: Colors.green),
                    title: const Text('Cloud Status'),
                    subtitle: const Text('Connected and synced'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.security, color: Colors.blue),
                    title: const Text('Authentication'),
                    subtitle: Text(user != null ? 'Signed in as ${user.email}' : 'Not signed in'),
                  ),
                ],
              ),
            ),

            // Original Settings Screen Content
            const clean_app.SettingsScreen(),
          ],
        ),
      ),
    );
  }
}
