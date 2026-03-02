import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:{{project_name}}/core/presentation/theme/app_colors.dart';

class AppTextStyles {
  static TextTheme getMainTextTheme() {
    return TextTheme(
      // Display
      displayLarge: GoogleFonts.poppins(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        height: 1.12, // 64px
        letterSpacing: -0.25,
        color: AppColors.onSurface,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.16, // 52px
        letterSpacing: 0,
        color: AppColors.onSurface,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22, // 44px
        letterSpacing: 0,
        color: AppColors.onSurface,
      ),

      // Headline
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        height: 1.25, // 40px
        letterSpacing: 0,
        color: AppColors.onSurface,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.29, // 36px
        letterSpacing: 0,
        color: AppColors.onSurface,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.33, // 32px
        letterSpacing: 0,
        color: AppColors.onSurface,
      ),

      // Title
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        height: 1.27, // 28px
        letterSpacing: 0,
        color: AppColors.onSurface,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5, // 24px
        letterSpacing: 0.15,
        color: AppColors.onSurface,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43, // 20px
        letterSpacing: 0.1,
        color: AppColors.onSurface,
      ),

      // Label
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43, // 20px
        letterSpacing: 0.1,
        color: AppColors.onSurface,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33, // 16px
        letterSpacing: 0.5,
        color: AppColors.onSurface,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45, // 16px
        letterSpacing: 0.5,
        color: AppColors.onSurface,
      ),

      // Body
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5, // 24px
        letterSpacing: 0.5,
        color: AppColors.onSurface,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43, // 20px
        letterSpacing: 0.25,
        color: AppColors.onSurface,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33, // 16px
        letterSpacing: 0.4,
        color: AppColors.onSurface,
      ),
    );
  }
}
