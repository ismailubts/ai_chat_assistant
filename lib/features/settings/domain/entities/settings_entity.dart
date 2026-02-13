import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entity representing app settings.
class SettingsEntity extends Equatable {
  final String? apiKey;
  final String selectedModel;
  final String systemPrompt;
  final ThemeMode themeMode;

  const SettingsEntity({
    this.apiKey,
    this.selectedModel = 'gpt-3.5-turbo',
    this.systemPrompt =
        'You are a helpful AI assistant. Be concise, accurate, and friendly.',
    this.themeMode = ThemeMode.system,
  });

  /// Whether API key is configured.
  bool get hasApiKey => apiKey != null && apiKey!.isNotEmpty;

  /// Whether settings are valid for chat.
  bool get isValid => hasApiKey;

  SettingsEntity copyWith({
    String? apiKey,
    String? selectedModel,
    String? systemPrompt,
    ThemeMode? themeMode,
  }) {
    return SettingsEntity(
      apiKey: apiKey ?? this.apiKey,
      selectedModel: selectedModel ?? this.selectedModel,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [apiKey, selectedModel, systemPrompt, themeMode];
}

/// Available AI models.
class AIModel {
  final String id;
  final String name;
  final String description;
  final bool isPremium;

  const AIModel({
    required this.id,
    required this.name,
    required this.description,
    this.isPremium = false,
  });

  static const List<AIModel> availableModels = [
    AIModel(
      id: 'gpt-3.5-turbo',
      name: 'GPT-3.5 Turbo',
      description: 'Fast and efficient for most tasks',
    ),
    AIModel(
      id: 'gpt-4',
      name: 'GPT-4',
      description: 'Most capable model for complex tasks',
      isPremium: true,
    ),
    AIModel(
      id: 'gpt-4-turbo-preview',
      name: 'GPT-4 Turbo',
      description: 'Latest GPT-4 with improved speed',
      isPremium: true,
    ),
  ];

  static AIModel fromId(String id) {
    return availableModels.firstWhere(
      (m) => m.id == id,
      orElse: () => availableModels.first,
    );
  }
}
