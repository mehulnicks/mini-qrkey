import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'clean_qsr_main.dart' as original_app;
import 'kot_screen.dart';
import 'core/config/supabase_config.dart';
import 'screens/enhanced_main_screen.dart';
import 'widgets/qrkey_logo.dart';
import 'services/subscription_service.dart';
import 'core/theme/qrkey_theme.dart';

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
  
  try {
    // Initialize Supabase
    await SupabaseConfig.initialize();
    print('Supabase initialized successfully');
  } catch (e) {
    print('Supabase initialization error: $e');
    // Continue without Supabase for demo purposes
  }
  
  // Initialize subscription service
  await SubscriptionService.initialize();
  print('Subscription service initialized');
  
  runApp(const ProviderScope(child: QSRMobileApp()));
}

class QSRMobileApp extends StatelessWidget {
  const QSRMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRKEY',
      theme: QRKeyTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color(0xFF1F2937),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset(
                      'assets/images/qrkey_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'Loading QRKEY...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        // Handle authentication errors
        if (snapshot.hasError) {
          print('Auth stream error: ${snapshot.error}');
          return Scaffold(
            backgroundColor: const Color(0xFF1F2937),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 20),
                  Text(
                    'Authentication Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Try to refresh auth state
                      FirebaseAuth.instance.authStateChanges().listen((user) {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9933),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // User is authenticated - go to main screen
        if (snapshot.hasData && snapshot.data != null) {
          print('User authenticated: ${snapshot.data?.displayName ?? snapshot.data?.email}');
          return const EnhancedMainScreen();
        }

        // User not authenticated - show login screen
        print('User not authenticated, showing login screen');
        return const LoginScreen();
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: QRKeyTheme.getPrimaryGradientDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Title
                const QRKeyLogo(
                  width: 120,
                  height: 120,
                  iconColor: Colors.white,
                  iconSize: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  'QRKEY',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Enhanced Restaurant Management System',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Authentication Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Access the enhanced QRKEY system with freemium features and cloud integration',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        
                        // Username/Email Field
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        
                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
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
                        const SizedBox(height: 20),
                        
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _signInWithEmailPassword(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9933),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _registerWithEmailPassword(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFFF9933),
                              side: const BorderSide(color: Color(0xFFFF9933)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        
                        // Alternative Options
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _signInAnonymously(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Try Demo (Guest Mode)',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _signInWithGoogle(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Sign in with Google',
                              style: TextStyle(fontSize: 16),
                            ),
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
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      _showErrorSnackbar(context, 'Demo mode failed: $e');
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      // Configure Google Sign-In with proper scopes
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      
      // Sign out first to ensure clean state
      await googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      // Dismiss loading dialog
      if (context.mounted) Navigator.of(context).pop();
      
      if (googleUser == null) {
        _showErrorSnackbar(context, 'Google sign-in was cancelled');
        return;
      }

      // Show loading again for authentication
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Check if tokens are available
      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        if (context.mounted) Navigator.of(context).pop();
        _showErrorSnackbar(context, 'Failed to get Google authentication tokens. Please try again.');
        return;
      }

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      // Dismiss loading dialog
      if (context.mounted) Navigator.of(context).pop();
      
      if (userCredential.user != null) {
        // Success - user will be redirected by AuthWrapper automatically
        print('Google sign-in successful: ${userCredential.user?.displayName}');
        _showSuccessSnackbar(context, 'Welcome ${userCredential.user?.displayName ?? 'User'}!');
      } else {
        _showErrorSnackbar(context, 'Authentication failed - no user returned');
      }
    } catch (e) {
      // Dismiss any loading dialogs
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      String errorMessage = 'Google sign-in failed';
      if (e.toString().contains('network_error') || e.toString().contains('NetworkError')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else if (e.toString().contains('sign_in_canceled') || e.toString().contains('SIGN_IN_CANCELLED')) {
        errorMessage = 'Sign-in was cancelled by user.';
      } else if (e.toString().contains('sign_in_failed') || e.toString().contains('SIGN_IN_FAILED')) {
        errorMessage = 'Google sign-in failed. Please check your Google Play Services and try again.';
      } else if (e.toString().contains('account_exists_with_different_credential')) {
        errorMessage = 'An account already exists with this email using a different sign-in method.';
      } else {
        errorMessage = 'Google sign-in failed. Please try email/password login instead.';
      }
      
      print('Google sign-in error: $e');
      _showErrorSnackbar(context, errorMessage);
    }
  }

  Future<void> _signInWithEmailPassword(BuildContext context) async {
    // Validate input
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      _showErrorSnackbar(context, 'Please enter both email and password');
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Dismiss loading dialog
      if (context.mounted) Navigator.of(context).pop();

      if (userCredential.user != null) {
        print('Email sign-in successful: ${userCredential.user?.email}');
        // Success - user will be redirected by AuthWrapper automatically
      }
    } catch (e) {
      // Dismiss loading dialog
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      String errorMessage = 'Login failed';
      if (e.toString().contains('user-not-found')) {
        errorMessage = 'No account found with this email. Please create an account first.';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Invalid email address format.';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = 'Too many failed attempts. Please try again later.';
      } else {
        errorMessage = 'Login failed: ${e.toString()}';
      }

      print('Email sign-in error: $e');
      _showErrorSnackbar(context, errorMessage);
    }
  }

  Future<void> _registerWithEmailPassword(BuildContext context) async {
    // Validate input
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      _showErrorSnackbar(context, 'Please enter both email and password');
      return;
    }

    if (_passwordController.text.trim().length < 6) {
      _showErrorSnackbar(context, 'Password must be at least 6 characters long');
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Dismiss loading dialog
      if (context.mounted) Navigator.of(context).pop();

      if (userCredential.user != null) {
        print('Registration successful: ${userCredential.user?.email}');
        // Success - user will be redirected by AuthWrapper automatically
        _showSuccessSnackbar(context, 'Account created successfully! Welcome to QRKEY!');
      }
    } catch (e) {
      // Dismiss loading dialog
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      String errorMessage = 'Registration failed';
      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'An account with this email already exists. Please sign in instead.';
      } else if (e.toString().contains('weak-password')) {
        errorMessage = 'Password is too weak. Please choose a stronger password.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Invalid email address format.';
      } else {
        errorMessage = 'Registration failed: ${e.toString()}';
      }

      print('Registration error: $e');
      _showErrorSnackbar(context, errorMessage);
    }
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
