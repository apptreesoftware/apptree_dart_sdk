import 'package:apptree_dart_sdk/base.dart';

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
  }

  OnLoad onLoad() {
    return OnLoad(
      url: url,
      collection: collection,
      request: request,
    );
  }

  String getDataSource() {
    return dataSource;
  }

}
