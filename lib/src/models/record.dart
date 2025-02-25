import 'dart:mirrors';
import 'package:apptree_dart_sdk/src/constants.dart';
import 'package:apptree_dart_sdk/src/models/expression.dart';

class FieldBase {
  FieldScope scope = FieldScope.record;
  Record? parent;
  String? fullFieldPath;
  String? relativeFieldPath;
  bool? primaryKey;
  String? value;

  FieldBase({this.scope = FieldScope.record});

  String getScope() {
    return scope.name;
  }

  String getPath() {
    String prefix = '\$';
    String recordPath = "$prefix{${getScope()}().$fullFieldPath}";
    return recordPath;
  }

  String getFormPath() {
    String recordPath = "${getScope()}().$fullFieldPath";
    return recordPath;
  }
}

abstract class Field extends FieldBase {
  Field({super.scope = FieldScope.record});

  String getFieldType();

  ContainsExpression contains(String value) {
    return ContainsExpression(field1: this, operator: Contains(), value: value);
  }

  String length() {
    return '${getPath()}.length()';
  }
}

class IntField extends Field {
  IntField({super.scope = FieldScope.record});

  @override
  String getFieldType() {
    return 'int';
  }
}

class StringField extends Field {
  StringField({super.scope = FieldScope.record});

  @override
  String getFieldType() {
    return 'string';
  }
}

class BoolField extends Field {
  bool falseValue = false;

  BoolField({
    super.scope = FieldScope.record,
  });

  @override
  String getFieldType() {
    return 'bool';
  }
}

abstract class Record extends FieldBase {
  void register() {
    buildMemberGraph();
    buildFieldPaths();
  }

  void buildMemberGraph() {
    final instanceMirror = reflect(this);
    //Loop through all fields and assign a metadata object to each field that it is a member of TestClass. If the field is a subclass of Record, recursively build the member graph for the subclass.

    instanceMirror.type.declarations.forEach((symbol, declaration) {
      if (declaration is VariableMirror && !declaration.isStatic) {
        final fieldInstance = instanceMirror.getField(symbol).reflectee;
        // Assign metadata indicating that this field is a member of the current instance.
        if (fieldInstance is Field) {
          reflect(fieldInstance).setField(const Symbol('parent'), this);
        }
        // If the field is a Record, recursively build its member graph.
        if (fieldInstance is Record) {
          reflect(fieldInstance).setField(const Symbol('parent'), this);
          fieldInstance.buildMemberGraph();
        }
      }
    });
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
          final fieldName = MirrorSystem.getName(symbol);
          fieldInstance.fullFieldPath = fieldInstance.parent?.parent != null
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
