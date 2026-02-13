import 'package:equatable/equatable.dart';

/// Entity representing a chat message.
class MessageEntity extends Equatable {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final MessageStatus status;
  final String? error;

  const MessageEntity({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.error,
  });

  /// Whether this is a user message.
  bool get isUser => role == MessageRole.user;

  /// Whether this is an assistant message.
  bool get isAssistant => role == MessageRole.assistant;

  /// Whether this is a system message.
  bool get isSystem => role == MessageRole.system;

  /// Whether message is still loading.
  bool get isLoading => status == MessageStatus.sending;

  /// Whether message has error.
  bool get hasError => status == MessageStatus.error;

  MessageEntity copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    MessageStatus? status,
    String? error,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [id, content, role, timestamp, status, error];
}

/// Role of message sender.
enum MessageRole {
  user('user'),
  assistant('assistant'),
  system('system');

  final String value;
  const MessageRole(this.value);

  factory MessageRole.fromString(String value) {
    return MessageRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => MessageRole.user,
    );
  }
}

/// Status of message.
enum MessageStatus { sending, sent, error }
