import 'package:apptree_dart_sdk/src/constants.dart';

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
}