import 'package:apptree_dart_sdk/apptree.dart';

import 'endpoints.dart';

class AppModel extends Record {
  BoolField get debugEnabled => BoolField();
}

class Card extends Record {
  @PkField()
  final StringField cardId = StringField();
  final StringField name = StringField();
  @ExternalField(endpoint: OwnersListEndpoint(), key: 'ownerId')
  final Owner owner = Owner();
  final StringField description = StringField();
  final StringField rarity = StringField();
  final StringField type = StringField();
  final ListField<Attack> attacks = ListField<Attack>();
  final FloatField latitude = FloatField();
  final FloatField longitude = FloatField();
}

class Owner extends Record {
  @PkField()
  final StringField ownerId = StringField();
  final StringField name = StringField();
}

class Attack extends Record {
  @PkField()
  final StringField attackId = StringField();
  final StringField name = StringField();
  final IntField damage = IntField();
}

class CustomUserData extends Record {
  @PkField()
  final StringField externalId = StringField();
}

class MyCardsRequest extends Request {
  final String? owner;
  final String? filter;

  MyCardsRequest({required this.owner, required this.filter});
}

class CardSubmissionRequest extends Request {
  final String appVersion;

  CardSubmissionRequest({required this.appVersion});
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
