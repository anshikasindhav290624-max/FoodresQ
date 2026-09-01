import 'package:flutter/material.dart';

enum UserRole { ngo, restaurant, vendor, kirana }

class AppColors {
  // Common Colors
  static const Color background = Color(0xFFF7F8F3);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF17201B);
  static const Color textSecondary = Color(0xFF66736B);
  static const Color border = Color(0xFFDDE5DF);
  
  // Accents & Signals
  static const Color aiAccent = Color(0xFF8B7CF6);
  static const Color warning = Color(0xFFF2A93B);
  static const Color critical = Color(0xFFE45757);
  static const Color success = Color(0xFF36A269);
  static const Color info = Color(0xFF3B82F6);

  // NGO Theme
  static const Color ngoPrimary = Color(0xFF126B68);
  static const Color ngoSecondary = Color(0xFFBFE8D4);
  static const Color ngoBg = Color(0xFFEEF8F3);

  // Restaurant Theme
  static const Color restaurantPrimary = Color(0xFFD96C4A);
  static const Color restaurantSecondary = Color(0xFFF4B39A);
  static const Color restaurantBg = Color(0xFFFFF8F1);

  // Vendor Theme
  static const Color vendorPrimary = Color(0xFF4F46A5);
  static const Color vendorSecondary = Color(0xFFC7D2FE);
  static const Color vendorBg = Color(0xFFF4F5FF);

  // Kirana Theme
  static const Color kiranaPrimary = Color(0xFF667A35);
  static const Color kiranaSecondary = Color(0xFFD8E4B8);
  static const Color kiranaBg = Color(0xFFF7F8ED);

  static Color getPrimaryForRole(UserRole role) {
    switch (role) {
      case UserRole.ngo:
        return ngoPrimary;
      case UserRole.restaurant:
        return restaurantPrimary;
      case UserRole.vendor:
        return vendorPrimary;
      case UserRole.kirana:
        return kiranaPrimary;
    }
  }

  static Color getSecondaryForRole(UserRole role) {
    switch (role) {
      case UserRole.ngo:
        return ngoSecondary;
      case UserRole.restaurant:
        return restaurantSecondary;
      case UserRole.vendor:
        return vendorSecondary;
      case UserRole.kirana:
        return kiranaSecondary;
    }
  }

  static Color getBgForRole(UserRole role) {
    switch (role) {
      case UserRole.ngo:
        return ngoBg;
      case UserRole.restaurant:
        return restaurantBg;
      case UserRole.vendor:
        return vendorBg;
      case UserRole.kirana:
        return kiranaBg;
    }
  }

  static String getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.ngo:
        return 'NGO';
      case UserRole.restaurant:
        return 'Restaurant';
      case UserRole.vendor:
        return 'Vendor';
      case UserRole.kirana:
        return 'Kirana Store';
    }
  }

  static String getRoleSubtitle(UserRole role) {
    switch (role) {
      case UserRole.ngo:
        return 'Rescue & distribute surplus food';
      case UserRole.restaurant:
        return 'Manage and recover surplus food';
      case UserRole.vendor:
        return 'Buy discounted near-expiry inventory';
      case UserRole.kirana:
        return 'Recover value from at-risk inventory';
    }
  }

  static String getRoleEmoji(UserRole role) {
    switch (role) {
      case UserRole.ngo:
        return '❤️';
      case UserRole.restaurant:
        return '🍽️';
      case UserRole.vendor:
        return '🛒';
      case UserRole.kirana:
        return '🏪';
    }
  }
}

class AppTheme {
  static ThemeData getThemeData(UserRole role) {
    final primaryColor = AppColors.getPrimaryForRole(role);
    final secondaryColor = AppColors.getSecondaryForRole(role);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: AppColors.card,
      ),
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 1.5,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: secondaryColor.withOpacity(0.3),
        labelStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primaryColor.withOpacity(0.2)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
