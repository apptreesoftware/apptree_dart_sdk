import 'package:example_connector/generated/datasources/my_cards_datasource.dart';
import 'package:example_connector/generated/models/card.dart';
import 'package:example_connector/generated/models/my_cards_request.dart';

class SampleMyCardsCollection extends MyCardsCollection {
  @override
  Future<List<Card>> getCollection(MyCardsRequest request) async {
    var cards = [
      Card(
        cardId: '2',
        name: 'Pikachu',
        owner: 'Ash Ketchum',
        description: 'Electric-type Pokémon',
        rarity: 'Rare',
        type: 'Electric',
        attacks: Attack(attackId: '2', name: 'Thunderbolt', damage: 90),
      ),
      Card(
        cardId: '3',
        name: 'Charizard',
        owner: 'Ash Ketchum',
        description: 'Fire/Flying-type Pokémon',
        rarity: 'Ultra Rare',
        type: 'Fire',
        attacks: Attack(attackId: '3', name: 'Flamethrower', damage: 120),
      ),
      Card(
        cardId: '4',
        name: 'Bulbasaur',
        owner: 'Professor Oak',
        description: 'Grass/Poison-type Pokémon',
        rarity: 'Common',
        type: 'Grass',
        attacks: Attack(attackId: '4', name: 'Vine Whip', damage: 40),
      ),
      Card(
        cardId: '5',
        name: 'Squirtle',
        owner: 'Professor Oak',
        description: 'Water-type Pokémon',
        rarity: 'Common',
        type: 'Water',
        attacks: Attack(attackId: '5', name: 'Water Gun', damage: 40),
      ),
      Card(
        cardId: '6',
        name: 'Mewtwo',
        owner: 'Giovanni',
        description: 'Psychic-type Legendary Pokémon',
        rarity: 'Legendary',
        type: 'Psychic',
        attacks: Attack(attackId: '6', name: 'Psystrike', damage: 150),
      ),
      Card(
        cardId: '7',
        name: 'Gengar',
        owner: 'Agatha',
        description: 'Ghost/Poison-type Pokémon',
        rarity: 'Rare',
        type: 'Ghost',
        attacks: Attack(attackId: '7', name: 'Shadow Ball', damage: 80),
      ),
      Card(
        cardId: '8',
        name: 'Gyarados',
        owner: 'Misty',
        description: 'Water/Flying-type Pokémon',
        rarity: 'Rare',
        type: 'Water',
        attacks: Attack(attackId: '8', name: 'Hydro Pump', damage: 110),
      ),
      Card(
        cardId: '9',
        name: 'Snorlax',
        owner: 'Red',
        description: 'Normal-type Pokémon',
        rarity: 'Uncommon',
        type: 'Normal',
        attacks: Attack(attackId: '9', name: 'Body Slam', damage: 85),
      ),
      Card(
        cardId: '10',
        name: 'Dragonite',
        owner: 'Lance',
        description: 'Dragon/Flying-type Pokémon',
        rarity: 'Ultra Rare',
        type: 'Dragon',
        attacks: Attack(attackId: '10', name: 'Hyper Beam', damage: 150),
      ),
      Card(
        cardId: '11',
        name: 'Eevee',
        owner: 'Gary Oak',
        description: 'Normal-type Pokémon with multiple evolutions',
        rarity: 'Uncommon',
        type: 'Normal',
        attacks: Attack(attackId: '11', name: 'Swift', damage: 60),
      ),
    ];

    if (request.owner != '') {
      cards = cards.where((card) => card.owner == request.owner).toList();
    }

    return cards;
  }

  @override
  Future<Card> getRecord(String id) async {
    return getCollection(
      MyCardsRequest(owner: '', filter: ''),
    ).then((cards) => cards.firstWhere((card) => card.cardId == id));
  }
}
