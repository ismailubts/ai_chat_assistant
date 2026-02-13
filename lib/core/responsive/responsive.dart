import 'package:flutter/material.dart';

/// Responsive utility class for building adaptive UIs.
/// Provides screen size detection, breakpoints, and scaling functions.
class Responsive {
  const Responsive._();

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Reference screen width for scaling (iPhone 14 Pro)
  static const double referenceWidth = 393;
  static const double referenceHeight = 852;

  /// Returns true if the device is a mobile phone.
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mobileBreakpoint;
  }

  /// Returns true if the device is a tablet.
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Returns true if the device is a desktop.
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= desktopBreakpoint;
  }

  /// Returns the current screen width.
  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// Returns the current screen height.
  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  /// Scales a dimension value based on screen width.
  static double scaleWidth(BuildContext context, double size) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return size * (screenWidth / referenceWidth);
  }

  /// Scales a dimension value based on screen height.
  static double scaleHeight(BuildContext context, double size) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return size * (screenHeight / referenceHeight);
  }

  /// Scales a font size with minimum and maximum constraints.
  static double scaleFontSize(
    BuildContext context,
    double size, {
    double? min,
    double? max,
  }) {
    final scaled = scaleWidth(context, size);
    if (min != null && scaled < min) return min;
    if (max != null && scaled > max) return max;
    return scaled;
  }

  /// Returns horizontal padding based on device type.
  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 48;
    if (isTablet(context)) return 32;
    return 20;
  }

  /// Returns vertical padding based on device type.
  static double verticalPadding(BuildContext context) {
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 28;
    return 24;
  }

  /// Returns number of columns for grid layouts.
  static int gridColumns(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }

  /// Returns the aspect ratio for cards based on device type.
  static double cardAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 1.2;
    if (isTablet(context)) return 1.1;
    return 1.0;
  }

  /// Returns adaptive value based on screen size.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  /// Returns the safe area padding.
  static EdgeInsets safePadding(BuildContext context) {
    return MediaQuery.paddingOf(context);
  }

  /// Returns the keyboard height if visible.
  static double keyboardHeight(BuildContext context) {
    return MediaQuery.viewInsetsOf(context).bottom;
  }

  /// Returns true if the keyboard is visible.
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.viewInsetsOf(context).bottom > 0;
  }

  /// Returns the device pixel ratio.
  static double devicePixelRatio(BuildContext context) {
    return MediaQuery.devicePixelRatioOf(context);
  }

  /// Returns the text scale factor.
  static double textScaleFactor(BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(1.0);
  }

  /// Returns the orientation of the device.
  static Orientation orientation(BuildContext context) {
    return MediaQuery.orientationOf(context);
  }

  /// Returns true if the device is in landscape mode.
  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }
}

/// Extension on BuildContext for easier access to responsive utilities.
extension ResponsiveExtension on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);
  double get screenWidth => Responsive.screenWidth(this);
  double get screenHeight => Responsive.screenHeight(this);
  double get horizontalPadding => Responsive.horizontalPadding(this);
  double get verticalPadding => Responsive.verticalPadding(this);
  bool get isKeyboardVisible => Responsive.isKeyboardVisible(this);
  Orientation get orientation => Responsive.orientation(this);
}
