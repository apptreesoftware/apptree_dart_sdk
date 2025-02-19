abstract class DataSource<I, R> {
  Future<List<R>> fetch(I input);
  Future<R> submit(I input);
}
