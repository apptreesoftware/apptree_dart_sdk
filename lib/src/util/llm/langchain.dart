import 'dart:io';

import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

void generateSamples(String openAiApiKey) async {

  final llm = ChatOpenAI(apiKey: openAiApiKey);

  stdout.writeln('How can I help you?');

  final query = "Write me a haiku about a cat";
  final humanMessage = ChatMessage.humanText(query);
  final aiMessage = await llm.call([humanMessage]);
  stdout.writeln(aiMessage.content.trim());
}
