import 'package:apptree_dart_sdk/src/constants.dart';
import 'package:test/test.dart';
import 'package:apptree_dart_sdk/src/models/expression.dart';
import 'package:apptree_dart_sdk/src/models/record.dart';

class Card extends Record {
  final StringField name = StringField();
  final StringField rarity = StringField();
  final StringField type = StringField();
  final Attack attacks = Attack();
}

class Attack extends Record {
  final StringField name = StringField();
  final IntField damage = IntField();
}

class Test extends Record {
  final StringField assetName = StringField();
}

class User extends Record {
  final StringField name = StringField(scope: FieldScope.user);
}

void main() {
  group('Expression Tests', () {
    var cardModel = Card()..register();
    var record = Test()..register();
    var user = User()..register();

    test('StringField contains expression test', () {
      var expr = cardModel.name.contains('test');

      expect(expr.toString(), equals('record().name.contains("test")'));
    });

    test('Expression equals test', () {
      var expr = record.assetName
          .equals('assetName')
          .and(
            Or(
              record.assetName.contains('assetName2'),
              record.assetName.equals('assetName3'),
            ).and(
              user.name.equals('user1').or(user.name.equals('user2')),
            ),
          );

      expect(
        expr.toString(),
        equals(
          'record().assetName == "assetName" && (record().assetName.contains("assetName2") || record().assetName == "assetName3") && user().name == "user1" || user().name == "user2"',
        ),
      );
    });
  });
}
