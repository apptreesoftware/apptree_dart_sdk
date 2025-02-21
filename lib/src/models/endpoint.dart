import 'package:apptree_dart_sdk/base.dart';
import 'package:yaml_writer/yaml_writer.dart';

abstract class CollectionEndpoint<I, R> {
  final String url;
  final String collection;
  final String dataSource;
  final Request? request;
  final Record record;

  CollectionEndpoint(
      {required this.url,
      required this.collection,
      required this.dataSource,
      this.request,
      required this.record}) {
    request?.register();
    record.register();
    String modelYaml = getModelYaml();
    print(modelYaml);
  }

  OnLoad onLoad() {
    return OnLoad(
      url: url,
      collection: collection,
      request: request,
    );
  }

  Map<String, dynamic> getModelDict() {
    return {
      "RequestParams" : request?.toModelDict(),
      "Model" : record.toModelDict(),
    };
  }
  

  String getModelYaml() {
    return YAMLWriter().write(getModelDict());
  }

}
