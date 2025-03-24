import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';
import 'package:apptree_dart_sdk/apptree.dart';
import 'dart:mirrors';


abstract class SampleGenerator {
  final Record record;
  final String dataSourceName;
  final String projectDir;
  final bool overwrite;
  final Map<String, dynamic> recordDependencyMap;
  final List<Record> records = [];

  SampleGenerator({
    required this.record,
    required this.dataSourceName,
    required this.projectDir,
    required this.recordDependencyMap,
    this.overwrite = false,
  }) {
    buildRecordGraph(record);
    generateSamples();
  }

  bool isTopLevelRecord(String recordName) {
    return recordDependencyMap.keys.contains(recordName) &&
        getRecordName() != recordName;
  }

  List<String> getRelatedRecordNames() {
    List<String> recordNames = [MirrorSystem.getName(reflect(record).type.simpleName)];
    // Return all the records names that are top level and in records
    for (final record in records) {
      if (isTopLevelRecord(MirrorSystem.getName(reflect(record).type.simpleName))) {
        recordNames.add(MirrorSystem.getName(reflect(record).type.simpleName));
      }
    }
    return recordNames;
  }

  void buildRecordGraph(Record record) {
    // Analyze the record to determine the fields and their types
    for (final field in record.fields) {
      if (field is Record && !records.any((r) => r == field)) {
        buildRecordGraph(field);
        records.add(field);
      }
      if (field is ListField && !records.any((r) => r == field.record)) {
        buildRecordGraph(field.record);
        records.add(field.record);
      }
    }
  }

  String getRecordName() {
    return MirrorSystem.getName(reflect(record).type.simpleName);
  }

  String getRecordFileName() {
    return '${separateCapitalsWithUnderscore(getRecordName())}.dart';
  }

  String getFileName(Record record) {
    return separateCapitalsWithUnderscore(
      MirrorSystem.getName(reflect(record).type.simpleName),
    );
  }

  String getDataSourceFileName() {
    return '${separateCapitalsWithUnderscore(dataSourceName)}.dart';
  }

  String getSampleFileName() {
    return '${separateCapitalsWithUnderscore(dataSourceName)}_sample';
  }

  String generateImports();

  Future<String> generateSampleClass();

  Future<void> generateSamples();
}

class CollectionSampleGenerator extends SampleGenerator {
  final String requestName;

  CollectionSampleGenerator({
    required super.record,
    required super.dataSourceName,
    required super.projectDir,
    required super.recordDependencyMap,
    required this.requestName,
    super.overwrite = false,
  });

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
        'import \'package:$projectDir/generated/datasources/${getDataSourceFileName()}\';\n'
        '${records.map((r) => isTopLevelRecord(MirrorSystem.getName(reflect(r).type.simpleName)) ? 'import \'package:$projectDir/generated/models/${getFileName(r)}.dart\';' : '').join('\n')}\n';
  }

  Future<String> generateSampleData() async {
    // TODO: Integrate with Server
    return '';
  }

  String generateGetRecord() {
    return '@override\n  Future<${getRecordName()}> getRecord(String id) async { return samples[0]; }\n';
  }

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

    writeSampleDart(projectDir, getSampleFileName(), res);
  }
}

class ListSampleGenerator extends SampleGenerator {
  ListSampleGenerator({
    required super.record,
    required super.dataSourceName,
    required super.projectDir,
    required super.recordDependencyMap,
  });

  @override
  String generateImports() {
    return 'import \'package:$projectDir/generated/models/${getRecordFileName()}\';\n'
        'import \'package:$projectDir/generated/datasources/${getDataSourceFileName()}\';\n';
  }

  Future<String> generateSampleData() async {
    // TODO: Integrate with Server
    return '';
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

    writeSampleDart(projectDir, getSampleFileName(), res);
  }
}


class SubmissionSampleGenerator extends SampleGenerator {
  final String requestName;

  SubmissionSampleGenerator({
    required super.record,
    required super.dataSourceName,
    required super.projectDir,
    required super.recordDependencyMap,
    required this.requestName,
  });

  String getRequestFileName() {
    return '${separateCapitalsWithUnderscore(requestName)}.dart';
  }

  @override
  String generateImports() {
    return 'import \'package:$projectDir/generated/models/${getRecordFileName()}\';\n'
        'import \'package:$projectDir/generated/models/${getRequestFileName()}\';\n'
        'import \'package:$projectDir/generated/datasources/${getDataSourceFileName()}\';\n'
        '${records.map((r) => isTopLevelRecord(MirrorSystem.getName(reflect(r).type.simpleName)) ? 'import \'package:$projectDir/generated/models/${getFileName(r)}.dart\';' : '').join('\n')}\n';
  }

  @override
  Future<String> generateSampleClass() async {
    String res = 'class Sample$dataSourceName extends $dataSourceName {\n';
    res += '  @override\n';
    res +=
        '  Future<${getRecordName()}> submit($requestName request, ${getRecordName()} record) async {\n';
    res += '  return record;\n';
    res += '  }\n';
    res += '}\n';
    return res;
  }

  @override
  Future<void> generateSamples() async {
    String res = '';
    res += generateImports();
    res += await generateSampleClass();

    writeSampleDart(projectDir, getSampleFileName(), res);
  }
}
