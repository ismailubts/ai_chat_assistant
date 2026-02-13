import '../../domain/entities/message_entity.dart';

/// Model for message data transfer.
class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.content,
    required super.role,
    required super.timestamp,
    super.status,
    super.error,
  });

  /// Create from entity.
  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      content: entity.content,
      role: entity.role,
      timestamp: entity.timestamp,
      status: entity.status,
      error: entity.error,
    );
  }

  /// Create from JSON (API response).
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['content'] ?? '',
      role: MessageRole.fromString(json['role'] ?? 'assistant'),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      status: MessageStatus.sent,
    );
  }

  /// Create from OpenAI API response.
  factory MessageModel.fromOpenAIResponse(Map<String, dynamic> json) {
    final choice = json['choices']?[0];
    final message = choice?['message'] ?? {};

    return MessageModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: message['content'] ?? '',
      role: MessageRole.fromString(message['role'] ?? 'assistant'),
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
  }

  /// Convert to JSON for storage.
  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'role': role.value,
    'timestamp': timestamp.toIso8601String(),
    'status': status.name,
    'error': error,
  };

  /// Convert to OpenAI message format.
  Map<String, dynamic> toOpenAIFormat() => {
    'role': role.value,
    'content': content,
  };
}
