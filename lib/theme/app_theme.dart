import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4A42D6);
  static const Color accentColor = Color(0xFF00D4FF);
  static const Color successColor = Color(0xFF00E676);
  static const Color warningColor = Color(0xFFFFAB00);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color infoColor = Color(0xFF448AFF);

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF141828);
  static const Color darkCard = Color(0xFF1C2136);
  static const Color darkCardHover = Color(0xFF232943);
  static const Color darkBorder = Color(0xFF2A3150);
  static const Color darkText = Color(0xFFE8EAF6);
  static const Color darkTextMuted = Color(0xFF8892B0);

  // Light Theme Colors
  static const Color lightBg = Color(0xFFF0F2FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE0E7FF);
  static const Color lightText = Color(0xFF1A1F36);
  static const Color lightTextMuted = Color(0xFF6B7280);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFAB00), Color(0xFFFF6D00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF9C27B0), Color(0xFF6C63FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: darkSurface,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: darkText,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w700, color: darkText,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 24, fontWeight: FontWeight.w600, color: darkText,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.w600, color: darkText,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: darkText,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, color: darkText,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500, color: darkText,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, color: darkText,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w400, color: darkTextMuted,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w500, color: primaryColor,
        ),
      ),
      cardTheme: CardTheme(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: darkText,
        ),
        iconTheme: const IconThemeData(color: darkText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: darkTextMuted),
        hintStyle: GoogleFonts.inter(color: darkTextMuted),
        prefixIconColor: darkTextMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerColor: darkBorder,
      iconTheme: const IconThemeData(color: darkTextMuted),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: lightSurface,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: lightText,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w700, color: lightText,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: lightText,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, color: lightText,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w400, color: lightTextMuted,
        ),
      ),
      cardTheme: CardTheme(
        color: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600, color: lightText,
        ),
        iconTheme: const IconThemeData(color: lightText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerColor: lightBorder,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
