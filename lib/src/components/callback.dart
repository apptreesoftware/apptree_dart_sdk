import 'package:apptree_dart_sdk/src/models/request.dart';

class OnLoad {
  final String collection;
  final String url;
  final Request? request;

  OnLoad({required this.collection, required this.url, this.request});

  List<Map<String, dynamic>> toDict() {
    Map<String, dynamic> dataDict = request?.toDict() ?? {};
    dataDict['collection'] = collection;

    List<Map<String, dynamic>> features = [
      {'url': url, 'data': dataDict},
    ];
    return features;
  }
}

// class OnItemSelectedForm {
//   final Builder builder;
//   final String primaryKey;

//   OnItemSelectedForm({required this.builder, required this.primaryKey});

//   List<Map<String, dynamic>> toDict() {
//     final feature = builder.build();
//     return [
//       {
//         'navigateTo': {"id": feature.id, "pkField": primaryKey},
//       },
//     ];
//   }
// }
