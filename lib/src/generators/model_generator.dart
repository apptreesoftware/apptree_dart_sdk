import 'dart:mirrors';
import 'package:apptree_dart_sdk/apptree.dart';
import 'package:apptree_dart_sdk/src/util/file.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';
class ModelGenerator {
  final Record record;
  late String recordName;
  List<Record> records = [];
  final String projectDir;
  
  ModelGenerator({required this.record, required this.projectDir}) {

    // Register the record
    record.register();
    records.add(record);

    // Analyze the record to determine the fields and their types
    buildRecordGraph(record);

    // Generate and write the model
    generateModel();
  }

  void buildRecordGraph(Record record) {
    // Analyze the record to determine the fields and their types
    for (final field in record.fields) {
      if (field is Record) {
        buildRecordGraph(field);
        records.add(field);
      }
    }
  }
  
  String getFileName(Record record) {
    return separateCapitalsWithUnderscore(MirrorSystem.getName(reflect(record).type.simpleName));
  }

  Map<String, dynamic> analyzeRecord(Record record) {
    final result = <String, dynamic>{};

    for (final field in record.fields) {
      if (field is StringField) {
        result[field.fieldName!] = {
          "type": 'String',
          "validationType": 'String',
        };
      } else if (field is IntField) {
        result[field.fieldName!] = {"type": 'int', "validationType": 'int'};
      } else if (field is BoolField) {
        result[field.fieldName!] = {"type": 'bool', "validationType": 'bool'};
      } else if (field is Record) {
        // Use reflection to get the name of the record
        final recordName = MirrorSystem.getName(reflect(field).type.simpleName);
        result[field.fieldName!] = {
          "type": recordName,
          "validationType": "Map<String, dynamic>",
        };
      }
    }

    return result;
  }

  String generateImports() {
    return 'import \'package:server/server.dart\';\n\n';
  }

  String generateSignature(String recordName, Map<String, dynamic> recordMap) {
    String result = '';
    result += 'class $recordName {\n';
    for (final entry in recordMap.entries) {
      result += '  final ${entry.value["type"]} ${entry.key};\n';
    }
    result += '\n';
    return result;
  }

  String generateInit(String recordName, Map<String, dynamic> recordMap) {
    String result = '';
    result +=
        '  $recordName({${recordMap.entries.map((e) => 'required this.${e.key}').join(', ')}});\n';
    result += '\n';
    return result;
  }

  String generateFromJson(String recordName, Map<String, dynamic> recordMap) {
    String result = '';
    result += '  factory $recordName.fromJson(Map<String, dynamic> json) {\n';
    result += '    final invalidProperties = <String, String>{};\n';
    for (final entry in recordMap.entries) {
      result +=
          '    final ${entry.key} = JsonUtils.validateField<${entry.value["validationType"]}>(fieldName: \'${entry.key}\', value: json[\'${entry.key}\'], invalidProperties: invalidProperties);\n\n';
    }
    result +=
        '    JsonUtils.validateAndThrowIfInvalid(modelType: $recordName, invalidProperties: invalidProperties);\n\n';
    // Build the constructor, if a field has a validaitonType of Map<String, dynamic> then it is a Record and we need to call the fromJson method
    result +=
        '    return $recordName(${recordMap.entries.map((e) => '${e.key}: ${e.value["validationType"] == "Map<String, dynamic>" ? "${e.value["type"]}.fromJson(${e.key}!)" : '${e.key}!'}').join(', ')});\n';
    result += '  }\n';
    return result;
  }

  void generateModel() {
    // Generate the model
    String result = '';
    result += generateImports();
    for (final record in records) {
      final recordMap = analyzeRecord(record);
      final recordName = MirrorSystem.getName(reflect(record).type.simpleName);
      result += generateSignature(recordName, recordMap);
      result += generateInit(recordName, recordMap);
      result += generateFromJson(recordName, recordMap);
      result += '}\n\n';
    }

    writeModelDart(projectDir, getFileName(record), result);
  }
}
