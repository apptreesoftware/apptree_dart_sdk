import 'package:apptree_dart_sdk/apptree.dart';
import 'package:apptree_dart_sdk/src/generators/datasource_generator.dart';
import 'models.dart';

void main() {
  final card = Card();
  final cardRequest = MyCardsRequest(owner: 'John Doe', filter: 'My Cards');
  // final modelGenerator = ModelGenerator(record: card);
  final requestGenerator = DatasourceGenerator(datasourceName: "MyCards", record: card, request: cardRequest);
}
