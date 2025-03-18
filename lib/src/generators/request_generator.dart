import 'package:apptree_dart_sdk/src/util/strings.dart';
import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:apptree_dart_sdk/src/generators/package_generator.dart';

class RequestGenerator {
  final String requestName;
  final Map<String, dynamic> requestMap;
  final String projectDir;
  final ConnectorType type;

  RequestGenerator({
    required this.requestName,
    required this.requestMap,
    required this.projectDir,
    required this.type,
  }) {
    generateRequest();
  }

  String getFileName() {
    return separateCapitalsWithUnderscore(requestName);
  }

  String generateImports() {
    return 'import \'package:server/server.dart\';\n\n';
  }

  String generateSignature(
    String requestName,
    Map<String, dynamic> requestMap,
  ) {
    String result = '';
    if (type == ConnectorType.collection) {
      result += 'class $requestName extends CollectionRequest {\n';
    } else {
      result += 'class $requestName extends BaseRequest {\n';
    }
    for (final entry in requestMap.entries) {
      result += '  final ${entry.value} ${entry.key};\n';
    }
    result += '\n';
    return result;
  }

  String generateInit(String requestName, Map<String, dynamic> requestMap) {
    String result = '';
    if (type == ConnectorType.collection) {
      result +=
          '  $requestName({${requestMap.entries.map((e) => 'required this.${e.key}').join(', ')}, required super.app, required super.username, required super.collection});\n';
    } else {
      result +=
          '  $requestName({${requestMap.entries.map((e) => 'required this.${e.key}').join(', ')}, required super.app, required super.username });\n';
    }
    result += '\n';
    return result;
  }

  String generateFromJson(String requestName, Map<String, dynamic> requestMap) {
    String result = '';
    result += '  factory $requestName.fromJson(Map<String, dynamic> json) {\n';
    result += '    final invalidProperties = <String, String>{};\n';
    for (final entry in requestMap.entries) {
      result +=
          '    final ${entry.key} = JsonUtils.validateField<${entry.value}>(fieldName: \'${entry.key}\', value: json[\'${entry.key}\'], invalidProperties: invalidProperties);\n';
    }
    if (type == ConnectorType.collection) {
      result += "    final app = JsonUtils.validateField<String>(fieldName: 'app', value: json['app'], invalidProperties: invalidProperties);\n";
      result += "    final username = JsonUtils.validateField<String>(fieldName: 'username', value: json['username'], invalidProperties: invalidProperties);\n";
      result += "    final collection = JsonUtils.validateField<String>(fieldName: 'collection', value: json['collection'], invalidProperties: invalidProperties);\n\n";
    }
    if (type == ConnectorType.submission) {
      result += "    final app = JsonUtils.validateField<String>(fieldName: 'app', value: json['app'], invalidProperties: invalidProperties);\n";
      result += "    final username = JsonUtils.validateField<String>(fieldName: 'username', value: json['username'], invalidProperties: invalidProperties);\n\n";
    }
    result +=
        '    JsonUtils.validateAndThrowIfInvalid(modelType: $requestName, invalidProperties: invalidProperties);\n';
    if (type == ConnectorType.collection) {
      result +=
          '    return $requestName(${requestMap.entries.map((e) => '${e.key}: ${e.key}!').join(', ')}, app: app!, username: username!, collection: collection!);\n';
    } else {
      result +=
          '    return $requestName(${requestMap.entries.map((e) => '${e.key}: ${e.key}!').join(', ')}, app: app!, username: username!);\n';
    }
    result += '  }\n';
    result += '\n';
    return result;
  }

  String generateToJson(String requestName, Map<String, dynamic> requestMap) {
    String result = '';
    result += '  Map<String, dynamic> toJson() {\n';
    result +=
        '    return {${requestMap.entries.map((e) => '\'${e.key}\': ${e.key}').join(', ')}};\n';
    result += '  }\n';
    return result;
  }

  void generateRequest() {
    // Generate the request
    String result = '';
    result += generateImports();
    result += generateSignature(requestName, requestMap);
    result += generateInit(requestName, requestMap);
    result += generateFromJson(requestName, requestMap);
    result += generateToJson(requestName, requestMap);
    result += '}\n';

    writeModelDart(projectDir, getFileName(), result);
  }
}
