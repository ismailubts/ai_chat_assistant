import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/conversation_entity.dart';
import '../entities/message_entity.dart';

/// Repository contract for chat operations.
abstract class ChatRepository {
  /// Send a message and get AI response.
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String message,
    required List<MessageEntity> conversationHistory,
  });

  /// Send message with streaming response.
  Stream<Either<Failure, String>> sendMessageStream({
    required String conversationId,
    required String message,
    required List<MessageEntity> conversationHistory,
  });

  /// Get all conversations.
  Future<Either<Failure, List<ConversationEntity>>> getConversations();

  /// Get a specific conversation.
  Future<Either<Failure, ConversationEntity>> getConversation(String id);

  /// Save conversation.
  Future<Either<Failure, void>> saveConversation(
    ConversationEntity conversation,
  );

  /// Delete conversation.
  Future<Either<Failure, void>> deleteConversation(String id);

  /// Clear all conversations.
  Future<Either<Failure, void>> clearAllConversations();
}
