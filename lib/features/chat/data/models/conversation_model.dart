import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import 'message_model.dart';

/// Model for conversation data transfer.
class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.title,
    required super.messages,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create from entity.
  factory ConversationModel.fromEntity(ConversationEntity entity) {
    return ConversationModel(
      id: entity.id,
      title: entity.title,
      messages: entity.messages,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Create from JSON.
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List<dynamic>? ?? [];

    return ConversationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'New Chat',
      messages: messagesJson
          .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON for storage.
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'messages': messages
        .map((m) => MessageModel.fromEntity(m).toJson())
        .toList(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Convert messages to OpenAI format for API request.
  List<Map<String, dynamic>> toOpenAIMessages() {
    return messages
        .where((m) => m.status != MessageStatus.error)
        .map((m) => MessageModel.fromEntity(m).toOpenAIFormat())
        .toList();
  }
}
