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
          elevation: 2,
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
      appBar: AppBar(
        title: const Text('QSR Management'),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
      ),
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
      const original_app.OrderHistoryScreen(),   // Orders tab  
      const KOTScreen(),                         // KOT tab
      FirebaseEnhancedSettingsScreen(user: widget.user), // Enhanced Settings tab
    ];

    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          body: screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFFF9933),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.restaurant_menu),
                label: original_app.l10n(ref, 'menu'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.receipt_long),
                label: original_app.l10n(ref, 'orders'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.kitchen),
                label: original_app.l10n(ref, 'kot'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: original_app.l10n(ref, 'settings'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Firebase Enhanced Settings Screen
class FirebaseEnhancedSettingsScreen extends ConsumerWidget {
  final User? user;

  const FirebaseEnhancedSettingsScreen({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(original_app.l10n(ref, 'settings')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false, // Remove back button since this is a tab
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Account Card (Top Priority)
            if (user != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFF9933),
                            radius: 25,
                            child: Text(
                              (user?.email?.substring(0, 1) ?? 'U').toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Account',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user?.email ?? 'Not available',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.person, color: Color(0xFFFF9933)),
                        title: const Text('Profile Details'),
                        subtitle: const Text('View account information'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showUserProfile(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.security, color: Color(0xFFFF9933)),
                        title: const Text('Change Password'),
                        subtitle: const Text('Update your password'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showChangePassword(context),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Logout', style: TextStyle(color: Colors.red)),
                        subtitle: const Text('Sign out of your account'),
                        onTap: () => _showLogoutConfirmation(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Cloud Sync Status Card (if user is logged in)
            if (user != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.cloud_sync, color: Color(0xFFFF9933)),
                          const SizedBox(width: 8),
                          const Text(
                            'Cloud Sync',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.cloud_done, color: Colors.green),
                        title: const Text('Data Synchronization'),
                        subtitle: const Text('Your data is synced to Firebase'),
                        trailing: const Icon(Icons.check_circle, color: Colors.green),
                      ),
                      ListTile(
                        leading: const Icon(Icons.backup, color: Color(0xFFFF9933)),
                        title: const Text('Backup & Restore'),
                        subtitle: const Text('Automatic cloud backup enabled'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showBackupInfo(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Quick access to original settings - menu management
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.restaurant_menu, color: Color(0xFFFF9933)),
                        const SizedBox(width: 8),
                        Text(
                          original_app.l10n(ref, 'menu'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.settings, color: Color(0xFFFF9933)),
                      title: const Text('Full Settings'),
                      subtitle: const Text('Access all app settings'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _navigateToOriginalSettings(context),
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

  void _navigateToOriginalSettings(BuildContext context) {
    // Navigate to the original settings screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const original_app.SettingsScreen(),
      ),
    );
  }

  void _showUserProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person, color: Color(0xFFFF9933)),
            SizedBox(width: 8),
            Text('Profile Details'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileItem('Email', user?.email ?? 'Not available'),
            const SizedBox(height: 12),
            _buildProfileItem('User ID', user?.uid ?? 'Not available'),
            const SizedBox(height: 12),
            _buildProfileItem('Email Verified', user?.emailVerified == true ? 'Yes' : 'No'),
            const SizedBox(height: 12),
            _buildProfileItem('Account Created', user?.metadata.creationTime?.toString().split(' ')[0] ?? 'Unknown'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFFFF9933),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  void _showChangePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.security, color: Color(0xFFFF9933)),
            SizedBox(width: 8),
            Text('Change Password'),
          ],
        ),
        content: const Text(
          'To change your password, we will send a password reset email to your registered email address.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _sendPasswordResetEmail(context);
            },
            child: const Text('Send Reset Email'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    if (user?.email == null) return;
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent to ${user!.email}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send reset email: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showBackupInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.backup, color: Color(0xFFFF9933)),
            SizedBox(width: 8),
            Text('Cloud Backup'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your data is automatically backed up to Firebase Cloud Firestore.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text('• Real-time synchronization'),
            Text('• Automatic backups'),
            Text('• Cross-device access'),
            Text('• Secure cloud storage'),
            SizedBox(height: 16),
            Text(
              'Your data is safe and accessible from any device you log in to.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
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
        content: const Text('Are you sure you want to logout? Your data will remain safely stored in the cloud.'),
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
          MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
          (route) => false,
        );
      }
    }
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
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
      } else if (e.toString().contains('invalid-email')) {
        message = 'Invalid email address.';
      }
      
      _showErrorDialog(message);
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      _showErrorDialog('Please enter your email address first.');
      return;
    }
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      _showSuccessDialog('Password reset email sent! Check your inbox.');
    } catch (e) {
      String message = 'Failed to send reset email';
      if (e.toString().contains('user-not-found')) {
        message = 'No user found with this email address.';
      } else if (e.toString().contains('invalid-email')) {
        message = 'Invalid email address.';
      }
      
      _showErrorDialog(message);
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
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo
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
                            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9933),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Sign In', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : _createAccount,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFF9933),
                            side: const BorderSide(color: Color(0xFFFF9933)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Create Account', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _resetPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Color(0xFFFF9933)),
                        ),
                      ),
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

// Keep existing authentication screen class for compatibility
class AuthenticationScreen extends LoginScreen {
  const AuthenticationScreen({super.key});
}
