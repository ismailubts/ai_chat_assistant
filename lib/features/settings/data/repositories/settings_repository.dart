import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/settings_entity.dart';

/// Repository for managing app settings.
class SettingsRepository {
  final StorageService storageService;

  SettingsRepository({required this.storageService});

  /// Load settings from storage.
  SettingsEntity loadSettings() {
    final apiKey = storageService.getString(StorageKeys.apiKey);
    final selectedModel =
        storageService.getString(StorageKeys.selectedModel) ??
        ApiConstants.defaultModel;
    final systemPrompt =
        storageService.getString(StorageKeys.systemPrompt) ??
        AppStrings.defaultSystemPrompt;
    final themeModeString = storageService.getString(StorageKeys.themeMode);

    ThemeMode themeMode;
    switch (themeModeString) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return SettingsEntity(
      apiKey: apiKey,
      selectedModel: selectedModel,
      systemPrompt: systemPrompt,
      themeMode: themeMode,
    );
  }

  /// Save API key.
  Future<void> saveApiKey(String apiKey) async {
    await storageService.setString(StorageKeys.apiKey, apiKey);
  }

  /// Save selected model.
  Future<void> saveSelectedModel(String model) async {
    await storageService.setString(StorageKeys.selectedModel, model);
  }

  /// Save system prompt.
  Future<void> saveSystemPrompt(String prompt) async {
    await storageService.setString(StorageKeys.systemPrompt, prompt);
  }

  /// Save theme mode.
  Future<void> saveThemeMode(ThemeMode mode) async {
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      default:
        modeString = 'system';
    }
    await storageService.setString(StorageKeys.themeMode, modeString);
  }

  /// Clear API key.
  Future<void> clearApiKey() async {
    await storageService.remove(StorageKeys.apiKey);
  }
}
