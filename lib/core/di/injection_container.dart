import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../services/storage_service.dart';
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/datasources/chat_local_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/send_message_usecase.dart';
import '../../features/chat/domain/usecases/manage_conversations_usecase.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../../features/settings/data/repositories/settings_repository.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initializes all dependencies for the application.
Future<void> initializeDependencies() async {
  // External Dependencies
  await _initExternalDependencies();

  // Core Services
  _initCoreServices();

  // Features
  _initChatFeature();
  _initSettingsFeature();
}

/// Initializes external dependencies like SharedPreferences.
Future<void> _initExternalDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

/// Initializes core services.
void _initCoreServices() {
  // Storage Service (initialize first as DioClient needs it)
  sl.registerLazySingleton<StorageService>(
    () => StorageService(sl<SharedPreferences>()),
  );

  // Network
  sl.registerLazySingleton<DioClient>(
    () => DioClient(storageService: sl<StorageService>()),
  );
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo());
}

/// Initializes Chat feature dependencies.
void _initChatFeature() {
  // Data Sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(storageService: sl<StorageService>()),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl<ChatRemoteDataSource>(),
      localDataSource: sl<ChatLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
      storageService: sl<StorageService>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SendMessageUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton(
    () => ManageConversationsUseCase(sl<ChatRepository>()),
  );

  // Bloc
  sl.registerFactory(
    () => ChatBloc(
      sendMessageUseCase: sl<SendMessageUseCase>(),
      manageConversationsUseCase: sl<ManageConversationsUseCase>(),
    ),
  );
}

/// Initializes Settings feature dependencies.
void _initSettingsFeature() {
  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepository(storageService: sl<StorageService>()),
  );

  // Bloc
  sl.registerFactory(() => SettingsBloc(repository: sl<SettingsRepository>()));
}

/// Resets all dependencies (useful for testing).
Future<void> resetDependencies() async {
  await sl.reset();
}
