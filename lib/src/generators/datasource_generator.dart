import 'dart:mirrors';
import 'package:apptree_dart_sdk/apptree.dart';
import 'package:apptree_dart_sdk/src/util/file.dart';

class DatasourceGenerator {
  final String datasourceName;
  final Record record;
  final Request request;

  DatasourceGenerator({required this.datasourceName, required this.record, required this.request}) {
    // Register the record
    record.register();
    // Register the request
    request.register();
    // Generate the datasource
    generateDatasource();
  }

  String generateImports() {
    return 'import \'package:server/server.dart\';\n\n';
  }

  String generateSignature(String recordName, String requestName) {
    return 'abstract class ${datasourceName}Collection extends CollectionDataSource<$requestName, $recordName> {\n';
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
    final recordName = MirrorSystem.getName(reflect(record).type.simpleName);
    final requestName = MirrorSystem.getName(reflect(request).type.simpleName);
    result += generateImports();
    result += generateSignature(recordName, requestName);
    result += generateGetCollection(recordName, requestName);
    result += generateGetRecord(recordName);
    result += '}\n';

    writeDatasourceDart(datasourceName, result);
  }
}
