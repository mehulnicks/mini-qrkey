import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // TODO: Replace these with your actual Supabase URL and anon key
  // You can get these from your Supabase project dashboard
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true, // Set to false in production
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
  
  // Helper to get current user
  static User? get currentUser => client.auth.currentUser;
  
  // Helper to check if user is authenticated
  static bool get isAuthenticated => currentUser != null;
  
  // Helper to get user ID
  static String? get currentUserId => currentUser?.id;
}
