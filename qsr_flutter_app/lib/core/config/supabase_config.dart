import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Replace these with your actual Supabase project credentials
  static const String url = 'https://eftnhqazcdejdauaxfyx.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVmdG5ocWF6Y2RlamRhdWF4Znl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkyMTI3ODgsImV4cCI6MjA3NDc4ODc4OH0.VxtPb5XUFL7VOtSHSaW7wU-R65NkPKj9XkSnqgaBwHs';
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: true, // Set to false in production
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
