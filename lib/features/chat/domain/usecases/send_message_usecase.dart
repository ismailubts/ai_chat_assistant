import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

/// Use case for sending a message and getting AI response.
class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  /// Send message and get response.
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) {
    if (params.message.trim().isEmpty) {
      return Future.value(
        Left(ValidationFailure(message: 'Message cannot be empty')),
      );
    }

    return repository.sendMessage(
      conversationId: params.conversationId,
      message: params.message,
      conversationHistory: params.conversationHistory,
    );
  }

  /// Send message with streaming response.
  Stream<Either<Failure, String>> stream(SendMessageParams params) {
    if (params.message.trim().isEmpty) {
      return Stream.value(
        Left(ValidationFailure(message: 'Message cannot be empty')),
      );
    }

    return repository.sendMessageStream(
      conversationId: params.conversationId,
      message: params.message,
      conversationHistory: params.conversationHistory,
    );
  }
}

/// Parameters for sending a message.
class SendMessageParams {
  final String conversationId;
  final String message;
  final List<MessageEntity> conversationHistory;

  const SendMessageParams({
    required this.conversationId,
    required this.message,
    required this.conversationHistory,
  });
}
