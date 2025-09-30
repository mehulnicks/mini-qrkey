import 'package:flutter/material.dart';
import 'lib/core/config/supabase_config.dart';
import 'lib/core/services/supabase_minimal_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 Testing Supabase Connection...');
  
  try {
    // Initialize Supabase
    await SupabaseConfig.initialize();
    print('✅ Supabase initialized successfully');
    
    // Test connection
    final isConnected = await SupabaseMinimalService.testConnection();
    print('🔗 Connection test: ${isConnected ? "SUCCESS" : "FAILED"}');
    
    // Check current user
    final currentUser = SupabaseMinimalService.currentUser;
    print('👤 Current user: ${currentUser?.email ?? "Not authenticated"}');
    
    // Test server time
    final serverTime = await SupabaseMinimalService.getServerTime();
    print('⏰ Server time: $serverTime');
    
    print('✅ All Supabase tests completed!');
    
  } catch (e) {
    print('❌ Supabase test failed: $e');
  }
}
