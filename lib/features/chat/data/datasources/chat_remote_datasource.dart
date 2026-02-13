import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/message_model.dart';

/// Remote data source for chat API operations.
abstract class ChatRemoteDataSource {
  /// Send message and get AI response.
  Future<MessageModel> sendMessage({
    required List<Map<String, dynamic>> messages,
    String? model,
  });

  /// Send message with streaming response.
  Stream<String> sendMessageStream({
    required List<Map<String, dynamic>> messages,
    String? model,
  });
}

/// Implementation using OpenAI API.
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient dioClient;

  ChatRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<MessageModel> sendMessage({
    required List<Map<String, dynamic>> messages,
    String? model,
  }) async {
    final response = await dioClient.post<Map<String, dynamic>>(
      ApiConstants.chatCompletions,
      data: {
        'model': model ?? ApiConstants.defaultModel,
        'messages': messages,
        'max_tokens': ApiConstants.maxTokens,
      },
    );

    return MessageModel.fromOpenAIResponse(response.data!);
  }

  @override
  Stream<String> sendMessageStream({
    required List<Map<String, dynamic>> messages,
    String? model,
  }) async* {
    final response = await dioClient.post<ResponseBody>(
      ApiConstants.chatCompletions,
      data: {
        'model': model ?? ApiConstants.defaultModel,
        'messages': messages,
        'max_tokens': ApiConstants.maxTokens,
        'stream': true,
      },
      options: Options(responseType: ResponseType.stream),
    );

    final stream = response.data!.stream;

    await for (final chunk in stream) {
      final lines = utf8.decode(chunk).split('\n');

      for (final line in lines) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();
          if (data == '[DONE]') continue;

          try {
            final json = jsonDecode(data);
            final delta = json['choices']?[0]?['delta'];
            final content = delta?['content'];
            if (content != null) {
              yield content;
            }
          } catch (_) {
            // Skip malformed JSON
          }
        }
      }
    }
  }
}
