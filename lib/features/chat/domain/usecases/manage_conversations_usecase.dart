import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/conversation_entity.dart';
import '../repositories/chat_repository.dart';

/// Use case for managing conversations.
class ManageConversationsUseCase {
  final ChatRepository repository;

  ManageConversationsUseCase(this.repository);

  /// Get all conversations.
  Future<Either<Failure, List<ConversationEntity>>> getAll() {
    return repository.getConversations();
  }

  /// Get a specific conversation.
  Future<Either<Failure, ConversationEntity>> get(String id) {
    return repository.getConversation(id);
  }

  /// Save a conversation.
  Future<Either<Failure, void>> save(ConversationEntity conversation) {
    return repository.saveConversation(conversation);
  }

  /// Delete a conversation.
  Future<Either<Failure, void>> delete(String id) {
    return repository.deleteConversation(id);
  }

  /// Clear all conversations.
  Future<Either<Failure, void>> clearAll() {
    return repository.clearAllConversations();
  }
}
