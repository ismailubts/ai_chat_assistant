import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/api_constants.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/message_bubble.dart';
import '../widgets/conversation_drawer.dart';
import '../widgets/empty_chat_widget.dart';

/// Main page for AI chat functionality.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const LoadConversationsEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      drawer: const ConversationDrawer(),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: _blocListener,
        builder: (context, state) {
          return Column(
            children: [
              // Messages list
              Expanded(
                child: state.messages.isEmpty
                    ? const EmptyChatWidget()
                    : _buildMessagesList(state),
              ),

              // Input field
              ChatInputField(
                controller: _textController,
                enabled: state.canSend,
                isLoading: state.isSending,
                onSend: _sendMessage,
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Text(
            state.currentConversation?.displayTitle ?? AppStrings.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: AppStrings.newChat,
          onPressed: _createNewChat,
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'clear',
              child: ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text(AppStrings.clearChat),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text(AppStrings.settings),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessagesList(ChatState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        return MessageBubble(
          message: message,
          onCopy: () => _copyMessage(message.content),
          onRegenerate: message.isAssistant && !message.isLoading
              ? () => _regenerateResponse(message.id)
              : null,
          onDelete: () => _deleteMessage(message.id),
        );
      },
    );
  }

  void _blocListener(BuildContext context, ChatState state) {
    // Scroll to bottom when new message arrives
    if (state.isSending || state.messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }

    if (state.hasError && state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: AppColors.error,
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              context.read<ChatBloc>().add(const ClearErrorEvent());
            },
          ),
        ),
      );
    }
  }

  void _sendMessage() {
    final message = _textController.text.trim();
    if (message.isEmpty) return;

    context.read<ChatBloc>().add(SendMessageEvent(message));
    _textController.clear();
  }

  void _createNewChat() {
    context.read<ChatBloc>().add(const CreateConversationEvent());
  }

  void _copyMessage(String content) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.messageCopied),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _regenerateResponse(String messageId) {
    context.read<ChatBloc>().add(RegenerateResponseEvent(messageId));
  }

  void _deleteMessage(String messageId) {
    context.read<ChatBloc>().add(DeleteMessageEvent(messageId));
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'clear':
        _showClearChatDialog();
        break;
      case 'settings':
        _navigateToSettings();
        break;
    }
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.clearChat),
        content: const Text('Are you sure you want to clear this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (this.context.read<ChatBloc>().state.currentConversation !=
                  null) {
                this.context.read<ChatBloc>().add(
                  DeleteConversationEvent(
                    this.context.read<ChatBloc>().state.currentConversation!.id,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
