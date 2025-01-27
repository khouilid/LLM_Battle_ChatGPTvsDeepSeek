import 'package:ai_chat/core/http_client.dart';
import 'package:ai_chat/domain/chatgpt_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

class DeepSeekRespository {
  final DeepSeekService _service;
  final String model;

  DeepSeekRespository({required String apiKey, required this.model})
      : _service = DeepSeekService(apiKey: apiKey);

  Future<String> sendMessage({
    required String message,
    required List<ChatMessage> messages,
  }) async {
    try {
      final response = await _service.sendMessage(
          message: message, model: model, messages: messages);
      return response.choices.first.message.content;
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }
}

class DeepSeekService {
  final String apiKey;
  final String baseUrl = 'https://api.deepseek.com/chat/completions';
  HttpClient? _httpClient;

  DeepSeekService({required this.apiKey}) {
    _httpClient = HttpClient(baseUrl: baseUrl, apiKey: apiKey);
  }

  Future<ChatResponse> sendMessage({
    required String message,
    required String model,
    bool store = true,
    required List<ChatMessage> messages,
  }) async {
    try {
      final response = await _httpClient!.ref.post(
        '',
        data: {
          'model': model,
          "stream": false,
          'messages': messages
              .map((e) => {
                    'role':
                        e.origin == MessageOrigin.user ? 'assistant' : 'user',
                    'content': e.text,
                  })
              .toList(),
        },
      );

      if (response.statusCode == 200) {
        return ChatResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to send message. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw _httpClient!.handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
