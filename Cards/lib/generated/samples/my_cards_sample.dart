import 'package:Cards/generated/models/card.dart';
import 'package:Cards/generated/models/my_cards_request.dart';
import 'package:Cards/generated/datasources/my_cards.dart';
class SampleMyCards extends MyCards {
  static final List<Card> samples = [
  Card(
    cardId: "1",
    name: "Fireball",
    owner: Owner(ownerId: "101", name: "Alice"),
    description: "A powerful fire attack",
    rarity: "Rare",
    type: "Spell",
    attacks: [Attack(attackId: "a1", name: "Burn", damage: 50)],
    latitude: 34.0522,
    longitude: -118.2437
  ),
  Card(
    cardId: "2",
    name: "Water Splash",
    owner: Owner(ownerId: "102", name: "Bob"),
    description: "A refreshing water attack",
    rarity: "Common",
    type: "Spell",
    attacks: [Attack(attackId: "a2", name: "Soak", damage: 30)],
    latitude: 40.7128,
    longitude: -74.0060
  ),
  Card(
    cardId: "3",
    name: "Earthquake",
    owner: Owner(ownerId: "103", name: "Charlie"),
    description: "A devastating earth attack",
    rarity: "Epic",
    type: "Spell",
    attacks: [Attack(attackId: "a3", name: "Quake", damage: 70)],
    latitude: 51.5074,
    longitude: -0.1278
  ),
  Card(
    cardId: "4",
    name: "Lightning Strike",
    owner: Owner(ownerId: "104", name: "Diana"),
    description: "A quick lightning attack",
    rarity: "Legendary",
    type: "Spell",
    attacks: [Attack(attackId: "a4", name: "Zap", damage: 60)],
    latitude: 35.6895,
    longitude: 139.6917
  ),
  Card(
    cardId: "5",
    name: "Wind Gust",
    owner: Owner(ownerId: "105", name: "Eve"),
    description: "A swift wind attack",
    rarity: "Uncommon",
    type: "Spell",
    attacks: [Attack(attackId: "a5", name: "Blow", damage: 40)],
    latitude: -33.8688,
    longitude: 151.2093
  ),
  Card(
    cardId: "6",
    name: "Ice Shard",
    owner: Owner(ownerId: "106", name: "Frank"),
    description: "A chilling ice attack",
    rarity: "Rare",
    type: "Spell",
    attacks: [Attack(attackId: "a6", name: "Freeze", damage: 55)],
    latitude: 48.8566,
    longitude: 2.3522
  ),
  Card(
    cardId: "7",
    name: "Rock Throw",
    owner: Owner(ownerId: "107", name: "Grace"),
    description: "A solid rock attack",
    rarity: "Common",
    type: "Physical",
    attacks: [Attack(attackId: "a7", name: "Smash", damage: 35)],
    latitude: 37.7749,
    longitude: -122.4194
  ),
  Card(
    cardId: "8",
    name: "Shadow Strike",
    owner: Owner(ownerId: "108", name: "Hank"),
    description: "A stealthy shadow attack",
    rarity: "Epic",
    type: "Physical",
    attacks: [Attack(attackId: "a8", name: "Sneak", damage: 65)],
    latitude: 55.7558,
    longitude: 37.6173
  ),
  Card(
    cardId: "9",
    name: "Healing Light",
    owner: Owner(ownerId: "109", name: "Ivy"),
    description: "A restorative light attack",
    rarity: "Legendary",
    type: "Spell",
    attacks: [Attack(attackId: "a9", name: "Heal", damage: -20)],
    latitude: 39.9042,
    longitude: 116.4074
  ),
  Card(
    cardId: "10",
    name: "Thunder Clap",
    owner: Owner(ownerId: "110", name: "Jack"),
    description: "A booming thunder attack",
    rarity: "Uncommon",
    type: "Spell",
    attacks: [Attack(attackId: "a10", name: "Boom", damage: 45)],
    latitude: 34.0522,
    longitude: -118.2437
  )
];
  @override
  Future<List<Card>> getCollection(MyCardsRequest request) async {
  return samples;
  }
@override
  Future<Card> getRecord(String id) async { return samples[0]; }
}
