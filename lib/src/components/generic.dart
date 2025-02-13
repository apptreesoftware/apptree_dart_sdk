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
  final Field value;

  Value({required this.id, required this.value});

  Map<String, dynamic> toDict() {
    return {
      id: value.fullFieldPath,
    };
  }
}

class Values {
  final List<Value> values;

  Values({required this.values});

  Map<String, dynamic> toDict() {
    return {
      'values': values.map((value) => value.toDict()).toList(),
    };
  }
}
