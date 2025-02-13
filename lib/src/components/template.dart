import 'package:apptree_dart_sdk/src/components/generic.dart';

class Template {
  final String id;
  final List<Value> values;  

  Template({required this.id, required this.values});

  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'values': values.map((value) => value.toDict()).toList(),
    };
  }
}