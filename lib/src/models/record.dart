import 'dart:mirrors';
import 'package:apptree_dart_sdk/apptree.dart';
import 'package:apptree_dart_sdk/src/constants.dart';

/// Exception thrown when there's a type mismatch between a field and its ListEndpoint annotation
class ListFieldTypeMismatchException implements Exception {
  final String message;

  ListFieldTypeMismatchException(this.message);

  @override
  String toString() => 'ListFieldTypeMismatchException: $message';
}

class FieldBase {
  Record? parent;
  String? fullFieldPath;
  String? relativeFieldPath;
  bool? primaryKey;
  List<FieldBase> fields = [];
  String? fieldName;

  // Reference to the list endpoint if this field is annotated with @ListField
  ListEndpoint? listEndpoint;
  String? listKeyField;

  FieldBase();

  FieldScope get scope {
    return parent?.scope ?? FieldScope.record;
  }

  String getScope() {
    return scope.name;
  }

  String get value {
    return getPath(wrapped: false);
  }

  String get bindingFieldPath {
    var parentDepth = 0;
    var currentParent = parent;
    while (currentParent != null) {
      parentDepth++;
      currentParent = currentParent.parent;
    }
    if (parentDepth > 1) {
      throw Exception('Can not bind to a nested field');
    }
    return fullFieldPath!;
  }

  String getPath({bool wrapped = true}) {
    var path =
        parent != null ? parent!.getPath(wrapped: false) : '${scope.name}()';
    if (listKeyField != null) {
      path = '$path.$listKeyField';
    } else if (relativeFieldPath != null) {
      path = '$path.$relativeFieldPath';
    }

    if (listEndpoint != null) {
      path = 'getListItem("${listEndpoint!.id}", $path)';
    }
    //path = '';
    if (wrapped) {
      path = '\${$path}';
    }
    return path;
  }

  String getFormPath() {
    String recordPath = "${getScope()}().$fullFieldPath";
    return recordPath;
  }

  @override
  String toString() {
    return getPath(wrapped: true);
  }
}

abstract class Field extends FieldBase {
  Field();

  String getFieldType();

  String length() {
    return '${getPath()}.length()';
  }
}

class IntField extends Field {
  IntField();

  @override
  String getFieldType() {
    return 'int';
  }

  Conditional equals(int value) {
    return IntEquals(this, value);
  }
}

class FloatField extends Field {
  FloatField();

  @override
  String getFieldType() {
    return 'float';
  }
}

class StringField extends Field {
  StringField();

  @override
  String getFieldType() {
    return 'string';
  }

  Conditional equals(String value) {
    return StringEquals(this, value);
  }

  Contains contains(String value) {
    return Contains(this, value);
  }

  StringField toUpper() {
    fullFieldPath = '$fullFieldPath.toUpper()';
    return this;
  }

  StringField toLower() {
    fullFieldPath = '$fullFieldPath.toLower()';
    return this;
  }

  dynamic toJson() {
    return getPath(wrapped: true);
  }
}

class BoolField extends Field {
  bool falseValue = false;

  BoolField();

  @override
  String getFieldType() {
    return 'bool';
  }

  Conditional equals(bool value) {
    return BoolEquals(this, value);
  }
}

abstract class ListRecord extends Record {
  final String key;

  ListRecord({required this.key});
}

abstract class Record extends FieldBase {
  void register() {
    buildMemberGraph();
    processAnnotations();
    buildFieldPaths();
  }

  void buildMemberGraph() {
    final instanceMirror = reflect(this);
    //Loop through all fields and assign a metadata object to each field that it is a member of TestClass. If the field is a subclass of Record, recursively build the member graph for the subclass.

    instanceMirror.type.declarations.forEach((symbol, declaration) {
      if (declaration is VariableMirror && !declaration.isStatic) {
        final fieldInstance = instanceMirror.getField(symbol).reflectee;
        final fieldName = MirrorSystem.getName(symbol);
        // Assign metadata indicating that this field is a member of the current instance.
        if (fieldInstance is Field) {
          reflect(fieldInstance).setField(const Symbol('parent'), this);
          fields.add(fieldInstance);
          fieldInstance.fieldName = fieldName;
        }
        // If the field is a Record, recursively build its member graph.
        if (fieldInstance is Record) {
          reflect(fieldInstance).setField(const Symbol('parent'), this);
          fieldInstance.buildMemberGraph();
          fields.add(fieldInstance);
          fieldInstance.fieldName = fieldName;
        }
      }
    });
  }

