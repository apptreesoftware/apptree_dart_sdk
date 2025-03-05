import 'package:apptree_dart_sdk/apptree.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'dart:mirrors';

abstract class SubmissionEndpoint<I extends Request, R extends Record> {
  final String id;
  final I? request;
  final R record;

  const SubmissionEndpoint({
    required this.id,
    this.request,
    required this.record,
  });
}

abstract class ListEndpoint<I extends Request, R extends Record> {
  final String id;

  const ListEndpoint({required this.id});

  Map<String, dynamic> buildRequest(I request) {
    return {"url": '{{environment.url}}/list/$id', "data": request.toJson()};
  }
}

abstract class CollectionEndpoint<I extends Request, R extends Record> {
  final String id;

  const CollectionEndpoint({required this.id});

  R get record {
    return instantiateRecord();
  }

  Map<String, dynamic> buildRequest(I request) {
    return {"url": '{{environment.url}}/$id', "data": request.toJson()};
  }

  Map<String, dynamic> getModelDict() {
    return {
      id: {
        "RequestParams": describeRequest<I>(),
        "Model": record.toModelDict(),
      },
    };
  }

  String getModelYaml() {
    return YAMLWriter().write(getModelDict());
  }

  String getDataSourceInterface() {
    var recordType = reflect(this.record).reflectee.runtimeType.toString();
    var requestName = getRequestName<I>();
    return '''
      Future<List<$recordType>> getRecords($requestName request) async {
        // TODO: implement getRecords
      }
      and
      $recordType getRecord(String id) async {
        // TODO: implement getRecord
      }
    ''';
  }
}

class CollectionEndpointRequest {
  String url;
  String collection;
  Map<String, dynamic> requestData;

  CollectionEndpointRequest({
    required this.url,
    required this.collection,
    required this.requestData,
  });
}
