import 'package:example_connector/generated/models/card.dart';
import 'package:example_connector/generated/models/my_cards_request.dart';
import 'package:server/server.dart';

abstract class MyCardsCollection
    extends CollectionDataSource<MyCardsRequest, Card> {
  @override
  Future<List<Card>> getCollection(MyCardsRequest request);

  @override
  Future<Card> getRecord(String id);
}
