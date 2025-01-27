import 'package:ai_chat/core/extensions.dart';
import 'package:ai_chat/repository/chatgpt_repo.dart';
import 'package:ai_chat/repository/deepseek_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

class LLMBattleProvider extends LlmProvider with ChangeNotifier {
  final ChatGptRespository gptRepository;
  final DeepSeekRespository deepseekRepository;

  LLMBattleProvider({
    required String gptKey,
    required String deepKey,
    required String chatGptModel,
    required String deepseekModel,
  })  : gptRepository = ChatGptRespository(
          apiKey: gptKey,
          model: chatGptModel,
        ),
        deepseekRepository = DeepSeekRespository(
          apiKey: deepKey,
          model: deepseekModel,
        );

  @override
  Iterable<ChatMessage> history = [];

  @override
  Stream<String> generateStream(String prompt,
      {Iterable<Attachment> attachments = const []}) async* {}

  @override
  Stream<String> sendMessageStream(String prompt,
      {Iterable<Attachment> attachments = const []}) async* {
    history = [
      ChatMessage(attachments: [], origin: MessageOrigin.user, text: prompt),
    ];
    await _chatGPT(prompt);
  }

  Future<void> _chatGPT(String prompt) async {
    try {
      final gptResponse = await gptRepository.sendMessage(
          message: prompt, messages: history.toList());

      _updateChatHistory(
        ChatMessage(
            attachments: [], origin: MessageOrigin.llm, text: gptResponse),
      );
      await _deepSeek(gptResponse);
      
    } catch (e) {
      _updateChatHistory(ChatMessage(
        attachments: [],
        origin: MessageOrigin.llm,
        text: "GPT Error: ${e.toString()}",
      ));
    }
  }

  Future<void> _deepSeek(String prompt) async {
    try {
      final deepResponse = await deepseekRepository.sendMessage(
          message: prompt, messages: history.toList());

      _updateChatHistory(ChatMessage(
          attachments: [], origin: MessageOrigin.user, text: deepResponse));

      await _chatGPT(prompt);
    } catch (e) {
      _updateChatHistory(ChatMessage(
        attachments: [],
        origin: MessageOrigin.user,
        text: "DeepSeek Error: ${e.toString()}",
      ));
    }
  }

  void _updateChatHistory(ChatMessage newMessage) {
    history = [...history.takeLast(10), newMessage ];
    notifyListeners();
  }
}
