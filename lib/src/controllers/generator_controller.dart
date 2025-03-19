import 'package:apptree_dart_sdk/apptree.dart';
import 'package:dotenv/dotenv.dart';
import 'dart:io';
import 'dart:mirrors';

class GeneratorController {
  final App app;
  late String openAiApiKey;
  Map<String, dynamic> recordDependencyMap = {};

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

    getRecordDependencyMap();
  }

  String getRecordName(Record record) {
    return MirrorSystem.getName(reflect(record).type.simpleName);
  }

  Map<String, dynamic> getRecordDependencyMap() {
    Map<String, dynamic> buildRecordDependencyMapImpl(Record record) {
      Map<String, dynamic> recordMap = {};
      for (final field in record.fields) {
        if (field is Record) {
          recordMap[field.runtimeType
              .toString()] = buildRecordDependencyMapImpl(field);
        }
        if (field is ListField) {
          recordMap[field.record.runtimeType
              .toString()] = buildRecordDependencyMapImpl(field.record);
        }
      }

      return recordMap;
    }

    for (var endpoint in app.endpoints) {
      recordDependencyMap[endpoint.record.runtimeType
          .toString()] = buildRecordDependencyMapImpl(endpoint.record);
    }

    return recordDependencyMap;
  }

  List<ConnectorItem> getConnectors() {
    return app.endpoints
        .map(
          (endpoint) => ConnectorItem(
            recordName: getRecordName(endpoint.record),
            datasourceName: endpoint.id,
            requestName: endpoint is SubmissionEndpoint
                ? endpoint.getRequestParams().keys.first
                : endpoint is CollectionEndpoint
                ? endpoint.getRequestParams().keys.first
                : null,
            type:
                endpoint is CollectionEndpoint
                    ? ConnectorType.collection
                    : endpoint is ListEndpoint
                    ? ConnectorType.list
                    : ConnectorType.submission,
            pkField: endpoint.record.pkFieldName ?? '',
          ),
        )
        .toList();
  }

  void generateConnectors() {
    for (var endpoint in app.endpoints) {
      ModelGenerator(
        record: endpoint.record,
        projectDir: app.name,
        recordDependencyMap: recordDependencyMap,
      );

      if (endpoint is CollectionEndpoint) {
        generateCollectionConnector(endpoint);
      } else if (endpoint is ListEndpoint) {
        generateListConnector(endpoint);
      } else if (endpoint is SubmissionEndpoint) {
        generateSubmissionConnector(endpoint);
      }
    }

    PackageGenerator(projectDir: app.name, connectors: getConnectors());
  }

  void generateCollectionConnector(CollectionEndpoint endpoint) {
    var requestMap = endpoint.getRequestParams();
    var requestName = requestMap.keys.first;
    var projectDir = app.name;

    CollectionDatasourceGenerator(
      datasourceName: endpoint.id,
      record: endpoint.record,
      requestName: requestName,
      projectDir: projectDir,
    );

    RequestGenerator(
      requestName: requestName,
      requestMap: requestMap,
      projectDir: projectDir,
      type: ConnectorType.collection,
    );

    CollectionSampleGenerator(
      record: endpoint.record,
      requestName: requestName,
      dataSourceName: endpoint.id,
      openaiApiKey: openAiApiKey,
      recordDependencyMap: recordDependencyMap,
      projectDir: projectDir,
    );
  }

  void generateListConnector(Endpoint endpoint) {
    var projectDir = app.name;

    ListDatasourceGenerator(
      datasourceName: endpoint.id,
      record: endpoint.record,
      projectDir: projectDir,
    );

    ListSampleGenerator(
      record: endpoint.record,
      dataSourceName: endpoint.id,
      openaiApiKey: openAiApiKey,
      recordDependencyMap: recordDependencyMap,
      projectDir: projectDir,
    );
  }

  void generateSubmissionConnector(SubmissionEndpoint endpoint) {
    var requestMap = endpoint.getRequestParams();
    var requestName = requestMap.keys.first;
    var projectDir = app.name;

    SubmissionDatasourceGenerator(
      datasourceName: endpoint.id,
      record: endpoint.record,
      requestName: requestName,
      submissionType: endpoint.submissionType!,
      projectDir: projectDir,
    );

    RequestGenerator(
      requestName: requestName,
      requestMap: requestMap,
      projectDir: projectDir,
      type: ConnectorType.submission,
    );

    SubmissionSampleGenerator(
      record: endpoint.record,
      dataSourceName: endpoint.id,
      openaiApiKey: openAiApiKey,
      recordDependencyMap: recordDependencyMap,
      projectDir: projectDir,
      requestName: requestName,
    );
  }
}
