import 'package:apptree_dart_sdk/src/models/datasource.dart';

abstract class CollectionEndpoint<I, R> {
  final DataSource<I, R> dataSource;

  CollectionEndpoint({required this.dataSource});

  Future<List<R>> fetch(I input) {
    return dataSource.fetch(input);
  }
}

abstract class SubmissionEndpoint<I, R> {
  final DataSource<I, R> dataSource;

  SubmissionEndpoint({required this.dataSource});
  Future<R> submit(I input) {
    return dataSource.submit(input);
  }
}
