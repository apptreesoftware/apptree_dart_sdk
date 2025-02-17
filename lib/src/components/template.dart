import 'package:apptree_dart_sdk/src/components/generic.dart';

class Template {
  final String id;
  final Values values;

  Template({required this.id, required this.values});

  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'values': values.toDict()
    };
  }
}