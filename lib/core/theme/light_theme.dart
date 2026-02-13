import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Light theme configuration for the application.
ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryLight,
    tertiary: AppColors.accent,
    tertiaryContainer: AppColors.accentLight,
    surface: AppColors.surfaceLight,
    error: AppColors.error,
    errorContainer: AppColors.errorLight,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: Colors.white,
    onSurface: AppColors.textPrimaryLight,
    onError: Colors.white,
    outline: AppColors.borderLight,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.backgroundLight,
    foregroundColor: AppColors.textPrimaryLight,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimaryLight,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: AppElevation.sm,
    color: AppColors.cardLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.card),
    ),
    margin: const EdgeInsets.all(AppSpacing.xs),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.buttonPaddingHorizontal,
        vertical: AppSpacing.buttonPaddingVertical,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.buttonPaddingHorizontal,
        vertical: AppSpacing.buttonPaddingVertical,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      side: const BorderSide(color: AppColors.primary),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceLight,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.inputPaddingHorizontal,
      vertical: AppSpacing.inputPaddingVertical,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.borderLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.borderLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    hintStyle: const TextStyle(
      color: AppColors.textTertiaryLight,
      fontSize: 14,
    ),
    labelStyle: const TextStyle(
      color: AppColors.textSecondaryLight,
      fontSize: 14,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surfaceLight,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textTertiaryLight,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.surfaceLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.bottomSheet),
      ),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.surfaceLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.dialog),
    ),
    elevation: AppElevation.lg,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.textPrimaryLight,
    contentTextStyle: const TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surfaceLight,
    selectedColor: AppColors.primaryLight,
    disabledColor: AppColors.dividerLight,
    labelStyle: const TextStyle(
      color: AppColors.textPrimaryLight,
      fontSize: 12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.chip),
      side: const BorderSide(color: AppColors.borderLight),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.dividerLight,
    thickness: 1,
    space: 1,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.dividerLight,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.dividerLight,
    thumbColor: AppColors.primary,
    overlayColor: AppColors.primary.withValues(alpha: 0.2),
    trackHeight: 4,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.textTertiaryLight;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryLight;
      }
      return AppColors.dividerLight;
    }),
  ),
);
