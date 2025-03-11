import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';
import 'package:apptree_dart_sdk/apptree.dart';
import 'dart:mirrors';
import 'package:apptree_dart_sdk/src/util/llm/langchain.dart';

abstract class SampleGenerator {
  final Record record;
  final String dataSourceName;
  final String projectDir;
  final String openaiApiKey;
  final bool overwrite;

  SampleGenerator({
    required this.record,
    required this.dataSourceName,
    required this.projectDir,
    required this.openaiApiKey,
    this.overwrite = false,
  }) {
    generateSamples();
  }

  String getRecordName() {
    return MirrorSystem.getName(reflect(record).type.simpleName);
  }

  String getRecordFileName() {
    return '${separateCapitalsWithUnderscore(getRecordName())}.dart';
  }

  String getDataSourceFileName() {
    return '${separateCapitalsWithUnderscore(dataSourceName)}.dart';
  }

  String getFileName() {
    return '${separateCapitalsWithUnderscore(dataSourceName)}_sample';
  }

  String generateImports();

  Future<String> generateSampleData();

  Future<String> generateSampleClass();

  Future<void> generateSamples();
}

class CollectionSampleGenerator extends SampleGenerator {
  final String requestName;

  CollectionSampleGenerator({
    required super.record,
    required super.dataSourceName,
    required super.projectDir,
    required super.openaiApiKey,
    required this.requestName,
    super.overwrite = false,
  }) {
    generateSamples();
  }

  String getRequestName() {
    return requestName;
  }

  String getRequestFileName() {
    return '${separateCapitalsWithUnderscore(getRequestName())}.dart';
  }

  @override
  String generateImports() {
    return 'import \'package:$projectDir/generated/models/${getRecordFileName()}\';\n'
        'import \'package:$projectDir/generated/models/${getRequestFileName()}\';\n'
        'import \'package:$projectDir/generated/datasources/${getDataSourceFileName()}\';\n';
  }

  @override
  Future<String> generateSampleData() async {
    return await generateSampleDataLLM(
      'Please produce 10 samples of the ${getRecordName()} objects.',
      getFileName(),
      getRecordName(),
      projectDir,
      openaiApiKey,
      overwrite,
    );
  }

  // TODO: Needs to be updated to return the correct object
  String generateGetRecord() {
    return '@override\n  Future<${getRecordName()}> getRecord(String id) async { return samples[0]; }\n';
  }

  // TODO: Implement Filters
  @override
  Future<String> generateSampleClass() async {
    String res = 'class Sample$dataSourceName extends $dataSourceName {\n';
    res += '  ${await generateSampleData()}\n';
    res += '  @override\n';
    res +=
        '  Future<List<${getRecordName()}>> getCollection(${getRequestName()} request) async {\n';
    res += '  return samples;\n';
    res += '  }\n';
    res += generateGetRecord();
    res += '}\n';
    return res;
  }

  @override
  Future<void> generateSamples() async {
    String res = '';
    res += generateImports();
    res += await generateSampleClass();

    writeSampleDart(projectDir, getFileName(), res);
  }
}

class ListSampleGenerator extends SampleGenerator {
  ListSampleGenerator({
    required super.record,
    required super.dataSourceName,
    required super.projectDir,
    required super.openaiApiKey,
  });

  @override
  String generateImports() {
    return 'import \'package:$projectDir/generated/models/${getRecordFileName()}\';\n'
        'import \'package:$projectDir/generated/datasources/${getDataSourceFileName()}\';\n';
  }

  @override
  Future<String> generateSampleData() async {
    return await generateSampleDataLLM(
      'Please produce 10 samples of the ${getRecordName()} objects.',
      getFileName(),
      getRecordName(),
      projectDir,
      openaiApiKey,
      overwrite,
    );
  }

  @override
  Future<String> generateSampleClass() async {
    String res = 'class Sample$dataSourceName extends $dataSourceName {\n';
    res += '  ${await generateSampleData()}\n';
    res += '  @override\n';
    res += '  Future<List<${getRecordName()}>> getList() async {\n';
    res += '  return samples;\n';
    res += '  }\n';
    res += '}\n';
    return res;
  }

  @override
  Future<void> generateSamples() async {
    String res = '';
    res += generateImports();
    res += await generateSampleClass();

    writeSampleDart(projectDir, getFileName(), res);
  }
}
