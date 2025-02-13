import 'package:apptree_dart_sdk/src/components/generic.dart';

class TopAccessoryView {
  final String id;
  final List<Value> values;

  TopAccessoryView({required this.id, required this.values});

  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'values': values.map((value) => value.toDict()).toList(),
    };
  }
}
