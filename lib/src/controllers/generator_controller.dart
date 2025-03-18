import 'package:apptree_dart_sdk/apptree.dart';
import 'package:dotenv/dotenv.dart';
import 'dart:io';
import 'dart:mirrors';

class GeneratorController {
  final App app;
  late String openAiApiKey;
  List<String> modelNames = [];
  List<ConnectorItem> connectors = [];

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

  String getRecordName(Record record) {
    return MirrorSystem.getName(reflect(record).type.simpleName);
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

    PackageGenerator(projectDir: app.name, connectors: connectors);
  }

  void generateCollectionConnector(CollectionEndpoint endpoint) {
    var connector = ConnectorItem(
      recordName: getRecordName(endpoint.record),
      pkField: endpoint.record.pkFieldName!,
      datasourceName: endpoint.id,
      requestName: endpoint.getRequestParams().keys.first,
      type: ConnectorType.collection,
    );
    connectors.add(connector);

    var requestMap = endpoint.getRequestParams()[connector.requestName];

    var projectDir = app.name;

    ModelGenerator(record: endpoint.record, projectDir: projectDir);

    CollectionDatasourceGenerator(
      datasourceName: connector.datasourceName,
      record: endpoint.record,
      requestName: connector.requestName!,
      projectDir: projectDir,
    );

    RequestGenerator(
      requestName: connector.requestName!,
      requestMap: requestMap,
      projectDir: projectDir,
      type: ConnectorType.collection,
    );
    
    CollectionSampleGenerator(
      record: endpoint.record,
      requestName: connector.requestName!,
      dataSourceName: connector.datasourceName,
      openaiApiKey: openAiApiKey,
      projectDir: projectDir,
    );
  }

  void generateListConnector(ListEndpoint endpoint) {
    var connector = ConnectorItem(
      recordName: getRecordName(endpoint.record),
      datasourceName: endpoint.id,
      requestName: '',
      pkField: endpoint.record.pkFieldName!,
      type: ConnectorType.list,
    );
    connectors.add(connector);

    var projectDir = app.name;

    ModelGenerator(record: endpoint.record, projectDir: projectDir);

    ListDatasourceGenerator(
      datasourceName: connector.datasourceName,
      record: endpoint.record,
      projectDir: projectDir,
    );

    ListSampleGenerator(
      record: endpoint.record,
      dataSourceName: connector.datasourceName,
      openaiApiKey: openAiApiKey,
      projectDir: projectDir,
    );
  }

  void generateSubmissionConnector(SubmissionEndpoint endpoint) {
    var connector = ConnectorItem(
      recordName: getRecordName(endpoint.record),
      datasourceName: endpoint.id,
      requestName: endpoint.getRequestParams().keys.first,
      pkField: endpoint.record.pkFieldName!,
      type: ConnectorType.submission,
    );
    connectors.add(connector);

    var requestMap = endpoint.getRequestParams()[connector.requestName];

    ModelGenerator(record: endpoint.record, projectDir: app.name);

    SubmissionDatasourceGenerator(
      datasourceName: connector.datasourceName,
      record: endpoint.record,
      requestName: connector.requestName!,
      submissionType: endpoint.submissionType,
      projectDir: app.name,
    );

    RequestGenerator(
      requestName: connector.requestName!,
      requestMap: requestMap,
      projectDir: app.name,
      type: ConnectorType.submission,
    );

    SubmissionSampleGenerator(
      record: endpoint.record,
      dataSourceName: connector.datasourceName,
      openaiApiKey: openAiApiKey,
      projectDir: app.name,
      requestName: connector.requestName!,
    );
  }
}
