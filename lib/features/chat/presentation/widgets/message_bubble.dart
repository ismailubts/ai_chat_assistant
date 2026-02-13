import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/message_entity.dart';

/// Widget displaying a chat message bubble.
class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final VoidCallback? onCopy;
  final VoidCallback? onRegenerate;
  final VoidCallback? onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    this.onCopy,
    this.onRegenerate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUser = message.isUser;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(context, isUser),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // Message bubble
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.surfaceDark
                              : AppColors.surfaceLight),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppRadius.message),
                      topRight: const Radius.circular(AppRadius.message),
                      bottomLeft: Radius.circular(
                        isUser ? AppRadius.message : AppRadius.xs,
                      ),
                      bottomRight: Radius.circular(
                        isUser ? AppRadius.xs : AppRadius.message,
                      ),
                    ),
                    border: isUser
                        ? null
                        : Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: _buildMessageContent(context, isUser),
                ),

                // Action buttons for assistant messages
                if (!isUser && !message.isLoading) _buildActionButtons(context),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (isUser) _buildAvatar(context, isUser),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, bool isUser) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser ? AppColors.primary : AppColors.secondary,
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isUser) {
    final theme = Theme.of(context);

    if (message.isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                isUser ? Colors.white : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Thinking...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isUser ? Colors.white70 : null,
            ),
          ),
        ],
      );
    }

    if (message.hasError) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: AppSpacing.xs),
          Text(
            message.error ?? 'Error occurred',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
          ),
        ],
      );
    }

    // Render markdown for assistant, plain text for user
    if (isUser) {
      return Text(
        message.content,
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
      );
    }

    return MarkdownBody(
      data: message.content,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        p: theme.textTheme.bodyMedium,
        code: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          backgroundColor: theme.brightness == Brightness.dark
              ? Colors.black26
              : Colors.black12,
        ),
        codeblockDecoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? Colors.black26
              : Colors.black12,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onCopy != null)
            IconButton(
              icon: const Icon(Icons.copy, size: 16),
              onPressed: onCopy,
              tooltip: 'Copy',
              visualDensity: VisualDensity.compact,
            ),
          if (onRegenerate != null)
            IconButton(
              icon: const Icon(Icons.refresh, size: 16),
              onPressed: onRegenerate,
              tooltip: 'Regenerate',
              visualDensity: VisualDensity.compact,
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 16),
              onPressed: onDelete,
              tooltip: 'Delete',
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
