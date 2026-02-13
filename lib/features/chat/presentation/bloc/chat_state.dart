part of 'chat_bloc.dart';

/// Status enum for chat operations.
enum ChatStatus { initial, loading, loaded, sending, error }

/// State for chat BLoC.
final class ChatState extends Equatable {
  final ChatStatus status;
  final List<ConversationEntity> conversations;
  final ConversationEntity? currentConversation;
  final Failure? failure;

  const ChatState({
    this.status = ChatStatus.initial,
    this.conversations = const [],
    this.currentConversation,
    this.failure,
  });

  /// Whether data is loading.
  bool get isLoading => status == ChatStatus.loading;

  /// Whether a message is being sent.
  bool get isSending => status == ChatStatus.sending;

  /// Whether there's an error.
  bool get hasError => status == ChatStatus.error;

  /// Current messages in the selected conversation.
  List<MessageEntity> get messages => currentConversation?.messages ?? const [];

  /// Error message.
  String? get errorMessage => failure?.message;

  /// Whether we can send a message.
  bool get canSend => !isSending && currentConversation != null;

  ChatState copyWith({
    ChatStatus? status,
    List<ConversationEntity>? conversations,
    ConversationEntity? currentConversation,
    Failure? failure,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      currentConversation: currentConversation ?? this.currentConversation,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    conversations,
    currentConversation,
    failure,
  ];
}
