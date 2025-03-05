import 'package:apptree_dart_sdk/apptree.dart';
import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';
import 'dart:mirrors';

class PackageGenerator {
  final String projectDir;
  final Record record;
  final Request request;
  final String datasourceName;

  PackageGenerator({
    required this.projectDir,
    required this.record,
    required this.request,
    required this.datasourceName,
  }) {
    generateExport();
    generateInit();
  }

  String getRecordFileName() {
    return '${separateCapitalsWithUnderscore(MirrorSystem.getName(reflect(record).type.simpleName))}.dart';
  }

  String getRequestFileName() {
    return '${separateCapitalsWithUnderscore(MirrorSystem.getName(reflect(request).type.simpleName))}.dart';
  }

  String getDatasourceFileName() {
    return '${separateCapitalsWithUnderscore(datasourceName)}';
  }

  void generateExport() {
    String result =
        'export \'datasources/${getDatasourceFileName()}.dart\';\n'
        'export \'models/${getRecordFileName()}\';\n'
        'export \'models/${getRequestFileName()}\';\n'
        'export \'samples/${getDatasourceFileName()}_sample.dart\';\n'
        'export \'init.dart\';\n';

    writeGeneratedDart(projectDir, 'generated', result);
  }

  String generateInitImport() {
    return 'import \'package:server/server.dart\';\n'
        'import \'generated.dart\';\n\n';
  }

  void generateInit() {
    String result = '';
    result += generateInitImport();
    result +=
        'void registerSamples(AppBase app) {\n'
        '  app.register($datasourceName());\n'
        '}\n';

    writeGeneratedDart(projectDir, 'init', result);
  }
}
