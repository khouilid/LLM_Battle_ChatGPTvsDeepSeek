import 'package:ai_chat/repository/chatgpt_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

class ChatgptProvider extends LlmProvider with ChangeNotifier {
  ChatGptRespository? gptRepository;

  ChatgptProvider({required String apiKey, required String model})
      : gptRepository = ChatGptRespository(
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
