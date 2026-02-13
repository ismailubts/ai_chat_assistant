import 'package:dartz/dartz.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

/// Implementation of chat repository.
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final StorageService storageService;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.storageService,
  });

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String message,
    required List<MessageEntity> conversationHistory,
  }) async {
    // Check API key
    final apiKey = storageService.getString(StorageKeys.apiKey);
    if (apiKey == null || apiKey.isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Please set your OpenAI API key in settings',
        ),
      );
    }

    // Check network
    if (!await networkInfo.isConnected) {
      return Left(
        NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ),
      );
    }

    try {
      // Get system prompt
      final systemPrompt =
          storageService.getString(StorageKeys.systemPrompt) ??
          AppStrings.defaultSystemPrompt;

      // Build messages array
      final messages = <Map<String, dynamic>>[
        {'role': 'system', 'content': systemPrompt},
        ...conversationHistory.map(
          (m) => MessageModel.fromEntity(m).toOpenAIFormat(),
        ),
        {'role': 'user', 'content': message},
      ];

      // Get selected model
      final model =
          storageService.getString(StorageKeys.selectedModel) ??
          ApiConstants.defaultModel;

      final response = await remoteDataSource.sendMessage(
        messages: messages,
        model: model,
      );

      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Stream<Either<Failure, String>> sendMessageStream({
    required String conversationId,
    required String message,
    required List<MessageEntity> conversationHistory,
  }) async* {
    // Check API key
    final apiKey = storageService.getString(StorageKeys.apiKey);
    if (apiKey == null || apiKey.isEmpty) {
      yield Left(
        ValidationFailure(
          message: 'Please set your OpenAI API key in settings',
        ),
      );
      return;
    }

    // Check network
    if (!await networkInfo.isConnected) {
      yield Left(
        NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ),
      );
      return;
    }

    try {
      final systemPrompt =
          storageService.getString(StorageKeys.systemPrompt) ??
          AppStrings.defaultSystemPrompt;

      final messages = <Map<String, dynamic>>[
        {'role': 'system', 'content': systemPrompt},
        ...conversationHistory.map(
          (m) => MessageModel.fromEntity(m).toOpenAIFormat(),
        ),
        {'role': 'user', 'content': message},
      ];

      final model =
          storageService.getString(StorageKeys.selectedModel) ??
          ApiConstants.defaultModel;

      await for (final chunk in remoteDataSource.sendMessageStream(
        messages: messages,
        model: model,
      )) {
        yield Right(chunk);
      }
    } catch (e) {
      yield Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final conversations = await localDataSource.getConversations();
      return Right(conversations);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to load conversations'));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> getConversation(String id) async {
    try {
      final conversation = await localDataSource.getConversation(id);
      if (conversation == null) {
        return Left(CacheFailure(message: 'Conversation not found'));
      }
      return Right(conversation);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to load conversation'));
    }
  }

  @override
  Future<Either<Failure, void>> saveConversation(
    ConversationEntity conversation,
  ) async {
    try {
      await localDataSource.saveConversation(
        ConversationModel.fromEntity(conversation),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save conversation'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(String id) async {
    try {
      await localDataSource.deleteConversation(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete conversation'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllConversations() async {
    try {
      await localDataSource.clearAllConversations();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to clear conversations'));
    }
  }
}
