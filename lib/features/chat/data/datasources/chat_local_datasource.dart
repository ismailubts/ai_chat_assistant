import 'dart:convert';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../models/conversation_model.dart';

/// Local data source for chat persistence.
abstract class ChatLocalDataSource {
  /// Get all conversations.
  Future<List<ConversationModel>> getConversations();

  /// Get a specific conversation.
  Future<ConversationModel?> getConversation(String id);

  /// Save a conversation.
  Future<void> saveConversation(ConversationModel conversation);

  /// Delete a conversation.
  Future<void> deleteConversation(String id);

  /// Clear all conversations.
  Future<void> clearAllConversations();

  /// Get current conversation ID.
  Future<String?> getCurrentConversationId();

  /// Set current conversation ID.
  Future<void> setCurrentConversationId(String id);
}

/// Implementation using shared preferences.
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final StorageService storageService;

  ChatLocalDataSourceImpl({required this.storageService});

  @override
  Future<List<ConversationModel>> getConversations() async {
    final jsonString = storageService.getString(StorageKeys.conversations);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map(
            (json) => ConversationModel.fromJson(json as Map<String, dynamic>),
          )
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ConversationModel?> getConversation(String id) async {
    final conversations = await getConversations();
    try {
      return conversations.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveConversation(ConversationModel conversation) async {
    final conversations = await getConversations();

    // Remove existing if present
    final index = conversations.indexWhere((c) => c.id == conversation.id);
    if (index != -1) {
      conversations[index] = conversation;
    } else {
      conversations.insert(0, conversation);
    }

    // Keep only last 50 conversations
    final trimmed = conversations.take(50).toList();

    await storageService.setString(
      StorageKeys.conversations,
      jsonEncode(
        trimmed.map((c) => ConversationModel.fromEntity(c).toJson()).toList(),
      ),
    );
  }

  @override
  Future<void> deleteConversation(String id) async {
    final conversations = await getConversations();
    conversations.removeWhere((c) => c.id == id);

    await storageService.setString(
      StorageKeys.conversations,
      jsonEncode(
        conversations
            .map((c) => ConversationModel.fromEntity(c).toJson())
            .toList(),
      ),
    );
  }

  @override
  Future<void> clearAllConversations() async {
    await storageService.remove(StorageKeys.conversations);
  }

  @override
  Future<String?> getCurrentConversationId() async {
    return storageService.getString(StorageKeys.currentConversationId);
  }

  @override
  Future<void> setCurrentConversationId(String id) async {
    await storageService.setString(StorageKeys.currentConversationId, id);
  }
}
