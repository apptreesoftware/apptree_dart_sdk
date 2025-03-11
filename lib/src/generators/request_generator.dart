import 'package:apptree_dart_sdk/src/util/strings.dart';
import 'package:apptree_dart_sdk/src/util/file.dart';

class RequestGenerator {
  final String requestName;
  final Map<String, dynamic> requestMap;
  final String projectDir;

  RequestGenerator({
    required this.requestName,
    required this.requestMap,
    required this.projectDir,
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
    result += 'class $requestName {\n';
    for (final entry in requestMap.entries) {
      result += '  final ${entry.value} ${entry.key};\n';
    }
    result += '\n';
    return result;
  }

  String generateInit(String requestName, Map<String, dynamic> requestMap) {
    String result = '';
    result +=
        '  $requestName({${requestMap.entries.map((e) => 'required this.${e.key}').join(', ')}});\n';
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
    result +=
        '    JsonUtils.validateAndThrowIfInvalid(modelType: $requestName, invalidProperties: invalidProperties);\n';
    result +=
        '    return $requestName(${requestMap.entries.map((e) => '${e.key}: ${e.key}!').join(', ')});\n';
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
    result += generateSignature(
      requestName,
      requestMap,
    );
    result += generateInit(
      requestName,
      requestMap,
    );
    result += generateFromJson(
      requestName,
      requestMap,
    );
    result += generateToJson(
      requestName,
      requestMap,
    );
    result += '}\n';

    writeModelDart(projectDir, getFileName(), result);
  }
}
