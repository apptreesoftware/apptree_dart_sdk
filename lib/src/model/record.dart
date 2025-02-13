import 'dart:mirrors';

class FieldBase {
  Record? parent;
  String? fullFieldPath;
  String? relativeFieldPath;
}

class Field extends FieldBase {}

class IntField extends Field {}

class StringField extends Field {}

class BoolField extends Field {}

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
}
