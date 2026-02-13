/// Application spacing constants.
/// Ensures consistent spacing throughout the app.
class AppSpacing {
  const AppSpacing._();

  // Base spacing unit
  static const double unit = 4.0;

  // Standard spacing values
  static const double xxxs = 2.0;
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Component-specific spacing
  static const double cardPadding = 16.0;
  static const double cardMargin = 12.0;
  static const double listItemSpacing = 12.0;
  static const double sectionSpacing = 24.0;
  static const double pageHorizontalPadding = 20.0;
  static const double pageVerticalPadding = 24.0;

  // Button spacing
  static const double buttonPaddingHorizontal = 24.0;
  static const double buttonPaddingVertical = 14.0;
  static const double buttonSpacing = 12.0;

  // Input field spacing
  static const double inputPaddingHorizontal = 16.0;
  static const double inputPaddingVertical = 14.0;

  // Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Avatar sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 96.0;

  // Voice card specific
  static const double voiceCardHeight = 80.0;
  static const double voiceCardIconSize = 48.0;

  // Audio waveform
  static const double waveformHeight = 60.0;
  static const double waveformBarWidth = 3.0;
  static const double waveformBarSpacing = 2.0;

  // Bottom navigation
  static const double bottomNavHeight = 80.0;
  static const double bottomNavIconSize = 24.0;
}

/// Application border radius constants.
class AppRadius {
  const AppRadius._();

  // Standard radius values
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 999.0;

  // Component-specific radius
  static const double card = 16.0;
  static const double button = 12.0;
  static const double message = 16.0;
  static const double pill = 24.0;
  static const double buttonSmall = 8.0;
  static const double input = 12.0;
  static const double chip = 20.0;
  static const double bottomSheet = 24.0;
  static const double dialog = 24.0;
  static const double avatar = 999.0;

  // Voice card specific
  static const double voiceCard = 16.0;
  static const double voiceIcon = 12.0;
}

/// Application elevation constants.
class AppElevation {
  const AppElevation._();

  static const double none = 0.0;
  static const double xs = 1.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 16.0;
}

/// Application animation duration constants.
class AppDurations {
  const AppDurations._();

  static const Duration instant = Duration.zero;
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 700);
  static const Duration slowest = Duration(milliseconds: 1000);

  // Specific animation durations
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration modalTransition = Duration(milliseconds: 250);
  static const Duration ripple = Duration(milliseconds: 200);
  static const Duration waveform = Duration(milliseconds: 50);
}
