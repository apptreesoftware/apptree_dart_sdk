import 'package:apptree_dart_sdk/src/models/record.dart';

class Collection {
  final String url;
  final String collection;

  Collection({required this.url, required this.collection});

  Map<String, dynamic> toDict() {
    return {
      'url': url,
      'data': { 
        'collection': collection,
      },
    };
  }
}

class Value {
  final Field value;

  Value({required this.value});

  String getValue() {
    return value.getRecordPath();
  }
}

class Values {
  final Map<String, Value> values;

  Values({required this.values});

  Map<String, dynamic> toDict() {
    return values.map((key, value) => MapEntry(key, value.getValue()));
  }
}
