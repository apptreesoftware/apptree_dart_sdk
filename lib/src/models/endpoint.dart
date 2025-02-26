import 'package:apptree_dart_sdk/base.dart';
import 'package:apptree_dart_sdk/src/components/callback.dart';
import 'package:yaml_writer/yaml_writer.dart';

abstract class SubmissionEndpoint<I extends Request, R extends Record> {
  final String id;
  final I? request;
  final R record;

  SubmissionEndpoint({required this.id, this.request, required this.record});
}

abstract class CollectionEndpoint<I extends Request, R extends Record> {
  final String id;
  final I? request;
  final R record;

  CollectionEndpoint({required this.id, this.request, required this.record}) {
    request?.register();
    record.register();
  }

  OnLoad onLoad() {
    return OnLoad(
      url: '{{environment.url}}/$id',
      collection: id,
      request: request,
    );
  }

  Map<String, dynamic> getModelDict() {
    return {
      id: {
        "RequestParams": request?.toModelDict(),
        "Model": record.toModelDict(),
      },
    };
  }

  String getModelYaml() {
    return YAMLWriter().write(getModelDict());
  }
}
