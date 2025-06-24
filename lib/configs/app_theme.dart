import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF4F46E5);
  static const Color secondaryBlue = Color(0xFF6366F1);
  static const Color successGreen = Color(0xFF10B981);
  static const Color neutralGray = Color(0xFF6B7280);
  static const Color lightGray = Color(0xFFF9FAFB);
  static const Color darkGray = Color(0xFF111827);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: lightGray,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.light(primary: primaryBlue, secondary: successGreen),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: BorderSide(color: primaryBlue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    // cardTheme: CardTheme(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   elevation: 4,
    // ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: neutralGray.withOpacity(0.3))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryBlue)),
    ),
  );
}