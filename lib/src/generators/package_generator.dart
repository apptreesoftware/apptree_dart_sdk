import 'package:apptree_dart_sdk/apptree.dart';
import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:apptree_dart_sdk/src/util/dir.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';
import 'dart:mirrors';

class PackageGenerator {
  final String routeName;
  final String projectDir;
  final Record record;
  final Request request;
  final String datasourceName;

  PackageGenerator({
    required this.routeName,
    required this.projectDir,
    required this.record,
    required this.request,
    required this.datasourceName,
  }) {
    generateExport();
    generateInit();
    generateApp();
    generateServer();
    copyBoilerplate(projectDir);
    generatePubspec();
  }

  String getRecordFileName() {
    return '${separateCapitalsWithUnderscore(MirrorSystem.getName(reflect(record).type.simpleName))}.dart';
  }

  String getRecordName() {
    return MirrorSystem.getName(reflect(record).type.simpleName);
  }

  String getRequestFileName() {
    return '${separateCapitalsWithUnderscore(MirrorSystem.getName(reflect(request).type.simpleName))}.dart';
  }

  String getRequestName() {
    return MirrorSystem.getName(reflect(request).type.simpleName);
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
        'import \'generated.dart\';\n';
  }

  void generateInit() {
    String result = '';
    result += generateInitImport();
    result +=
        'void registerSamples(AppBase app) {\n'
        '  app.register(Sample$datasourceName());\n'
        '}\n';

    writeGeneratedDart(projectDir, 'init', result);
  }

  String generateAppImport() {
    return 'import \'package:server/server.dart\';\n'
        'import \'generated/generated.dart\';\n';
  }

  void generateApp() {
    String result = '';
    result += generateAppImport();
    result += 'class App extends AppBase {\n';
    result += '  App();\n\n';
    result += '  init() {\n';
    result += '    registerSamples(this);\n';
    result += '    register<$datasourceName>(Sample$datasourceName());\n';
    result += '  }\n';
    result += '}\n';

    writeAppDart(projectDir, 'app', result);
  }

  // TODO: Needs to account for multiple collections
  String generateAddCollectionRoute() {
    String result = '';
    result +=
        'server.addCollectionRoute<${getRequestName()}, $datasourceName, ${getRecordName()}>(\n';
    result += '   \'/$routeName\', \n';
    result += '   ${getRequestName()}.fromJson, \n';
    result += ' );\n';

    return result;
  }

  String generateServerImport() {
    return 'import \'package:server/server.dart\';\n'
        'import \'package:example_connector/app.dart\';\n'
        'import \'package:example_connector/generated/generated.dart\';\n';
  }

  void generateServer() {
    String result = '';
    result += generateServerImport();
    result += 'void main() {\n';
    result += '  var app = App();\n';
    result += '  app.init();\n\n';
    result += '  var server = Server<App>(app);\n';
    result += '  ${generateAddCollectionRoute()}\n';
    result += '  server.start();\n';
    result += '}\n';

    writeServerDart(projectDir, 'server', result);
  }

  void generatePubspec() async {
    final pubspec = await readPubspec(projectDir);
    final newPubspec = pubspec.replaceAll('PROJECT_NAME', projectDir);
    writePubspec(projectDir, newPubspec);
  }
}
