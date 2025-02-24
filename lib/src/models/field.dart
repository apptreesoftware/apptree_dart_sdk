import 'package:apptree_dart_sdk/src/constants.dart';
import 'package:apptree_dart_sdk/src/models/base.dart';

abstract class Field extends FieldBase {
  Field({super.scope = FieldScope.record});

  String getFieldType();
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

  BoolField({super.scope = FieldScope.record,});

  @override
  String getFieldType() {
    return 'bool';
  }
  
}