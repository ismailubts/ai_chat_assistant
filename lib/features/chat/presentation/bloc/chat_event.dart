part of 'chat_bloc.dart';

/// Base event for chat BLoC.
sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all conversations.
final class LoadConversationsEvent extends ChatEvent {
  const LoadConversationsEvent();
}

/// Event to create a new conversation.
final class CreateConversationEvent extends ChatEvent {
  final String? title;

  const CreateConversationEvent({this.title});

  @override
  List<Object?> get props => [title];
}

/// Event to select a conversation.
final class SelectConversationEvent extends ChatEvent {
  final String conversationId;

  const SelectConversationEvent(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

/// Event to delete a conversation.
final class DeleteConversationEvent extends ChatEvent {
  final String conversationId;

  const DeleteConversationEvent(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

/// Event to clear all conversations.
final class ClearAllConversationsEvent extends ChatEvent {
  const ClearAllConversationsEvent();
}

/// Event to send a message.
final class SendMessageEvent extends ChatEvent {
  final String message;

  const SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

/// Event to update streaming message content.
final class UpdateStreamingMessageEvent extends ChatEvent {
  final String messageId;
  final String content;

  const UpdateStreamingMessageEvent({
    required this.messageId,
    required this.content,
  });

  @override
  List<Object> get props => [messageId, content];
}

/// Event when streaming completes.
final class CompleteStreamingEvent extends ChatEvent {
  final String messageId;
  final String? error;

  const CompleteStreamingEvent({required this.messageId, this.error});

  @override
  List<Object?> get props => [messageId, error];
}

/// Event to regenerate a response.
final class RegenerateResponseEvent extends ChatEvent {
  final String messageId;

  const RegenerateResponseEvent(this.messageId);

  @override
  List<Object> get props => [messageId];
}

/// Event to delete a message.
final class DeleteMessageEvent extends ChatEvent {
  final String messageId;

  const DeleteMessageEvent(this.messageId);

  @override
  List<Object> get props => [messageId];
}

/// Event to clear error state.
final class ClearErrorEvent extends ChatEvent {
  const ClearErrorEvent();
}
