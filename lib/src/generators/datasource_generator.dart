import 'dart:mirrors';
import 'package:apptree_dart_sdk/apptree.dart';
import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';
class DatasourceGenerator {
  final String datasourceName;
  final Record record;
  final Request request;
  final String projectDir;

  DatasourceGenerator({required this.datasourceName, required this.record, required this.request, required this.projectDir}) {
    // Register the record
    record.register();
    // Register the request
    request.register();
    // Generate the datasource
    generateDatasource();
  }

  String getRecordName() {
    return MirrorSystem.getName(reflect(record).type.simpleName);
  }

  String getRequestName() {
    return MirrorSystem.getName(reflect(request).type.simpleName);
  }

  String getRecordFileName() {
    return '${separateCapitalsWithUnderscore(getRecordName())}.dart';
  }

  String getRequestFileName() {
    return '${separateCapitalsWithUnderscore(getRequestName())}.dart';
  }

  String getFileName() {
    return separateCapitalsWithUnderscore(datasourceName);
  }

  String generateImports() {
    return 'import \'package:server/server.dart\';\n\n'
        'import \'package:$projectDir/generated/models/${getRecordFileName()}\';\n'
        'import \'package:$projectDir/generated/models/${getRequestFileName()}\';\n';
  }

  String generateSignature(String recordName, String requestName) {
    return 'abstract class $datasourceName extends CollectionDataSource<$requestName, $recordName> {\n';
  }

  String generateGetCollection(String recordName, String requestName) {
    String result = '  @override\n  Future<List<$recordName>> getCollection($requestName request);\n\n';
    return result;
  }

  String generateGetRecord(String recordName) {
    String result = '  @override\n  Future<$recordName> getRecord(String id);\n';
    return result;
  }

  void generateDatasource() {
    String result = '';
    final recordName = getRecordName();
    final requestName = getRequestName();
    result += generateImports();
    result += generateSignature(recordName, requestName);
    result += generateGetCollection(recordName, requestName);
    result += generateGetRecord(recordName);
    result += '}\n';

    writeDatasourceDart(projectDir, getFileName(), result);
  }
}
