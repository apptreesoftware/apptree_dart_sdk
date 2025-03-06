import 'package:apptree_dart_sdk/apptree.dart';
import 'models.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart';

void main() {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final openAiApiKey = env['OPENAI_API_KEY'];
  final projectDir = 'example_connector';
  final card = Card();
  final cardRequest = MyCardsRequest(owner: 'John Doe', filter: 'My Cards');
  final myCardsEndpoint = MyCardsEndpoint();

  if (openAiApiKey == null) {
    stderr.writeln(
      'You need to set your OpenAI key in the '
      'OPENAI_API_KEY environment variable.',
    );
    exit(1);
  }

  PackageGenerator(
    projectDir: projectDir,
    record: card,
    request: cardRequest,
    datasourceName: myCardsEndpoint.getDatasourceName(),
    routeName: myCardsEndpoint.getRouteName(),
  );

  runFlutterPubGet(projectDir);
}

void GenerateServerEndpoint(
  String projectDir,
  CollectionEndpoint endpoint,
  Record record,
  Request request,
) {

  ModelGenerator(record: card, projectDir: projectDir);

  DatasourceGenerator(
    datasourceName: myCardsEndpoint.getDatasourceName(),
    record: card,
    request: cardRequest,
    projectDir: projectDir,
  );

  RequestGenerator(request: cardRequest, projectDir: projectDir);

  SampleGenerator(
    record: card,
    request: cardRequest,
    dataSourceName: myCardsEndpoint.getDatasourceName(),
    openaiApiKey: openAiApiKey,
    projectDir: projectDir,
  );

}
