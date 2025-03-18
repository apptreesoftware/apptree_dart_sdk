import 'dart:mirrors';
import 'package:apptree_dart_sdk/apptree.dart';
import 'package:apptree_dart_sdk/src/constants.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';

/// Exception thrown when there's a type mismatch between a field and its ListEndpoint annotation
class ListFieldTypeMismatchException implements Exception {
  final String message;

  ListFieldTypeMismatchException(this.message);

  @override
  String toString() => 'ListFieldTypeMismatchException: $message';
}

class FieldBase {
  FieldBase? parent;
  //String? fullFieldPath;
  String? relativeFieldPath;
  bool? primaryKey;
  List<FieldBase> fields = [];
  String? fieldName;
  FieldScope? scope;

  // Reference to the list endpoint if this field is annotated with @ListField
  ListEndpoint? listEndpoint;
  String? listKeyField;

  FieldBase();

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
    return getPath(wrapped: false);
  }

  String getPath({bool wrapped = true, bool scoped = true}) {
    var path =
        parent != null
            ? parent!.getPath(wrapped: false, scoped: scoped)
            : scoped && scope != null
            ? '${scope!.name}()'
            : '';
    if (listKeyField != null) {
      path = path.extendPath(listKeyField!);
    } else if (relativeFieldPath != null) {
      path = path.extendPath(relativeFieldPath!);
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

  // String getFormPath() {
  //   String recordPath = "${getScope()}().$fullFieldPath";
  //   return recordPath;
  // }

  String getSqlPath() {
    return 'json_extract(record, "\$.${getPath(wrapped: false, scoped: false)}")';
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

class DateTimeField extends Field {
  DateTimeField();

  @override
  String getFieldType() {
    return 'DateTime';
  }

  StringField format(String format) {
    return StringField()
      ..parent = this
      ..relativeFieldPath = 'format("$format")';
  }
}

class StringField extends Field {
  StringField();

  @override
  String getFieldType() {
    return 'String';
  }

  Conditional equals(String value) {
    return StringEquals(this, value);
  }

  Contains contains(String value) {
    return Contains(this, value);
  }

  StringField toUpper() {
    return StringField()
      ..parent = this
      ..relativeFieldPath = 'toUpper()';
  }

  StringField toLower() {
    return StringField()
      ..parent = this
      ..relativeFieldPath = 'toLower()';
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

class ListField<T extends Record> extends Field {
  late T _record;
  ListField() {
    _record = instantiateRecord<T>();
  }

  @override
  String getFieldType() {
    return 'List<${getGenericFieldType()}>';
  }

  String getGenericFieldType() {
    return T.toString();
  }

  Record getRecord() {
    return instantiateRecord<T>();
  }

  Record get record {
    return _record;
  }
}

class ListScalarField<T> extends Field {
  ListScalarField();

  @override
  String getFieldType() {
    return 'List<${getGenericFieldType()}>';
  }

  String getGenericFieldType() {
    return T.toString();
  }

  IntField count() {
    return IntField()
      ..parent = this
      ..relativeFieldPath = 'count()';
  }
}

class StringListField extends ListScalarField<String> {
  StringListField();

  @override
  String getFieldType() {
    return 'List<String>';
  }

  StringField join(String separator) {
    return StringField()
      ..parent = this
      ..relativeFieldPath = 'join("$separator")';
  }
}

abstract class Record extends FieldBase {
  String? pkFieldName;

  void register() {
    scope = FieldScope.record;
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
          if (metadataInstance is ExternalField) {
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
          if (metadataInstance is PkField) {
            final fieldInstance = instanceMirror.getField(symbol).reflectee;
            if (fieldInstance is Field) {
              fieldInstance.primaryKey = true;
              pkFieldName = MirrorSystem.getName(symbol);
            }
          }
        }

        // Process annotations for nested Record instances
        final fieldInstance = instanceMirror.getField(symbol).reflectee;
        if (fieldInstance is Record) {
          fieldInstance.processAnnotations();
        }

        if (pkFieldName == null) {
          throw Exception(
            'No primary key found for record ${instanceMirror.type.simpleName}',
          );
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

          // fieldInstance.fullFieldPath =
          //     fieldInstance.parent?.parent != null
          //         ? '${fieldInstance.parent!.fullFieldPath}.$fieldName'
          //         : fieldName;

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

  Conditional contains(Field field) {
    return RecordContains(field, this);
  }
}

abstract class ExternalRecord extends Record {
  final String key;

  ExternalRecord({required this.key});
}
