import 'package:apptree_dart_sdk/src/model/record.dart';

class Collection {
  final String url;

  Collection({required this.url});

  Map<String, dynamic> toDict() {
    return {
      'url': url,
    };
  }
}

class Value {
  final String id;
  final List<Field> value;

  Value({required this.id, required this.value});

  Map<String, dynamic> toDict() {
    return {
      id: value.map((field) => field.fullFieldPath).toList(),
    };
  }
}
