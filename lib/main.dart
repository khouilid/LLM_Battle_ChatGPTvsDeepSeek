import 'package:ai_chat/llm_providers/llm_battle_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.blue[300] ?? Colors.blue),
        useMaterial3: true,
      ),
      home: const ChatPage(title: 'ChatGPT VS DeepSeek'),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: LlmChatView(
        provider: LLMBattleProvider(
          gptKey: 'your-chatgpt-api-key',
          deepKey: 'your-deepseek-api-key',
          chatGptModel: 'gpt-4o',
          deepseekModel: 'deepseek-chat',
        ),
        // provider: ChatgptProvider(
        //   model: 'gpt-4o',
        //   apiKey:'your-chatgpt-api-key',
        // ),
        // provider: DeepSeekProvider(
        //     model: 'deepseek-chat',
        //     apiKey: 'your-deepseek-api-key'
        // ),
      ),
    );
  }
}
