import 'package:example_connector/generated/models/card.dart.dart';
import 'package:example_connector/generated/models/my_cards_request.dart.dart';
import 'package:example_connector/generated/datasources/my_cards_collection_sample.dart';
class SampleMyCardsCollection extends MyCardsCollection {
  @override
  Future<List<Card>> getCollection(MyCardsRequest request) async {
  final List<Card> samples = [
  Card(
    cardId: '1',
    name: 'Fireball',
    owner: 'Mage',
    description: 'A powerful fire spell',
    rarity: 'Rare',
    type: 'Spell',
    attacks: Attack(
      attackId: 'a1',
      name: 'Fire Damage',
      damage: 50
    )
  ),
  Card(
    cardId: '2',
    name: 'Ice Shield',
    owner: 'Warrior',
    description: 'Protects against fire attacks',
    rarity: 'Uncommon',
    type: 'Defense',
    attacks: Attack(
      attackId: 'a2',
      name: 'Ice Barrier',
      damage: 0
    )
  ),
  Card(
    cardId: '3',
    name: 'Lightning Strike',
    owner: 'Sorcerer',
    description: 'Strikes enemies with lightning',
    rarity: 'Epic',
    type: 'Spell',
    attacks: Attack(
      attackId: 'a3',
      name: 'Lightning Damage',
      damage: 70
    )
  ),
  Card(
    cardId: '4',
    name: 'Healing Potion',
    owner: 'Alchemist',
    description: 'Restores health',
    rarity: 'Common',
    type: 'Item',
    attacks: Attack(
      attackId: 'a4',
      name: 'Heal',
      damage: -30
    )
  ),
  Card(
    cardId: '5',
    name: 'Earthquake',
    owner: 'Druid',
    description: 'Causes tremors',
    rarity: 'Legendary',
    type: 'Spell',
    attacks: Attack(
      attackId: 'a5',
      name: 'Ground Damage',
      damage: 60
    )
  ),
  Card(
    cardId: '6',
    name: 'Wind Gust',
    owner: 'Ranger',
    description: 'Pushes enemies back',
    rarity: 'Uncommon',
    type: 'Spell',
    attacks: Attack(
      attackId: 'a6',
      name: 'Wind Damage',
      damage: 40
    )
  ),
  Card(
    cardId: '7',
    name: 'Shadow Cloak',
    owner: 'Assassin',
    description: 'Grants invisibility',
    rarity: 'Rare',
    type: 'Item',
    attacks: Attack(
      attackId: 'a7',
      name: 'Stealth',
      damage: 0
    )
  ),
  Card(
    cardId: '8',
    name: 'Holy Light',
    owner: 'Paladin',
    description: 'A divine light that heals',
    rarity: 'Epic',
    type: 'Spell',
    attacks: Attack(
      attackId: 'a8',
      name: 'Holy Heal',
      damage: -50
    )
  ),
  Card(
    cardId: '9',
    name: 'Poison Dart',
    owner: 'Rogue',
    description: 'A dart that poisons',
    rarity: 'Common',
    type: 'Weapon',
    attacks: Attack(
      attackId: 'a9',
      name: 'Poison Damage',
      damage: 30
    )
  ),
  Card(
    cardId: '10',
    name: 'Meteor Shower',
    owner: 'Wizard',
    description: 'Rains meteors on enemies',
    rarity: 'Legendary',
    type: 'Spell',
    attacks: Attack(
      attackId: 'a10',
      name: 'Meteor Damage',
      damage: 100
    )
  )
];
  return samples;
  }
}
