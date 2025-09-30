import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseMinimalService {
  static SupabaseClient get _client => SupabaseConfig.client;
  
  // Test connection
  static Future<bool> testConnection() async {
    try {
      // Simple test to check if Supabase is reachable
      final session = _client.auth.currentSession;
      return true;
    } catch (e) {
      print('Supabase connection test failed: $e');
      return false;
    }
  }
  
  // Authentication methods
  static Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  static Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  static User? get currentUser => _client.auth.currentUser;
  
  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  // Simple test query that doesn't require specific tables
  static Future<String> getServerTime() async {
    try {
      final response = await _client
          .rpc('select_now');
      return response.toString();
    } catch (e) {
      return 'Server time unavailable: $e';
    }
  }
}
