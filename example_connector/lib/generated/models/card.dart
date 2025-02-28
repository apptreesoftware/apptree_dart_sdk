// class Card extends Record {
//   final StringField cardId = StringField();
//   final StringField name = StringField();
//   final StringField owner = StringField();
//   final StringField description = StringField();
//   final StringField rarity = StringField();
//   final StringField type = StringField();
//   final Attack attacks = Attack();
// }

// class Attack extends Record {
//   final StringField attackId = StringField();
//   final StringField name = StringField();
//   final IntField damage = IntField();
// }

import 'package:server/server.dart';

class Card {
  final String cardId;
  final String name;
  final String owner;
  final String? description;
  final String rarity;
  final String type;
  final Attack attacks;

  Card({
    required this.cardId,
    required this.name,
    required this.owner,
    required this.description,
    required this.rarity,
    required this.type,
    required this.attacks,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    final invalidProperties = <String, String>{};

    final cardId = JsonUtils.validateField<String>(
      fieldName: 'cardId',
      value: json['cardId'],
      invalidProperties: invalidProperties,
    );

    final name = JsonUtils.validateField<String>(
      fieldName: 'name',
      value: json['name'],
      invalidProperties: invalidProperties,
    );

    final owner = JsonUtils.validateField<String>(
      fieldName: 'owner',
      value: json['owner'],
      invalidProperties: invalidProperties,
    );

    // Allow null for description
    final description =
        json['description'] != null
            ? JsonUtils.validateField<String>(
              fieldName: 'description',
              value: json['description'],
              invalidProperties: invalidProperties,
            )
            : null;

    final rarity = JsonUtils.validateField<String>(
      fieldName: 'rarity',
      value: json['rarity'],
      invalidProperties: invalidProperties,
    );

    final type = JsonUtils.validateField<String>(
      fieldName: 'type',
      value: json['type'],
      invalidProperties: invalidProperties,
    );

    // Validate that attacks is a Map
    final attacksJson = JsonUtils.validateField<Map<String, dynamic>>(
      fieldName: 'attacks',
      value: json['attacks'],
      invalidProperties: invalidProperties,
    );

    JsonUtils.validateAndThrowIfInvalid(
      modelType: Card,
      invalidProperties: invalidProperties,
    );

    return Card(
      cardId: cardId!,
      name: name!,
      owner: owner!,
      description: description,
      rarity: rarity!,
      type: type!,
      attacks: Attack.fromJson(attacksJson!),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardId': cardId,
      'name': name,
      'owner': owner,
      'description': description,
      'rarity': rarity,
      'type': type,
      'attacks': attacks.toJson(),
    };
  }
}

class Attack {
  final String attackId;
  final String name;
  final int damage;

  Attack({required this.attackId, required this.name, required this.damage});

  factory Attack.fromJson(Map<String, dynamic> json) {
    final invalidProperties = <String, String>{};

    final attackId = JsonUtils.validateField<String>(
      fieldName: 'attackId',
      value: json['attackId'],
      invalidProperties: invalidProperties,
    );

    final name = JsonUtils.validateField<String>(
      fieldName: 'name',
      value: json['name'],
      invalidProperties: invalidProperties,
    );

    final damage = JsonUtils.validateField<int>(
      fieldName: 'damage',
      value: json['damage'],
      invalidProperties: invalidProperties,
    );

    JsonUtils.validateAndThrowIfInvalid(
      modelType: Attack,
      invalidProperties: invalidProperties,
    );

    return Attack(attackId: attackId!, name: name!, damage: damage!);
  }

  Map<String, dynamic> toJson() {
    return {'attackId': attackId, 'name': name, 'damage': damage};
  }
}
