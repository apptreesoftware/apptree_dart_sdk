import 'package:server/server.dart';

class Card {
  final String cardId;
  final String name;
  final Owner owner;
  final String description;
  final String rarity;
  final String type;
  final List<Attack> attacks;
  final double latitude;
  final double longitude;

  Card({required this.cardId, required this.name, required this.owner, required this.description, required this.rarity, required this.type, required this.attacks, required this.latitude, required this.longitude});

  factory Card.fromJson(Map<String, dynamic> json) {
    final invalidProperties = <String, String>{};
    final cardId = JsonUtils.validateField<String>(fieldName: 'cardId', value: json['cardId'], invalidProperties: invalidProperties);

    final name = JsonUtils.validateField<String>(fieldName: 'name', value: json['name'], invalidProperties: invalidProperties);

    final owner = JsonUtils.validateField<Map<String, dynamic>>(fieldName: 'owner', value: json['owner'], invalidProperties: invalidProperties);

    final description = JsonUtils.validateField<String>(fieldName: 'description', value: json['description'], invalidProperties: invalidProperties);

    final rarity = JsonUtils.validateField<String>(fieldName: 'rarity', value: json['rarity'], invalidProperties: invalidProperties);

    final type = JsonUtils.validateField<String>(fieldName: 'type', value: json['type'], invalidProperties: invalidProperties);

    final attacks = JsonUtils.validateField<List<Attack>>(fieldName: 'attacks', value: json['attacks'], invalidProperties: invalidProperties);

    final latitude = JsonUtils.validateField<double>(fieldName: 'latitude', value: json['latitude'], invalidProperties: invalidProperties);

    final longitude = JsonUtils.validateField<double>(fieldName: 'longitude', value: json['longitude'], invalidProperties: invalidProperties);

    JsonUtils.validateAndThrowIfInvalid(modelType: Card, invalidProperties: invalidProperties);

    return Card(cardId: cardId!, name: name!, owner: Owner.fromJson(owner!), description: description!, rarity: rarity!, type: type!, attacks: attacks!, latitude: latitude!, longitude: longitude!);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_pk'] = cardId.toString();
    data['cardId'] = cardId.toString();
    data['name'] = name.toString();
    data['owner'] = owner;
    data['description'] = description.toString();
    data['rarity'] = rarity.toString();
    data['type'] = type.toString();
    data['attacks'] = attacks;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Owner {
  final String ownerId;
  final String name;

  Owner({required this.ownerId, required this.name});

  factory Owner.fromJson(Map<String, dynamic> json) {
    final invalidProperties = <String, String>{};
    final ownerId = JsonUtils.validateField<String>(fieldName: 'ownerId', value: json['ownerId'], invalidProperties: invalidProperties);

    final name = JsonUtils.validateField<String>(fieldName: 'name', value: json['name'], invalidProperties: invalidProperties);

    JsonUtils.validateAndThrowIfInvalid(modelType: Owner, invalidProperties: invalidProperties);

    return Owner(ownerId: ownerId!, name: name!);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_pk'] = ownerId.toString();
    data['ownerId'] = ownerId.toString();
    data['name'] = name.toString();
    return data;
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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_pk'] = attackId.toString();
    data['attackId'] = attackId.toString();
    data['name'] = name.toString();
    data['damage'] = damage;
    return data;
  }
}

class Owner {
  final String ownerId;
  final String name;

  Owner({required this.ownerId, required this.name});

  factory Owner.fromJson(Map<String, dynamic> json) {
    final invalidProperties = <String, String>{};
    final ownerId = JsonUtils.validateField<String>(fieldName: 'ownerId', value: json['ownerId'], invalidProperties: invalidProperties);

    final name = JsonUtils.validateField<String>(fieldName: 'name', value: json['name'], invalidProperties: invalidProperties);

    JsonUtils.validateAndThrowIfInvalid(modelType: Owner, invalidProperties: invalidProperties);

    return Owner(ownerId: ownerId!, name: name!);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_pk'] = ownerId.toString();
    data['ownerId'] = ownerId.toString();
    data['name'] = name.toString();
    return data;
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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_pk'] = attackId.toString();
    data['attackId'] = attackId.toString();
    data['name'] = name.toString();
    data['damage'] = damage;
    return data;
  }
}

