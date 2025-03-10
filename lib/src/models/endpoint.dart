import 'package:apptree_dart_sdk/apptree.dart';
import 'package:yaml_writer/yaml_writer.dart';


class Endpoint<R extends Record> {
  final String id;

  const Endpoint({required this.id});
  
  R get record {
    return instantiateRecord();
  }
  
}

abstract class ListEndpoint<I extends Request, R extends Record> extends Endpoint<R> {

  ListEndpoint({required super.id});

  Map<String, dynamic> buildRequest(I request) {
    return {"url": '{{environment.url}}/list/$id', "data": request.toJson()};
  }

  // TODO: Implement getModelDict and getModelYaml
}

abstract class SubmissionEndpoint<I extends Request, R extends Record> extends Endpoint<R> {

  SubmissionEndpoint({required super.id});

  Map<String, dynamic> buildRequest(I? request) {
    return {
      "url": '{{environment.url}}/$id',
      "data": request != null ? request.toJson() : {},
    };
  }

  // TODO: Implement getModelDict and getModelYaml
}

abstract class CollectionEndpoint<I extends Request, R extends Record> extends Endpoint<R> {

  CollectionEndpoint({required super.id});

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
}

