import 'package:apptree_dart_sdk/apptree.dart';
import 'package:yaml_writer/yaml_writer.dart';

abstract class Endpoint<R extends Record> {
  final String id;

  const Endpoint({required this.id});

  R get record {
    return instantiateRecord();
  }

  Map<String, dynamic> getModelDict();

  String getModelYaml() {
    return YamlWriter().write(getModelDict());
  }
}

abstract class ListEndpoint<R extends Record> extends Endpoint<R> {
  const ListEndpoint({required super.id});

  @override
  Map<String, dynamic> getModelDict() {
    return {
      id: {"Model": record.toModelDict()},
    };
  }
}

abstract class SubmissionEndpoint<I extends Request, R extends Record>
    extends Endpoint<R> {
  const SubmissionEndpoint({required super.id, required this.submissionType});

  final SubmissionType submissionType;

  Map<String, dynamic> buildRequest(I? request) {
    return {
      "url": '{{environment.url}}/$id',
      "data": request != null ? request.toJson() : {},
    };
  }

  Map<String, dynamic> getRequestParams() {
    return describeRequest<I>();
  }

  @override
  Map<String, dynamic> getModelDict() {
    return {
      id: {"RequestParams": getRequestParams(), "Model": record.toModelDict()},
    };
  }
}

abstract class CollectionEndpoint<I extends Request, R extends Record>
    extends Endpoint<R> {
  const CollectionEndpoint({required super.id});

  Map<String, dynamic> buildRequest(I request) {
    return {"url": '{{environment.url}}/$id', "data": request.toJson()};
  }

  Map<String, dynamic> getRequestParams() {
    return describeRequest<I>();
  }

  @override
  Map<String, dynamic> getModelDict() {
    return {
      id: {"RequestParams": getRequestParams(), "Model": record.toModelDict()},
    };
  }
}
