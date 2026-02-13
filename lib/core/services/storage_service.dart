import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';

/// Service for local data persistence using SharedPreferences.
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // String operations
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  // Int operations
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  // Bool operations
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  // Double operations
  Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);
  double? getDouble(String key) => _prefs.getDouble(key);

  // StringList operations
  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // Remove & Clear
  Future<bool> remove(String key) => _prefs.remove(key);
  Future<bool> clear() => _prefs.clear();

  // Check if key exists
  bool containsKey(String key) => _prefs.containsKey(key);

  // API Key Management
  Future<bool> saveApiKey(String apiKey) =>
      setString(StorageKeys.apiKey, apiKey);

  String? getApiKey() => getString(StorageKeys.apiKey);

  Future<bool> removeApiKey() => remove(StorageKeys.apiKey);

  // Theme Mode
  Future<bool> saveThemeMode(String mode) =>
      setString(StorageKeys.themeMode, mode);

  String? getThemeMode() => getString(StorageKeys.themeMode);

  // Selected Model
  Future<bool> saveSelectedModel(String model) =>
      setString(StorageKeys.selectedModel, model);

  String? getSelectedModel() => getString(StorageKeys.selectedModel);

  // System Prompt
  Future<bool> saveSystemPrompt(String prompt) =>
      setString(StorageKeys.systemPrompt, prompt);

  String? getSystemPrompt() => getString(StorageKeys.systemPrompt);

  // Conversations (JSON encoded)
  Future<bool> saveConversations(String conversationsJson) =>
      setString(StorageKeys.conversations, conversationsJson);

  String? getConversations() => getString(StorageKeys.conversations);
}
