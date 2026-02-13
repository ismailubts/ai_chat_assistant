import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Dark theme configuration for the application.
ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryDark,
    tertiary: AppColors.accent,
    tertiaryContainer: AppColors.accentDark,
    surface: AppColors.surfaceDark,
    error: AppColors.error,
    errorContainer: AppColors.errorDark,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: Colors.white,
    onSurface: AppColors.textPrimaryDark,
    onError: Colors.white,
    outline: AppColors.borderDark,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.backgroundDark,
    foregroundColor: AppColors.textPrimaryDark,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimaryDark,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: AppElevation.sm,
    color: AppColors.cardDark,
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
      foregroundColor: AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.buttonPaddingHorizontal,
        vertical: AppSpacing.buttonPaddingVertical,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      side: const BorderSide(color: AppColors.primaryLight),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceDark,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.inputPaddingHorizontal,
      vertical: AppSpacing.inputPaddingVertical,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: const BorderSide(color: AppColors.borderDark),
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
    hintStyle: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 14),
    labelStyle: const TextStyle(
      color: AppColors.textSecondaryDark,
      fontSize: 14,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surfaceDark,
    selectedItemColor: AppColors.primaryLight,
    unselectedItemColor: AppColors.textTertiaryDark,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.surfaceDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.bottomSheet),
      ),
    ),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.surfaceDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.dialog),
    ),
    elevation: AppElevation.lg,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.cardDark,
    contentTextStyle: const TextStyle(color: AppColors.textPrimaryDark),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surfaceDark,
    selectedColor: AppColors.primaryDark,
    disabledColor: AppColors.dividerDark,
    labelStyle: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.chip),
      side: const BorderSide(color: AppColors.borderDark),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.dividerDark,
    thickness: 1,
    space: 1,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.dividerDark,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.dividerDark,
    thumbColor: AppColors.primary,
    overlayColor: AppColors.primary.withValues(alpha: 0.2),
    trackHeight: 4,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primaryLight;
      }
      return AppColors.textTertiaryDark;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.dividerDark;
    }),
  ),
);
