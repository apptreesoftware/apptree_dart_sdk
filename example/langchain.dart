import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:apptree_dart_sdk/apptree.dart';

void main(final List<String> arguments) async {
  // Load environment variables from .env file
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final openAiApiKey = env['OPENAI_API_KEY'];

  if (openAiApiKey == null) {
    stderr.writeln(
      'You need to set your OpenAI key in the '
      'OPENAI_API_KEY environment variable.',
    );
    exit(1);
  }

  final sampleGenerator = SampleGenerator(
    className: 'Card',
    requestName: 'MyCardsRequest',
    dataSourceName: 'MyCardsCollection',
    openaiApiKey: openAiApiKey,
  );

  sampleGenerator.generateSamples();
}
