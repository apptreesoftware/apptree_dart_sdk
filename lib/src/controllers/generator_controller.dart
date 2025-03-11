import 'package:apptree_dart_sdk/apptree.dart';
import 'package:dotenv/dotenv.dart';
import 'dart:io';

class GeneratorController {
  final App app;
  late String openAiApiKey;

  GeneratorController({required this.app}) {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    openAiApiKey = env['OPENAI_API_KEY'] ?? '';

    if (openAiApiKey == '') {
      stderr.writeln(
        'You need to set your OpenAI key in the '
        'OPENAI_API_KEY environment variable.',
      );
      exit(1);
    }
  }

  void generateConnectors() {
    for (var endpoint in app.endpoints) {
      if (endpoint is CollectionEndpoint) {
        generateCollectionConnector(endpoint);
      } else if (endpoint is ListEndpoint) {
        generateListConnector(endpoint);
      } else if (endpoint is SubmissionEndpoint) {
        generateSubmissionConnector(endpoint);
      }
    }
  }

  void generateCollectionConnector(CollectionEndpoint endpoint) {
    var record = endpoint.record;
    var requestName = endpoint.getRequestParams().keys.first;
    var requestMap = endpoint.getRequestParams()[requestName];
    var datasourceName = endpoint.id;
    var projectDir = app.name;

    ModelGenerator(record: record, projectDir: projectDir);

    CollectionDatasourceGenerator(
      datasourceName: datasourceName,
      record: record,
      requestName: requestName,
      projectDir: projectDir,
    );

    RequestGenerator(
      requestName: requestName,
      requestMap: requestMap,
      projectDir: projectDir,
    );

    CollectionSampleGenerator(
      record: record,
      requestName: requestName,
      dataSourceName: datasourceName,
      openaiApiKey: openAiApiKey,
      projectDir: projectDir,
    );
  }

  void generateListConnector(ListEndpoint endpoint) {
    var record = endpoint.record;
    var datasourceName = endpoint.id;
    var projectDir = app.name;

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

  void generateSubmissionConnector(SubmissionEndpoint endpoint) {
    print('Implement Submission Connector');
  }
}
