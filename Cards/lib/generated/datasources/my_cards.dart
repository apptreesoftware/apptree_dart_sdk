import 'package:server/server.dart';

import 'package:Cards/generated/models/card.dart';
import 'package:Cards/generated/models/my_cards_request.dart';
abstract class MyCards extends CollectionDataSource<MyCardsRequest, Card> {
  @override
  Future<List<Card>> getCollection(MyCardsRequest request);

  @override
  Future<Card> getRecord(String id);
}
