import 'package:equatable/equatable.dart';

import 'message_entity.dart';

/// Entity representing a conversation.
class ConversationEntity extends Equatable {
  final String id;
  final String title;
  final List<MessageEntity> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConversationEntity({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create new conversation.
  factory ConversationEntity.create({
    required String id,
    String title = 'New Chat',
  }) {
    final now = DateTime.now();
    return ConversationEntity(
      id: id,
      title: title,
      messages: const [],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Whether conversation is empty.
  bool get isEmpty => messages.isEmpty;

  /// Whether conversation has messages.
  bool get hasMessages => messages.isNotEmpty;

  /// Last message in conversation.
  MessageEntity? get lastMessage => messages.isNotEmpty ? messages.last : null;

  /// Message count.
  int get messageCount => messages.length;

  /// Get display title (first user message or default).
  String get displayTitle {
    if (title != 'New Chat') return title;
    final firstUserMessage = messages.where((m) => m.isUser).firstOrNull;
    if (firstUserMessage != null) {
      final text = firstUserMessage.content;
      return text.length > 30 ? '${text.substring(0, 30)}...' : text;
    }
    return title;
  }

  ConversationEntity copyWith({
    String? id,
    String? title,
    List<MessageEntity>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Add message to conversation.
  ConversationEntity addMessage(MessageEntity message) {
    return copyWith(
      messages: [...messages, message],
      updatedAt: DateTime.now(),
    );
  }

  /// Update a message in conversation.
  ConversationEntity updateMessage(MessageEntity updatedMessage) {
    final index = messages.indexWhere((m) => m.id == updatedMessage.id);
    if (index == -1) return this;

    final newMessages = List<MessageEntity>.from(messages);
    newMessages[index] = updatedMessage;

    return copyWith(messages: newMessages, updatedAt: DateTime.now());
  }

  /// Remove a message from conversation.
  ConversationEntity removeMessage(String messageId) {
    return copyWith(
      messages: messages.where((m) => m.id != messageId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, title, messages, createdAt, updatedAt];
}
