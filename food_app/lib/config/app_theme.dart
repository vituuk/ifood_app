import 'package:flutter/material.dart';

// Centralized color constants
class AppColors {
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color backgroundColor = Colors.white;
  static const Color cardBackground = Colors.white;
  
  // All text colors now use primaryBlue
  static const Color textPrimary = primaryBlue;
  static const Color textSecondary = primaryBlue;
  static const Color textHint = primaryBlue;
  static const Color textOnPrimary = Colors.white; // For text on colored backgrounds
}

// Centralized text styles
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle subheading = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle body = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
  );
  
  static const TextStyle bodySmall = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12,
  );
  
  static const TextStyle caption = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 11,
  );
  
  static const TextStyle button = TextStyle(
    color: AppColors.textOnPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