  void processAnnotations() {
    final instanceMirror = reflect(this);

    instanceMirror.type.declarations.forEach((symbol, declaration) {
      if (declaration is VariableMirror && !declaration.isStatic) {
        // Look for ListField annotations on class members
        for (final metadata in declaration.metadata) {
          final metadataInstance = metadata.reflectee;
          if (metadataInstance is ListField) {
            final fieldInstance = instanceMirror.getField(symbol).reflectee;
            if (fieldInstance is FieldBase) {
              // Apply the ListField annotation info to the field
              reflect(fieldInstance).setField(
                const Symbol('listEndpoint'),
                metadataInstance.endpoint,
              );
              reflect(
                fieldInstance,
              ).setField(const Symbol('listKeyField'), metadataInstance.key);

              // Type checking: Verify the field type matches the ListEndpoint's record type
              if (fieldInstance is Record) {
                _verifyFieldTypeMatchesEndpoint(
                  fieldName: MirrorSystem.getName(symbol),
                  field: fieldInstance,
                  endpoint: metadataInstance.endpoint,
                );
              }
            }
          }
        }

        // Process annotations for nested Record instances
        final fieldInstance = instanceMirror.getField(symbol).reflectee;
        if (fieldInstance is Record) {
          fieldInstance.processAnnotations();
        }
      }
    });
  }

  /// Verifies that a field's type matches the expected Record type from the ListEndpoint
  void _verifyFieldTypeMatchesEndpoint({
    required String fieldName,
    required Record field,
    required ListEndpoint endpoint,
  }) {
    final endpointMirror = reflect(endpoint).type;

    if (endpointMirror.typeArguments.length >= 2) {
      final expectedRecordType = endpointMirror.typeArguments[1];
      final actualFieldType = reflect(field).type;

      // Check if the field's type is compatible with the expected record type
      if (!actualFieldType.isSubtypeOf(expectedRecordType)) {
        final expectedTypeName = MirrorSystem.getName(
          expectedRecordType.simpleName,
        );
        final actualTypeName = MirrorSystem.getName(actualFieldType.simpleName);

        final errorMsg =
            'Type mismatch error: Field "$fieldName" has type $actualTypeName '
            'but should be $expectedTypeName to match ListEndpoint<_, $expectedTypeName>';

        // In development mode, throw an exception to make the error obvious
        assert(() {
          throw ListFieldTypeMismatchException(errorMsg);
        }());

        // In production, log a warning
        print('WARNING: $errorMsg');
      }
    }
  }

  void buildFieldPaths() {
    final instanceMirror = reflect(this);
    /*Loop through all the fields and assign the full and relative field paths to each field. The full path is the path from the root of the object graph to the field. The relative path is the path from the parent of the field to the field.
    If the field is a Record, recursively build the field paths for the subclass.
    */

    instanceMirror.type.declarations.forEach((symbol, declaration) {
      if (declaration is VariableMirror && !declaration.isStatic) {
        final fieldInstance = instanceMirror.getField(symbol).reflectee;
        if (fieldInstance is FieldBase) {
          var fieldName = MirrorSystem.getName(symbol);
          if (fieldInstance.listKeyField != null) {
            fieldName = '${fieldInstance.listKeyField}';
          }

          fieldInstance.fullFieldPath =
              fieldInstance.parent?.parent != null
                  ? '${fieldInstance.parent!.fullFieldPath}.$fieldName'
                  : fieldName;

          fieldInstance.relativeFieldPath = fieldName;
          if (fieldInstance is Record) {
            fieldInstance.buildFieldPaths();
          }
        }
      }
    });
  }

  Map<String, dynamic> getFieldTypes() {
    final instanceMirror = reflect(this);
    Map<String, dynamic> fields = {};
    instanceMirror.type.declarations.forEach((symbol, declaration) {
      if (declaration is VariableMirror && !declaration.isStatic) {
        final fieldInstance = instanceMirror.getField(symbol).reflectee;
        if (fieldInstance is Field) {
          fields[fieldInstance.relativeFieldPath ?? 'NULL'] =
              fieldInstance.getFieldType();
        }
        if (fieldInstance is Record) {
          fields[fieldInstance.relativeFieldPath ?? 'NULL'] =
              fieldInstance.getFieldTypes();
        }
      }
    });
    return fields;
  }

  Map<String, dynamic> toModelDict() {
    return {
      MirrorSystem.getName(reflect(this).type.simpleName): getFieldTypes(),
    };
  }
}
