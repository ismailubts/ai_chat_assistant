import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/manage_conversations_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

/// BLoC for managing chat functionality.
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final ManageConversationsUseCase manageConversationsUseCase;
  final Uuid _uuid = const Uuid();

  StreamSubscription? _streamSubscription;

  ChatBloc({
    required this.sendMessageUseCase,
    required this.manageConversationsUseCase,
  }) : super(const ChatState()) {
    on<LoadConversationsEvent>(_onLoadConversations);
    on<CreateConversationEvent>(_onCreateConversation);
    on<SelectConversationEvent>(_onSelectConversation);
    on<DeleteConversationEvent>(_onDeleteConversation);
    on<ClearAllConversationsEvent>(_onClearAllConversations);
    on<SendMessageEvent>(_onSendMessage);
    on<UpdateStreamingMessageEvent>(_onUpdateStreamingMessage);
    on<CompleteStreamingEvent>(_onCompleteStreaming);
    on<RegenerateResponseEvent>(_onRegenerateResponse);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<ClearErrorEvent>(_onClearError);
  }

  Future<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading));

    final result = await manageConversationsUseCase.getAll();

    result.fold(
      (failure) =>
          emit(state.copyWith(status: ChatStatus.error, failure: failure)),
      (conversations) {
        emit(
          state.copyWith(
            status: ChatStatus.loaded,
            conversations: conversations,
          ),
        );

        // Create new conversation if none exist
        if (conversations.isEmpty) {
          add(const CreateConversationEvent());
        } else {
          add(SelectConversationEvent(conversations.first.id));
        }
      },
    );
  }

  void _onCreateConversation(
    CreateConversationEvent event,
    Emitter<ChatState> emit,
  ) {
    final conversation = ConversationEntity.create(
      id: _uuid.v4(),
      title: event.title ?? 'New Chat',
    );

    final updatedConversations = [conversation, ...state.conversations];

    emit(
      state.copyWith(
        conversations: updatedConversations,
        currentConversation: conversation,
      ),
    );

    // Save to storage
    manageConversationsUseCase.save(conversation);
  }

  void _onSelectConversation(
    SelectConversationEvent event,
    Emitter<ChatState> emit,
  ) {
    final conversation = state.conversations.firstWhere(
      (c) => c.id == event.conversationId,
      orElse: () => state.conversations.first,
    );

    emit(state.copyWith(currentConversation: conversation));
  }

  Future<void> _onDeleteConversation(
    DeleteConversationEvent event,
    Emitter<ChatState> emit,
  ) async {
    await manageConversationsUseCase.delete(event.conversationId);

    final updatedConversations = state.conversations
        .where((c) => c.id != event.conversationId)
        .toList();

    ConversationEntity? currentConversation = state.currentConversation;

    if (state.currentConversation?.id == event.conversationId) {
      if (updatedConversations.isEmpty) {
        currentConversation = ConversationEntity.create(
          id: _uuid.v4(),
          title: 'New Chat',
        );
        updatedConversations.insert(0, currentConversation);
        manageConversationsUseCase.save(currentConversation);
      } else {
        currentConversation = updatedConversations.first;
      }
    }

    emit(
      state.copyWith(
        conversations: updatedConversations,
        currentConversation: currentConversation,
      ),
    );
  }

  Future<void> _onClearAllConversations(
    ClearAllConversationsEvent event,
    Emitter<ChatState> emit,
  ) async {
    await manageConversationsUseCase.clearAll();

    final newConversation = ConversationEntity.create(
      id: _uuid.v4(),
      title: 'New Chat',
    );

    manageConversationsUseCase.save(newConversation);

    emit(
      state.copyWith(
        conversations: [newConversation],
        currentConversation: newConversation,
      ),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.currentConversation == null) return;

    final userMessage = MessageEntity(
      id: _uuid.v4(),
      content: event.message,
      role: MessageRole.user,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    // Add user message
    var updatedConversation = state.currentConversation!.addMessage(
      userMessage,
    );

    // Add placeholder for assistant response
    final assistantMessage = MessageEntity(
      id: _uuid.v4(),
      content: '',
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    updatedConversation = updatedConversation.addMessage(assistantMessage);

    _updateConversation(emit, updatedConversation);
    emit(state.copyWith(status: ChatStatus.sending));

    // Send message with streaming
    final params = SendMessageParams(
      conversationId: updatedConversation.id,
      message: event.message,
      conversationHistory: updatedConversation.messages
          .where((m) => m.id != assistantMessage.id)
          .toList(),
    );

    final streamContent = StringBuffer();

    _streamSubscription?.cancel();
    _streamSubscription = sendMessageUseCase
        .stream(params)
        .listen(
          (result) {
            result.fold(
              (failure) => add(
                CompleteStreamingEvent(
                  messageId: assistantMessage.id,
                  error: failure.message,
                ),
              ),
              (chunk) {
                streamContent.write(chunk);
                add(
                  UpdateStreamingMessageEvent(
                    messageId: assistantMessage.id,
                    content: streamContent.toString(),
                  ),
                );
              },
            );
          },
          onDone: () {
            add(CompleteStreamingEvent(messageId: assistantMessage.id));
          },
          onError: (error) {
            add(
              CompleteStreamingEvent(
                messageId: assistantMessage.id,
                error: error.toString(),
              ),
            );
          },
        );
  }

  void _onUpdateStreamingMessage(
    UpdateStreamingMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state.currentConversation == null) return;

    final updatedMessage = state.currentConversation!.messages
        .firstWhere((m) => m.id == event.messageId)
        .copyWith(content: event.content);

    final updatedConversation = state.currentConversation!.updateMessage(
      updatedMessage,
    );

    _updateConversation(emit, updatedConversation);
  }

  void _onCompleteStreaming(
    CompleteStreamingEvent event,
    Emitter<ChatState> emit,
  ) {
    if (state.currentConversation == null) return;

    final message = state.currentConversation!.messages.firstWhere(
      (m) => m.id == event.messageId,
    );

    final updatedMessage = message.copyWith(
      status: event.error != null ? MessageStatus.error : MessageStatus.sent,
      error: event.error,
    );

    final updatedConversation = state.currentConversation!.updateMessage(
      updatedMessage,
    );

    _updateConversation(emit, updatedConversation);
    emit(
      state.copyWith(
        status: event.error != null ? ChatStatus.error : ChatStatus.loaded,
        failure: event.error != null
            ? ServerFailure(message: event.error!)
            : null,
      ),
    );

    // Save conversation
    manageConversationsUseCase.save(updatedConversation);
  }

  Future<void> _onRegenerateResponse(
    RegenerateResponseEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.currentConversation == null) return;

    // Find the last user message before this response
    final messages = state.currentConversation!.messages;
    final responseIndex = messages.indexWhere((m) => m.id == event.messageId);

    if (responseIndex <= 0) return;

    final lastUserMessage = messages[responseIndex - 1];
    if (!lastUserMessage.isUser) return;

    // Remove the old response
    var updatedConversation = state.currentConversation!.removeMessage(
      event.messageId,
    );

    _updateConversation(emit, updatedConversation);

    // Resend the message
    add(SendMessageEvent(lastUserMessage.content));
  }

  void _onDeleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) {
    if (state.currentConversation == null) return;

    final updatedConversation = state.currentConversation!.removeMessage(
      event.messageId,
    );

    _updateConversation(emit, updatedConversation);
    manageConversationsUseCase.save(updatedConversation);
  }

  void _onClearError(ClearErrorEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(status: ChatStatus.loaded, failure: null));
  }

  void _updateConversation(
    Emitter<ChatState> emit,
    ConversationEntity conversation,
  ) {
    final updatedConversations = state.conversations.map((c) {
      if (c.id == conversation.id) return conversation;
      return c;
    }).toList();

    emit(
      state.copyWith(
        conversations: updatedConversations,
        currentConversation: conversation,
      ),
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
