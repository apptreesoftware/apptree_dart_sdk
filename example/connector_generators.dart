import 'package:apptree_dart_sdk/apptree.dart';
import 'models.dart';
import 'dart:io';
import 'package:dotenv/dotenv.dart';

void generateConnector(
  record,
  datasourceName,
  routeName,
  projectDir,
  request,
  openAiApiKey,
) {
  ModelGenerator(record: record, projectDir: projectDir);

  CollectionDatasourceGenerator(
    datasourceName: datasourceName,
    record: record,
    request: request,
    projectDir: projectDir,
  );

  RequestGenerator(request: request, projectDir: projectDir);

  CollectionSampleGenerator(
    record: record,
    request: request,
    dataSourceName: datasourceName,
    openaiApiKey: openAiApiKey,
    projectDir: projectDir,
  );
}

void generateListConnector(
  record,
  datasourceName,
  routeName,
  projectDir,
  openAiApiKey,
) {
  ModelGenerator(record: record, projectDir: projectDir);

  ListDatasourceGenerator(
    datasourceName: datasourceName,
    record: record,
    projectDir: projectDir,
  );

  ListSampleGenerator(
    record: record,
    dataSourceName: datasourceName,
    openaiApiKey: openAiApiKey,
    projectDir: projectDir,
  );
}

void main() {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  final openAiApiKey = env['OPENAI_API_KEY'];
  final projectDir = 'example_connector';
  final routeName = 'my-cards';
  final datasourceName = 'MyCardsCollection';
  final card = Card();
  final cardRequest = MyCardsRequest(owner: 'John Doe', filter: 'My Cards');

  if (openAiApiKey == null) {
    stderr.writeln(
      'You need to set your OpenAI key in the '
      'OPENAI_API_KEY environment variable.',
    );
    exit(1);
  }

  generateConnector(
    Card(),
    'MyCardsCollection',
    'my-cards',
    projectDir,
    MyCardsRequest(owner: 'John Doe', filter: 'My Cards'),
    openAiApiKey,
  );

  generateListConnector(
    Owner(),
    'Owners',
    'owners',
    projectDir,
    openAiApiKey,
  );

  PackageGenerator(
    projectDir: projectDir,
    record: card,
    request: cardRequest,
    datasourceName: datasourceName,
    routeName: routeName,
  );

  runFlutterPubGet(projectDir);
}
