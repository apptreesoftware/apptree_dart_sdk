import 'package:apptree_dart_sdk/apptree.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'package:apptree_dart_sdk/src/util/strings.dart';

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

  R get record {
    return instantiateRecord();
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
    return YamlWriter().write(getModelDict());
  }

  String getRouteName() {
    return seperateCapitalsWithHyphens(id);
  }

  String getDatasourceName() {
    return '${id}Collection';
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
