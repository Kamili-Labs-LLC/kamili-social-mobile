import 'package:flutter/material.dart';

class KamiliColors {
  KamiliColors._();

  // Primary
  static const Color primary = Color(0xFF2088C6);
  static const Color primaryDark = Color(0xFF1A6FA3);
  static const Color primaryLight = Color(0xFF5BADD6);

  // CTA / Destructive
  static const Color ctaRed = Color(0xFFE03035);
  static const Color ctaRedDark = Color(0xFFC02833);

  // Backgrounds
  static const Color background = Color(0xFFFAFBFC);
  static const Color panel = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFF0F2F5);

  // Text
  static const Color textPrimary = Color(0xFF1D2327);
  static const Color textSecondary = Color(0xFF6B7280);

  // Borders
  static const Color border = Color(0xFFD1D5DB);
  static const Color borderLight = Color(0xFFE5E7EB);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Platform colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color instagram = Color(0xFFE4405F);
  static const Color twitter = Color(0xFF000000);
  static const Color linkedin = Color(0xFF0A66C2);
  static const Color pinterest = Color(0xFFE60023);
  static const Color tiktok = Color(0xFF000000);
  static const Color youtube = Color(0xFFFF0000);
  static const Color threads = Color(0xFF000000);

  static Color platformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return facebook;
      case 'instagram':
        return instagram;
      case 'twitter':
        return twitter;
      case 'linkedin':
        return linkedin;
      case 'pinterest':
        return pinterest;
      case 'tiktok':
        return tiktok;
      case 'youtube':
        return youtube;
      case 'threads':
        return threads;
      default:
        return primary;
    }
  }
}

class KamiliTheme {
  KamiliTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: KamiliColors.primary,
      primary: KamiliColors.primary,
      onPrimary: Colors.white,
      secondary: KamiliColors.primaryLight,
      error: KamiliColors.error,
      surface: Colors.white,
      onSurface: KamiliColors.textPrimary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: KamiliColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: KamiliColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black12,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: KamiliColors.borderLight),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KamiliColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: KamiliColors.primary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(color: KamiliColors.primary),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: KamiliColors.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KamiliColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KamiliColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KamiliColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: KamiliColors.error),
        ),
        floatingLabelStyle: const TextStyle(color: KamiliColors.primary),
        labelStyle: const TextStyle(color: KamiliColors.textSecondary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: KamiliColors.primary,
        unselectedItemColor: KamiliColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: KamiliColors.panel,
        selectedColor: KamiliColors.primary.withValues(alpha: 0.1),
        labelStyle: const TextStyle(fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: KamiliColors.borderLight,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
