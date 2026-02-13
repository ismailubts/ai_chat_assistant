import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/settings_entity.dart';
import '../bloc/settings_bloc.dart';

/// Settings page for configuring the app.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiKeyController = TextEditingController();
  final _systemPromptController = TextEditingController();
  bool _obscureApiKey = true;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsBloc>().state.settings;
    _apiKeyController.text = settings.apiKey ?? '';
    _systemPromptController.text = settings.systemPrompt;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // API Key Section
              _buildSectionHeader(context, 'API Configuration'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _apiKeyController,
                        obscureText: _obscureApiKey,
                        decoration: InputDecoration(
                          labelText: AppStrings.apiKeyLabel,
                          hintText: 'sk-...',
                          prefixIcon: const Icon(Icons.key),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _obscureApiKey
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureApiKey = !_obscureApiKey;
                                  });
                                },
                              ),
                              if (_apiKeyController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _apiKeyController.clear();
                                    context.read<SettingsBloc>().add(
                                      const ClearApiKeyEvent(),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(
                            UpdateApiKeyEvent(value),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Your API key is stored locally and never shared.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Model Selection
              _buildSectionHeader(context, AppStrings.modelSelection),
              Card(
                child: Column(
                  children: AIModel.availableModels.map((model) {
                    return RadioListTile<String>(
                      title: Row(
                        children: [
                          Text(model.name),
                          if (model.isPremium) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.xs,
                                ),
                              ),
                              child: Text(
                                'Premium',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(model.description),
                      value: model.id,
                      groupValue: state.settings.selectedModel,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SettingsBloc>().add(
                            UpdateModelEvent(value),
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // System Prompt
              _buildSectionHeader(context, AppStrings.systemPrompt),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _systemPromptController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Customize how the AI responds...',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(
                            UpdateSystemPromptEvent(value),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton.icon(
                        onPressed: () {
                          _systemPromptController.text =
                              AppStrings.defaultSystemPrompt;
                          context.read<SettingsBloc>().add(
                            const UpdateSystemPromptEvent(
                              AppStrings.defaultSystemPrompt,
                            ),
                          );
                        },
                        icon: const Icon(Icons.restore, size: 18),
                        label: const Text('Reset to Default'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Appearance
              _buildSectionHeader(context, 'Appearance'),
              Card(
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text(AppStrings.systemMode),
                      subtitle: const Text('Follow system settings'),
                      value: ThemeMode.system,
                      groupValue: state.settings.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SettingsBloc>().add(
                            UpdateThemeModeEvent(value),
                          );
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text(AppStrings.lightMode),
                      value: ThemeMode.light,
                      groupValue: state.settings.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SettingsBloc>().add(
                            UpdateThemeModeEvent(value),
                          );
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text(AppStrings.darkMode),
                      value: ThemeMode.dark,
                      groupValue: state.settings.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SettingsBloc>().add(
                            UpdateThemeModeEvent(value),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // About
              _buildSectionHeader(context, 'About'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Version'),
                      trailing: Text(
                        AppStrings.appVersion,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: const Text('Built with Flutter'),
                      subtitle: const Text('Clean Architecture + BLoC'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
