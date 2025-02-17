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
