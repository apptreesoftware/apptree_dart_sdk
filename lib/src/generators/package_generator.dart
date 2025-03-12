import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:apptree_dart_sdk/src/util/dir.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';

enum ConnectorType { collection, list, submission }

class ConnectorItem {
  String recordName;
  String datasourceName;
  String? requestName;
  ConnectorType type;

  ConnectorItem({
    required this.recordName,
    required this.datasourceName,
    this.requestName,
    required this.type,
  });
}

class PackageGenerator {
  final String projectDir;
  final List<ConnectorItem> connectors;

  PackageGenerator({required this.projectDir, required this.connectors}) {
    generateExport();
    generateInit();
    generateApp();
    // generateServer();
    copyBoilerplate(projectDir);
    generatePubspec();
  }

  String getDataSourceFileName(ConnectorItem connector) {
    return separateCapitalsWithUnderscore(connector.datasourceName);
  }

  String getRequestFileName(ConnectorItem connector) {
    return separateCapitalsWithUnderscore(connector.requestName ?? '');
  }

  String getSampleFileName(ConnectorItem connector) {
    return separateCapitalsWithUnderscore(connector.datasourceName);
  }

  String getModelFileName(ConnectorItem connector) {
    return separateCapitalsWithUnderscore(connector.recordName);
  }

  String getDataSourceExports(List<ConnectorItem> connectors) {
    return connectors
        .map(
          (connector) =>
              'export \'datasources/${getDataSourceFileName(connector)}.dart\';\n',
        )
        .join();
  }

  String getModelExports(List<ConnectorItem> connectors) {
    final uniqueModelFileNames =
        connectors.map((connector) => getModelFileName(connector)).toSet();
    return uniqueModelFileNames
        .map((fileName) => 'export \'models/$fileName.dart\';\n')
        .join();
  }

  String getRequestExports(List<ConnectorItem> connectors) {
    return connectors
        .where((connector) => connector.type != ConnectorType.list)
        .map(
          (connector) =>
              'export \'models/${getRequestFileName(connector)}.dart\';\n',
        )
        .join();
  }

  String getSampleExports(List<ConnectorItem> connectors) {
    return connectors
        .map(
          (connector) =>
              'export \'samples/${getSampleFileName(connector)}_sample.dart\';\n',
        )
        .join();
  }

  void generateExport() {
    String result =
        '${getDataSourceExports(connectors)}\n'
        '${getModelExports(connectors)}\n'
        '${getRequestExports(connectors)}\n'
        '${getSampleExports(connectors)}\n'
        'export \'init.dart\';\n';

    writeGeneratedDart(projectDir, 'generated', result);
  }

  String generateInitImport() {
    return 'import \'package:server/server.dart\';\n'
        'import \'generated.dart\';\n';
  }

  String generateInitRegister(List<ConnectorItem> connectors) {
    return connectors
        .map(
          (connector) =>
              '  app.register(Sample${connector.datasourceName}());\n',
        )
        .join();
  }

  void generateInit() {
    String result = '';
    result += generateInitImport();
    result +=
        'void registerSamples(AppBase app) {\n'
        '${generateInitRegister(connectors)}\n'
        '}\n';

    writeGeneratedDart(projectDir, 'init', result);
  }

  String generateAppImport() {
    return 'import \'package:server/server.dart\';\n'
        'import \'generated/generated.dart\';\n';
  }

  String generateAppRegister(List<ConnectorItem> connectors) {
    return connectors
        .map(
          (connector) =>
              '    register<${connector.datasourceName}>(Sample${connector.datasourceName}());\n',
        )
        .join();
  }

  void generateApp() {
    String result = '';
    result += generateAppImport();
    result += 'class App extends AppBase {\n';
    result += '  App();\n\n';
    result += '  init() {\n';
    result += '    registerSamples(this);\n';
    result += '${generateAppRegister(connectors)}\n';
    result += '  }\n';
    result += '}\n';

    writeAppDart(projectDir, 'app', result);
  }

  String addRoute(ConnectorItem connector) {
    switch (connector.type) {
      case ConnectorType.collection:
        return 'server.addCollectionRoute<${connector.requestName}, ${connector.datasourceName}, ${connector.recordName}>(\n';
      case ConnectorType.list:
        return "Implement list route";
      case ConnectorType.submission:
        return "Implement submission route";
    }
  }

  String generateAddCollectionRoutes(List<ConnectorItem> connectors) {
    String result = '';
    for (var connector in connectors) {
      result += addRoute(connector);
    }
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
    result += '  ${generateAddCollectionRoutes(connectors)}\n';
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
