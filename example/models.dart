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

class MyCardsRequest extends Request {
  final StringField owner = User().username;
}

class CustomUserData extends Record {
  final StringField externalId = StringField();
}
