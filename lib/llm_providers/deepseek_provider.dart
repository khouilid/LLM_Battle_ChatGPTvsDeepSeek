import 'package:ai_chat/repository/deepseek_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

class DeepSeekProvider extends LlmProvider with ChangeNotifier {
  DeepSeekRespository? gptRepository;

  DeepSeekProvider({required String apiKey, required String model})
      : gptRepository = DeepSeekRespository(
          apiKey: apiKey,
          model: model,
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

    final response = await gptRepository!
        .sendMessage(message: prompt, messages: history.toList());

    history = [
      ...history,
      ChatMessage(attachments: [], origin: MessageOrigin.llm, text: response),
    ];

    notifyListeners();
  }
}
