abstract class CollectionDataSource<TInput, TOutput> {
  Future<List<TOutput>> getCollection(TInput input);

  Future<TOutput> getRecord(String id);
}

abstract class ListDataSource<TOutput> {
  Future<List<TOutput>> getList();
}

abstract class SubmissionDataSource<TInput, TOutput> {
  Future<TOutput> submit(TInput input, TOutput record);
}
