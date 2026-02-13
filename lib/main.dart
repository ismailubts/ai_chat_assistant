import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/api_constants.dart';
import 'core/di/injection_container.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/dark_theme.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/pages/chat_page.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const AIChatApp());
}

/// Main application widget.
class AIChatApp extends StatelessWidget {
  const AIChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (_) => sl<SettingsBloc>()..add(const LoadSettingsEvent()),
        ),
        BlocProvider<ChatBloc>(create: (_) => sl<ChatBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settingsState.themeMode,

            // Routes
            initialRoute: '/',
            routes: {
              '/': (context) => const ChatPage(),
              '/settings': (context) => const SettingsPage(),
            },
          );
        },
      ),
    );
  }
}
