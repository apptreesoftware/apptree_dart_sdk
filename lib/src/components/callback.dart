import 'package:apptree_dart_sdk/src/model/builder.dart';

class OnLoad {
  final String collection;
  final String url;

  OnLoad({required this.collection, required this.url});

  List<Map<String, dynamic>> toDict() {
    return [
      {
        'url': url,
        'data': {'collection': collection},
      }
    ];
  }
}

class OnItemSelected {
  final Builder builder;
  OnItemSelected({required this.builder});


  Map<String, dynamic> toDict() {
    final feature = builder.build();
      return {
        'navigateTo': {
          "id": feature.id,
        }
      };
    }
}

class OnItemSelectedForm {
  final Builder builder;
  final String primaryKey;
  
  OnItemSelectedForm({required this.builder, required this.primaryKey});

  List<Map<String, dynamic>> toDict() {
    final feature = builder.build();
    return [  
        {
        'navigateTo': {
          "id": feature.id,
          "pkField": primaryKey,
        }
      }
    ];
  }
}
