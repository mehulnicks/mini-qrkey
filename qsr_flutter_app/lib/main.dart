import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'clean_qsr_main.dart' as original_app;
import 'kot_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue without Firebase for demo purposes
  }
  
  runApp(const ProviderScope(child: QSRMobileApp()));
}

class QSRMobileApp extends StatelessWidget {
  const QSRMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QSR Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9933)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 48,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const AuthenticationWrapper(),
    );
  }
}

// Simple authentication wrapper that checks login state
class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkAuthenticationState();
  }

  Future<void> _checkAuthenticationState() async {
    try {
      // Check if Firebase is available
      final app = Firebase.app();
      
      // Listen to auth state changes
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (mounted) {
          setState(() {
            _currentUser = user;
            _isLoggedIn = user != null;
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print('Auth state check error: $e');
      // Check local login state as fallback
      await _checkLocalLogin();
    }
  }

  Future<void> _checkLocalLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('user_logged_in') ?? false;
      if (mounted) {
        setState(() {
          _isLoggedIn = isLoggedIn;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Local login check error: $e');
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }
    
    if (_isLoggedIn) {
      // User is logged in, show main app with user info
      return MainAppWithUser(user: _currentUser);
    } else {
      // User is not logged in, show login screen
      return const LoginScreen();
    }
  }
}

class MainAppWithUser extends StatelessWidget {
  final User? user;
  
  const MainAppWithUser({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirebaseEnhancedMainScreen(user: user),
    );
  }
}

// Firebase Enhanced Main Screen that integrates user account into settings
class FirebaseEnhancedMainScreen extends StatefulWidget {
  final User? user;

  const FirebaseEnhancedMainScreen({super.key, this.user});

  @override
  State<FirebaseEnhancedMainScreen> createState() => _FirebaseEnhancedMainScreenState();
}

class _FirebaseEnhancedMainScreenState extends State<FirebaseEnhancedMainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const original_app.OrderPlacementScreen(), // Menu tab
      const original_app.OrderHistoryScreen(), // Orders tab
      const KOTScreen(), // KOT tab
      original_app.SettingsScreen(), // Settings tab with all original features
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
}

// Enhanced Settings Screen with User Account Integration
class FirebaseEnhancedSettingsScreen extends StatelessWidget {
  final User? user;

  const FirebaseEnhancedSettingsScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 48,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            // User Account Section
            Card(
              color: const Color(0xFFFF9933).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9933),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.account_circle, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'User Account',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Color(0xFFFF9933)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user?.email ?? 'Local User',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.cloud, color: Color(0xFFFF9933)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user != null ? 'Cloud Sync Enabled' : 'Local Storage Only',
                            style: TextStyle(
                              fontSize: 14,
                              color: user != null ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // User account integration will be added to original settings through a separate approach
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Logout'),
          ],
        ),
        content: const Text('Are you sure you want to logout? Your data will remain safely stored.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      
      // Also clear local login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('user_logged_in', false);
      
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged out'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      // Navigation will be handled by the auth state listener
    } catch (e) {
      // Fallback logout for local state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('user_logged_in', false);
      
      // Force navigation
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}

class _SettingsContentWrapper extends StatelessWidget {
  const _SettingsContentWrapper();

  @override
  Widget build(BuildContext context) {
    // Create a view with just the essential settings for now
    return Consumer(
      builder: (context, ref, child) {
        final settings = ref.watch(original_app.settingsProvider);
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Business Settings Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.business, color: Color(0xFFFF9933)),
                        const SizedBox(width: 8),
                        const Text('Business Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.business),
                      title: const Text('Business Name'),
                      subtitle: Text(settings.businessName),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Business Name'),
                            content: TextField(
                              controller: TextEditingController(text: settings.businessName),
                              decoration: const InputDecoration(
                                labelText: 'Business Name',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  ref.read(original_app.settingsProvider.notifier).updateBusinessName(value);
                                }
                                Navigator.pop(context);
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Address'),
                      subtitle: Text(settings.address.isEmpty ? 'Not set' : settings.address),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Address'),
                            content: TextField(
                              controller: TextEditingController(text: settings.address),
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (value) {
                                ref.read(original_app.settingsProvider.notifier).updateAddress(value);
                                Navigator.pop(context);
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Phone'),
                      subtitle: Text(settings.phone.isEmpty ? 'Not set' : settings.phone),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Phone'),
                            content: TextField(
                              controller: TextEditingController(text: settings.phone),
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              onSubmitted: (value) {
                                ref.read(original_app.settingsProvider.notifier).updatePhone(value);
                                Navigator.pop(context);
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tax Settings Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.percent, color: Color(0xFFFF9933)),
                        const SizedBox(width: 8),
                        const Text('Tax Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.percent),
                      title: const Text('SGST Rate'),
                      subtitle: Text('${(settings.sgstRate * 100).toStringAsFixed(1)}%'),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('SGST Rate'),
                            content: TextField(
                              controller: TextEditingController(text: (settings.sgstRate * 100).toStringAsFixed(1)),
                              decoration: const InputDecoration(
                                labelText: 'SGST Rate (%)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                final rate = double.tryParse(value);
                                if (rate != null && rate >= 0 && rate <= 100) {
                                  ref.read(original_app.settingsProvider.notifier).updateSgstRate(rate / 100);
                                }
                                Navigator.pop(context);
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.percent),
                      title: const Text('CGST Rate'),
                      subtitle: Text('${(settings.cgstRate * 100).toStringAsFixed(1)}%'),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('CGST Rate'),
                            content: TextField(
                              controller: TextEditingController(text: (settings.cgstRate * 100).toStringAsFixed(1)),
                              decoration: const InputDecoration(
                                labelText: 'CGST Rate (%)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                final rate = double.tryParse(value);
                                if (rate != null && rate >= 0 && rate <= 100) {
                                  ref.read(original_app.settingsProvider.notifier).updateCgstRate(rate / 100);
                                }
                                Navigator.pop(context);
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Feature Settings Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.settings, color: Color(0xFFFF9933)),
                        const SizedBox(width: 8),
                        const Text('Feature Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      secondary: const Icon(Icons.print),
                      title: const Text('KOT Printing'),
                      subtitle: const Text('Enable automatic KOT printing when orders are placed'),
                      value: settings.kotEnabled,
                      activeColor: const Color(0xFFFF9933),
                      onChanged: (bool value) {
                        ref.read(original_app.settingsProvider.notifier).updateSettings(
                          settings.copyWith(kotEnabled: value),
                        );
                      },
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.delivery_dining),
                      title: const Text('Delivery Service'),
                      subtitle: const Text('Enable delivery orders with delivery charges'),
                      value: settings.deliveryEnabled,
                      activeColor: const Color(0xFFFF9933),
                      onChanged: (bool value) {
                        ref.read(original_app.settingsProvider.notifier).updateSettings(
                          settings.copyWith(deliveryEnabled: value),
                        );
                      },
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.inventory),
                      title: const Text('Packaging Service'),
                      subtitle: const Text('Enable packaging charges for takeaway orders'),
                      value: settings.packagingEnabled,
                      activeColor: const Color(0xFFFF9933),
                      onChanged: (bool value) {
                        ref.read(original_app.settingsProvider.notifier).updateSettings(
                          settings.copyWith(packagingEnabled: value),
                        );
                      },
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.room_service),
                      title: const Text('Service Charges'),
                      subtitle: const Text('Enable service charges for dine-in orders'),
                      value: settings.serviceEnabled,
                      activeColor: const Color(0xFFFF9933),
                      onChanged: (bool value) {
                        ref.read(original_app.settingsProvider.notifier).updateSettings(
                          settings.copyWith(serviceEnabled: value),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: Color(0xFFFF9933)),
                        const SizedBox(width: 8),
                        const Text('App Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const ListTile(
                      leading: Icon(Icons.info),
                      title: Text('Version'),
                      subtitle: Text('QSR Management v1.0.0'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.support),
                      title: const Text('Support'),
                      subtitle: const Text('Get help and support'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Support Information'),
                            content: const Text(
                              'For support and assistance:\n\n'
                              '• Check the app documentation\n'
                              '• Contact your system administrator\n'
                              '• Report bugs through the feedback feature'
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9933),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 80,
                color: Color(0xFFFF9933),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'QSR Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Set local login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('user_logged_in', true);
      
      // Navigation will be handled by the auth state listener
    } catch (e) {
      String message = 'Login failed';
      if (e.toString().contains('user-not-found')) {
        message = 'No user found with this email address.';
      } else if (e.toString().contains('wrong-password')) {
        message = 'Incorrect password.';
      } else if (e.toString().contains('invalid-email')) {
        message = 'Invalid email address.';
      }
      
      // Try local login as fallback
      await _localLogin();
      
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }
    
    // Firebase login successful
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainAppWithUser(user: FirebaseAuth.instance.currentUser)),
      );
    }
  }

  Future<void> _localLogin() async {
    // Simple local login for demo
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user_logged_in', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainAppWithUser()),
      );
    }
  }

  Future<void> _createAccount() async {
    setState(() => _isLoading = true);
    
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Set local login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('user_logged_in', true);
      
      _showSuccessDialog('Account created successfully!');
      
    } catch (e) {
      String message = 'Account creation failed';
      if (e.toString().contains('weak-password')) {
        message = 'The password provided is too weak.';
      } else if (e.toString().contains('email-already-in-use')) {
        message = 'The account already exists for that email.';
      }
      
      _showErrorDialog(message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9933),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              
              // Logo and Title
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: Color(0xFFFF9933),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'QSR Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              
              // Login Form
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else ...[
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9933),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Create Account Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: _createAccount,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFFF9933),
                              side: const BorderSide(color: Color(0xFFFF9933)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Demo Mode Button
                        TextButton(
                          onPressed: _localLogin,
                          child: const Text(
                            'Continue as Guest (Demo Mode)',
                            style: TextStyle(color: Color(0xFFFF9933)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
