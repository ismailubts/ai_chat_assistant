part of 'settings_bloc.dart';

/// Status enum for settings operations.
enum SettingsStatus { initial, loading, loaded }

/// State for settings BLoC.
final class SettingsState extends Equatable {
  final SettingsStatus status;
  final SettingsEntity settings;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.settings = const SettingsEntity(),
  });

  /// Whether settings are loaded.
  bool get isLoaded => status == SettingsStatus.loaded;

  /// Whether API key is set.
  bool get hasApiKey => settings.hasApiKey;

  /// Current theme mode.
  ThemeMode get themeMode => settings.themeMode;

  SettingsState copyWith({SettingsStatus? status, SettingsEntity? settings}) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [status, settings];
}
