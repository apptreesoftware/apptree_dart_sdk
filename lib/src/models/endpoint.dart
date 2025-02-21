import 'package:apptree_dart_sdk/base.dart';
import 'package:yaml_writer/yaml_writer.dart';

abstract class CollectionEndpoint<I, R> {
  final String name;
  final DataSource dataSource;
  final Request? request;
  final Record record;

  CollectionEndpoint(
      {required this.name, required this.dataSource, this.request, required this.record}) {
    request?.register();
    record.register();
  }

  OnLoad onLoad() {
    return OnLoad(
      url: dataSource.url,
      collection: dataSource.collection,
      request: request,
    );
  }

  Map<String, dynamic> getModelDict() {
    return { name: {
      "RequestParams": request?.toModelDict(),
      "Model": record.toModelDict(),
    }};
  }

  String getModelYaml() {
    return YAMLWriter().write(getModelDict());
  }
}
