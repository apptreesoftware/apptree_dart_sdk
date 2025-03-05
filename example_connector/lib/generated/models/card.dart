import 'package:server/server.dart';

class Card {
  final String cardId;
  final String name;
  final String owner;
  final String description;
  final String rarity;
  final String type;
  final Attack attacks;

  Card({required this.cardId, required this.name, required this.owner, required this.description, required this.rarity, required this.type, required this.attacks});

  factory Card.fromJson(Map<String, dynamic> json) {
    final invalidProperties = <String, String>{};
    final cardId = JsonUtils.validateField<String>(fieldName: 'cardId', value: json['cardId'], invalidProperties: invalidProperties);

    final name = JsonUtils.validateField<String>(fieldName: 'name', value: json['name'], invalidProperties: invalidProperties);

    final owner = JsonUtils.validateField<String>(fieldName: 'owner', value: json['owner'], invalidProperties: invalidProperties);

    final description = JsonUtils.validateField<String>(fieldName: 'description', value: json['description'], invalidProperties: invalidProperties);

    final rarity = JsonUtils.validateField<String>(fieldName: 'rarity', value: json['rarity'], invalidProperties: invalidProperties);

    final type = JsonUtils.validateField<String>(fieldName: 'type', value: json['type'], invalidProperties: invalidProperties);

    final attacks = JsonUtils.validateField<Map<String, dynamic>>(fieldName: 'attacks', value: json['attacks'], invalidProperties: invalidProperties);

    JsonUtils.validateAndThrowIfInvalid(modelType: Card, invalidProperties: invalidProperties);

    return Card(cardId: cardId!, name: name!, owner: owner!, description: description!, rarity: rarity!, type: type!, attacks: Attack.fromJson(attacks!));
  }
}

class Attack {
  final String attackId;
  final String name;
  final int damage;

  Attack({required this.attackId, required this.name, required this.damage});

  factory Attack.fromJson(Map<String, dynamic> json) {
    final invalidProperties = <String, String>{};
    final attackId = JsonUtils.validateField<String>(fieldName: 'attackId', value: json['attackId'], invalidProperties: invalidProperties);

    final name = JsonUtils.validateField<String>(fieldName: 'name', value: json['name'], invalidProperties: invalidProperties);

    final damage = JsonUtils.validateField<int>(fieldName: 'damage', value: json['damage'], invalidProperties: invalidProperties);

    JsonUtils.validateAndThrowIfInvalid(modelType: Attack, invalidProperties: invalidProperties);

    return Attack(attackId: attackId!, name: name!, damage: damage!);
  }
}

