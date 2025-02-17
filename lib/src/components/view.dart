import 'package:apptree_dart_sdk/src/components/generic.dart';

class TopAccessoryView {
  final String id;
  final Map<String, Value> values;

  TopAccessoryView({required this.id, required this.values});

  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'values': values.map((key, value) => MapEntry(key, value.getValue())),
    };
  }
}
