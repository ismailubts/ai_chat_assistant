import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Application typography styles.
/// Uses system fonts for consistent cross-platform rendering.
class AppTextStyles {
  const AppTextStyles._();

  // Display Styles
  static TextStyle displayLarge({Color? color}) => TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle displayMedium({Color? color}) => TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle displaySmall({Color? color}) => TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
    color: color ?? AppColors.textPrimaryLight,
  );

  // Headline Styles
  static TextStyle headlineLarge({Color? color}) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle headlineMedium({Color? color}) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle headlineSmall({Color? color}) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: color ?? AppColors.textPrimaryLight,
  );

  // Title Styles
  static TextStyle titleLarge({Color? color}) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle titleMedium({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle titleSmall({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: color ?? AppColors.textPrimaryLight,
  );

  // Body Styles
  static TextStyle bodyLarge({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle bodyMedium({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle bodySmall({Color? color}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: color ?? AppColors.textSecondaryLight,
  );

  // Label Styles
  static TextStyle labelLarge({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle labelMedium({Color? color}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle labelSmall({Color? color}) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: color ?? AppColors.textSecondaryLight,
  );

  // Button Text Style
  static TextStyle button({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.43,
    color: color ?? Colors.white,
  );

  // Caption Style
  static TextStyle caption({Color? color}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: color ?? AppColors.textTertiaryLight,
  );

  // Overline Style
  static TextStyle overline({Color? color}) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.6,
    color: color ?? AppColors.textTertiaryLight,
  );
}
