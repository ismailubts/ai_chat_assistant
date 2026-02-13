part of 'settings_bloc.dart';

/// Base event for settings BLoC.
sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load settings.
final class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

/// Event to update API key.
final class UpdateApiKeyEvent extends SettingsEvent {
  final String apiKey;

  const UpdateApiKeyEvent(this.apiKey);

  @override
  List<Object> get props => [apiKey];
}

/// Event to update selected model.
final class UpdateModelEvent extends SettingsEvent {
  final String model;

  const UpdateModelEvent(this.model);

  @override
  List<Object> get props => [model];
}

/// Event to update system prompt.
final class UpdateSystemPromptEvent extends SettingsEvent {
  final String prompt;

  const UpdateSystemPromptEvent(this.prompt);

  @override
  List<Object> get props => [prompt];
}

/// Event to update theme mode.
final class UpdateThemeModeEvent extends SettingsEvent {
  final ThemeMode themeMode;

  const UpdateThemeModeEvent(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

/// Event to clear API key.
final class ClearApiKeyEvent extends SettingsEvent {
  const ClearApiKeyEvent();
}
