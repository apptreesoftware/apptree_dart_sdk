import 'dart:mirrors';
import 'package:apptree_dart_sdk/apptree.dart';
import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';

abstract class DatasourceGenerator {
  final String datasourceName;
  final Record record;
  final String projectDir;

  DatasourceGenerator({
    required this.datasourceName,
    required this.record,
    required this.projectDir,
  });

  String getRecordName() {
    return MirrorSystem.getName(reflect(record).type.simpleName);
  }

  String getRecordFileName() {
    return '${separateCapitalsWithUnderscore(getRecordName())}.dart';
  }

  String getFileName() {
    return separateCapitalsWithUnderscore(datasourceName);
  }

  String generateImports();

  String generateSignature();

  void generateDatasource();
}

class CollectionDatasourceGenerator extends DatasourceGenerator {
  final String requestName;

  CollectionDatasourceGenerator({
    required super.datasourceName,
    required super.record,
    required this.requestName,
    required super.projectDir,
  }) {
    // Generate the datasource
    generateDatasource();
  }

  String getRequestName() {
    return requestName;
  }

  String getRequestFileName() {
    return '${separateCapitalsWithUnderscore(requestName)}.dart';
  }

  @override
  String generateImports() {
    return 'import \'package:server/server.dart\';\n\n'
        'import \'package:$projectDir/generated/models/${getRecordFileName()}\';\n'
        'import \'package:$projectDir/generated/models/${getRequestFileName()}\';\n';
  }

  @override
  String generateSignature() {
    return 'abstract class $datasourceName extends CollectionDataSource<${getRequestName()}, ${getRecordName()}> {\n';
  }

  String generateGetRecords() {
    String result =
        '  @override\n  Future<List<${getRecordName()}>> getCollection(${getRequestName()} request);\n\n';
    return result;
  }

  String generateGetRecord() {
    String result =
        '  @override\n  Future<${getRecordName()}> getRecord(String id);\n';
    return result;
  }

  @override
  void generateDatasource() {
    String result = '';
    result += generateImports();
    result += generateSignature();
    result += generateGetRecords();
    result += generateGetRecord();
    result += '}\n';

    writeDatasourceDart(projectDir, getFileName(), result);
  }
}

class ListDatasourceGenerator extends DatasourceGenerator {
  ListDatasourceGenerator({
    required super.datasourceName,
    required super.record,
    required super.projectDir,
  }) {
    // Generate the datasource
    generateDatasource();
  }

  @override
  String generateImports() {
    return 'import \'package:server/server.dart\';\n\n'
        'import \'package:$projectDir/generated/models/${getRecordFileName()}\';\n';
  }

  @override
  String generateSignature() {
    return 'abstract class $datasourceName extends ListDataSource<${getRecordName()}> {\n';
  }

  String generateGetRecords() {
    String result =
        '  @override\n  Future<List<${getRecordName()}>> getList();\n\n';
    return result;
  }

  @override
  void generateDatasource() {
    String result = '';
    result += generateImports();
    result += generateSignature();
    result += generateGetRecords();
    result += '}\n';

    writeDatasourceDart(projectDir, getFileName(), result);
  }
}

enum SubmissionType { create, update }

class SubmissionDatasourceGenerator extends DatasourceGenerator {
  final String requestName;
  final SubmissionType submissionType;
  
  SubmissionDatasourceGenerator({
    required super.datasourceName,
    required super.record,
    required this.requestName,
    required this.submissionType,
    required super.projectDir,
  }) {
    // Generate the datasource
    generateDatasource();
  }

  @override
  String generateImports() {
    return 'import \'package:server/server.dart\';\n\n'
        'import \'package:$projectDir/generated/models/${getRecordFileName()}\';\n';
  }

  @override
  String generateSignature() {
    return 'abstract class $datasourceName extends SubmissionDataSource<${getRecordName()}> {\n';
  }

  String generateUpdate() {
    return '''
    @override
    Future<${getRecordName()}> submit(${getRequestName()} request) {
      return request;
    }
    ''';
  }

  String generateCreate() {
    return '''
    @override
    Future<${getRecordName()}> submit(${getRequestName()} request) {
      return request;
    }
    ''';
  }

  @override
  void generateDatasource() {
    String result = '';
    result += generateImports();
    result += generateSignature();
    if (submissionType == SubmissionType.create) {
      result += generateCreate();
    } else {
      result += generateUpdate();
    }
    result += '}\n';

    writeDatasourceDart(projectDir, getFileName(), result);
  }
}
