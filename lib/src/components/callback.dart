import 'package:apptree_dart_sdk/src/components/generic.dart';
import 'package:apptree_dart_sdk/src/model/builder.dart';

class OnLoad {
  final String? executeWhen;
  final Collection? collection;

  OnLoad({this.executeWhen, this.collection});

  Map<String, dynamic> toDict() {
    return {
      'execute_when': executeWhen,
      'collection': collection?.toDict(),
    };
  }
}

class OnItemSelected {
  final Builder builder;

  OnItemSelected({required this.builder});

  Map<String, dynamic> toDict() {
    final feature = builder.build();
    return {
      'onItemSelected': {
        'navigateTo': {
          "id": feature.id,
        }
      }
    };
  }
}

class OnItemSelectedForm {
  final Builder builder;
  
  OnItemSelectedForm({required this.builder});

  List<Map<String, dynamic>> toDict() {
    final feature = builder.build();
    return [
      {
        'onItemSelected': {
          'navigateTo': {
            "id": feature.id,
          }
        }
      }
    ];
  }
}
