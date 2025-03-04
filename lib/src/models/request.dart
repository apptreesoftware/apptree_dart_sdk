import 'dart:mirrors';

import 'package:apptree_dart_sdk/src/util/object_extensions.dart';

abstract class Request {

  void register() {}

  Map<String, dynamic> toJson() {
    return asMap(this);
  }

  Map<String, dynamic> getFieldTypes() {
    final instanceMirror = reflect(this);
    final Map<String, dynamic> dataDict = {};
    instanceMirror.type.declarations.forEach((symbol, declaration) {
      if (declaration is VariableMirror && !declaration.isStatic) {
        final fieldInstance = instanceMirror.getField(symbol).reflectee;
        // if fieldInstance is String, add "string" to dataDict for the field name
        if (fieldInstance.runtimeType == String) {
          dataDict[MirrorSystem.getName(symbol)] = 'String';
        }
        else if (fieldInstance.runtimeType == int) {
          dataDict[MirrorSystem.getName(symbol)] = 'int';
        }
        else if (fieldInstance.runtimeType == bool) {
          dataDict[MirrorSystem.getName(symbol)] = 'bool';
        }
        else if (fieldInstance.runtimeType == double) {
          dataDict[MirrorSystem.getName(symbol)] = 'double';
        }
        else if (fieldInstance.runtimeType == DateTime) {
          dataDict[MirrorSystem.getName(symbol)] = 'datetime';
        } else {
          throw Exception(
            'Request: Unsupported field type: ${fieldInstance.runtimeType} for request class ${instanceMirror.type.simpleName}',
          );
        }
      }
    });
    return dataDict;
  }

  Map<String, dynamic> toModelDict() {
    return getFieldTypes();
  }
}
