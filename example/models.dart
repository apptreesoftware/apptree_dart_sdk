import 'package:apptree_dart_sdk/apptree.dart';

class Card extends Record {
  final StringField cardId = StringField();
  final StringField name = StringField();
  final StringField owner = StringField();
  final StringField description = StringField();
  final StringField rarity = StringField();
  final StringField type = StringField();
  final Attack attacks = Attack();
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
