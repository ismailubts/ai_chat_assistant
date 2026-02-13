import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/settings_repository.dart';
import '../../domain/entities/settings_entity.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// BLoC for managing app settings.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc({required this.repository}) : super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateApiKeyEvent>(_onUpdateApiKey);
    on<UpdateModelEvent>(_onUpdateModel);
    on<UpdateSystemPromptEvent>(_onUpdateSystemPrompt);
    on<UpdateThemeModeEvent>(_onUpdateThemeMode);
    on<ClearApiKeyEvent>(_onClearApiKey);
  }

  void _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) {
    final settings = repository.loadSettings();
    emit(state.copyWith(settings: settings, status: SettingsStatus.loaded));
  }

  Future<void> _onUpdateApiKey(
    UpdateApiKeyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await repository.saveApiKey(event.apiKey);
    emit(
      state.copyWith(settings: state.settings.copyWith(apiKey: event.apiKey)),
    );
  }

  Future<void> _onUpdateModel(
    UpdateModelEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await repository.saveSelectedModel(event.model);
    emit(
      state.copyWith(
        settings: state.settings.copyWith(selectedModel: event.model),
      ),
    );
  }

  Future<void> _onUpdateSystemPrompt(
    UpdateSystemPromptEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await repository.saveSystemPrompt(event.prompt);
    emit(
      state.copyWith(
        settings: state.settings.copyWith(systemPrompt: event.prompt),
      ),
    );
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await repository.saveThemeMode(event.themeMode);
    emit(
      state.copyWith(
        settings: state.settings.copyWith(themeMode: event.themeMode),
      ),
    );
  }

  Future<void> _onClearApiKey(
    ClearApiKeyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await repository.clearApiKey();
    emit(state.copyWith(settings: state.settings.copyWith(apiKey: '')));
  }
}
