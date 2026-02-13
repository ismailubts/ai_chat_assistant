import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/conversation_entity.dart';
import '../bloc/chat_bloc.dart';

/// Drawer widget showing conversation history.
class ConversationDrawer extends StatelessWidget {
  const ConversationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.smart_toy, color: AppColors.primary, size: 32),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    AppStrings.appName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // New chat button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<ChatBloc>().add(const CreateConversationEvent());
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add),
                label: const Text(AppStrings.newChat),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),

            // Conversations list
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state.conversations.isEmpty) {
                    return Center(
                      child: Text(
                        'No conversations yet',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: state.conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = state.conversations[index];
                      final isSelected =
                          conversation.id == state.currentConversation?.id;

                      return _ConversationTile(
                        conversation: conversation,
                        isSelected: isSelected,
                        onTap: () {
                          context.read<ChatBloc>().add(
                            SelectConversationEvent(conversation.id),
                          );
                          Navigator.pop(context);
                        },
                        onDelete: () {
                          _showDeleteDialog(context, conversation);
                        },
                      );
                    },
                  );
                },
              ),
            ),

            const Divider(height: 1),

            // Footer actions
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text(AppStrings.settings),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_sweep),
                    title: const Text('Clear All'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    onTap: () {
                      _showClearAllDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    ConversationEntity conversation,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: Text('Delete "${conversation.displayTitle}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatBloc>().add(
                DeleteConversationEvent(conversation.id),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Conversations'),
        content: const Text(
          'This will delete all your chat history. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context); // Close drawer
              context.read<ChatBloc>().add(const ClearAllConversationsEvent());
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ConversationTile({
    required this.conversation,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: ListTile(
        leading: Icon(
          Icons.chat_bubble_outline,
          color: isSelected ? AppColors.primary : null,
          size: 20,
        ),
        title: Text(
          conversation.displayTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppColors.primary : null,
          ),
        ),
        subtitle: Text(
          _formatDate(conversation.updatedAt),
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 18),
          onPressed: onDelete,
          visualDensity: VisualDensity.compact,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
