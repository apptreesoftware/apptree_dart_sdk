import 'package:apptree_dart_sdk/apptree.dart';

class MyCardsEndpoint extends CollectionEndpoint<MyCardsRequest, Card> {
  const MyCardsEndpoint() : super(id: 'MyCards');
}

class OwnersListEndpoint extends ListEndpoint<EmptyRequest, Owner> {
  const OwnersListEndpoint() : super(id: 'Owners');
}

class Card extends Record {
  final StringField cardId = StringField();
  final StringField name = StringField();
  @ExternalField(endpoint: OwnersListEndpoint(), key: 'ownerId')
  final Owner owner = Owner();
  final StringField description = StringField();
  final StringField rarity = StringField();
  final StringField type = StringField();
  final ListField<Attack> attacks = ListField(record: Attack());
  final FloatField latitude = FloatField();
  final FloatField longitude = FloatField();
}

class Owner extends Record {
  final StringField ownerId = StringField();
  final StringField name = StringField();
}

class Attack extends Record {
  final StringField attackId = StringField();
  final StringField name = StringField();
  final IntField damage = IntField();
}

class CustomUserData extends Record {
  final StringField externalId = StringField();
}

class MyCardsRequest extends Request {
  final String owner;
  final String filter;

  MyCardsRequest({required this.owner, required this.filter});
}

class MyCardsVariables {
  final CardsOptions options;
  final bool enableRegionFilter;

  MyCardsVariables(this.options, {this.enableRegionFilter = false});
}

class CardsOptions {
  final bool showAll;
  final bool showRare;

  CardsOptions({this.showAll = true, this.showRare = false});
}

class EmptyRequest extends Request {}
