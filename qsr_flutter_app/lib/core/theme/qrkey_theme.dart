import 'package:flutter/material.dart';

/// QRKEY App Theme Configuration
/// 
/// This file contains the centralized theme configuration for the QRKEY app
/// to ensure consistent color scheme with saffron theme.
class QRKeyTheme {
  // Brand Colors - Saffron Theme
  static const Color primarySaffron = Color(0xFFFF9933); // Main app primary saffron
  static const Color darkerSaffron = Color(0xFFE65100); // Darker saffron for gradients
  static const Color lightSaffron = Color(0xFFFFCC80); // Lighter saffron for backgrounds
  static const Color blackAccent = Color(0xFF212121); // Black accent
  static const Color greyBackground = Color(0xFFFAFAFA); // Light grey background
  
  // Status Colors 
  static const Color statusPending = Color(0xFFFFA726); // Orange for pending
  static const Color statusPreparing = Color(0xFF2196F3); // Blue for preparing
  static const Color statusReady = Color(0xFF4CAF50); // Green for ready
  static const Color statusCompleted = Color(0xFF9E9E9E); // Grey for completed
  static const Color statusCancelled = Color(0xFFF44336); // Red for cancelled
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primarySaffron, darkerSaffron],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [primarySaffron, lightSaffron],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Main Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySaffron,
        brightness: Brightness.light,
        primary: primarySaffron,
        secondary: blackAccent,
        surface: Colors.white,
        background: greyBackground,
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: primarySaffron,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.15,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: const Color(0x1F000000),
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          shadowColor: const Color(0x3DFF9933),
          backgroundColor: primarySaffron,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primarySaffron,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primarySaffron,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primarySaffron, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: blackAccent,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: blackAccent,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: blackAccent,
          letterSpacing: 0.15,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: blackAccent,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: blackAccent,
          letterSpacing: 0.15,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: blackAccent,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: blackAccent,
          letterSpacing: 0.25,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: blackAccent,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
  
  /// Helper Methods
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return statusPending;
      case 'preparing':
        return statusPreparing;
      case 'ready':
        return statusReady;
      case 'completed':
        return statusCompleted;
      case 'cancelled':
        return statusCancelled;
      default:
        return statusCompleted;
    }
  }
  
  static Color getPrimaryAccentColor(double opacity) {
    return primarySaffron.withOpacity(opacity);
  }
  
  static BoxDecoration getPrimaryGradientDecoration({
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: primaryGradient,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
    );
  }
}
