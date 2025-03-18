import 'package:apptree_dart_sdk/apptree.dart';
import 'package:test/test.dart';

/// A minimal Record model used for testing conditionals
///
/// This model defines a few fields (name, active, age) used in our tests.
/// For our purposes, we manually assign field paths.
class TestRecord extends Record {
  @PkField()
  final StringField id = StringField();
  final StringField name = StringField();
  final BoolField active = BoolField();
  final IntField age = IntField();

  TestRecord() {
    // Manually set the fullFieldPath for testing
    name.relativeFieldPath = 'name';
    active.relativeFieldPath = 'active';
    age.relativeFieldPath = 'age';
  }
}

void main() {
  group('ConditionalType.sqlite tests', () {
    test('Test 1: StringEquals condition', () {
      final record = TestRecord()..register();
      final condition = record.name
          .equals("John")
          .setType(ConditionalType.sqlite);
      expect(
        condition.toString(),
        equals('json_extract(record, "\$.name") = ?'),
      );
      expect(condition.getValues(), equals(["John"]));
    });

    test('Test 2: BoolEquals condition', () {
      final record = TestRecord()..register();
      final condition = record.active
          .equals(true)
          .setType(ConditionalType.sqlite);
      expect(
        condition.toString(),
        equals('json_extract(record, "\$.active") = ?'),
      );
      expect(condition.getValues(), equals([true]));
    });

    test('Test 3: IntEquals condition', () {
      final record = TestRecord()..register();
      final condition = record.age.equals(30).setType(ConditionalType.sqlite);
      expect(
        condition.toString(),
        equals('json_extract(record, "\$.age") = ?'),
      );
      expect(condition.getValues(), equals([30]));
    });

    test('Test 4: AND combination', () {
      final record = TestRecord()..register();
      final condition = record.name
          .equals("John")
          .and(record.active.equals(true))
          .setType(ConditionalType.sqlite);
      expect(
        condition.toString(),
        equals(
          'json_extract(record, "\$.name") = ? AND json_extract(record, "\$.active") = ?',
        ),
      );
      expect(condition.getValues(), equals(["John", true]));
    });

    test('Test 5: OR combination', () {
      final record = TestRecord()..register();
      final condition = record.name
          .equals("John")
          .or(record.active.equals(true))
          .setType(ConditionalType.sqlite);
      expect(
        condition.toString(),
        equals(
          'json_extract(record, "\$.name") = ? OR json_extract(record, "\$.active") = ?',
        ),
      );
      expect(condition.getValues(), equals(["John", true]));
    });

    test('Test 6: Contains condition', () {
      final record = TestRecord()..register();
      final condition = record.name
          .contains("oh")
          .setType(ConditionalType.sqlite);
      expect(
        condition.toString(),
        equals('json_extract(record, "\$.name") LIKE ?'),
      );
      expect(condition.getValues(), equals(["oh"]));
    });

    test('Test 7: Nested OR and AND combination', () {
      final record = TestRecord()..register();
      // Build an expression: (name equals "John" OR name equals "Doe") AND active equals true
      final orCondition = record.name
          .equals("John")
          .or(record.name.equals("Doe"));
      final condition = orCondition
          .and(record.active.equals(true))
          .setType(ConditionalType.sqlite);
      expect(
        condition.toString(),
        equals(
          'json_extract(record, "\$.name") = ? OR json_extract(record, "\$.name") = ? AND json_extract(record, "\$.active") = ?',
        ),
      );
      expect(condition.getValues(), equals(["John", "Doe", true]));
    });

    test('Test 8: RecordContains condition', () {
      final record = TestRecord()..register();
      // record.contains(field) returns a RecordContains instance.
      final condition = record
          .contains(record.name)
          .setType(ConditionalType.sqlite);
      expect(
        condition.toString(),
        equals('json_extract(record, "\$.name") IN ?'),
      );
      // getValues produces a string expression based on record.value and the field name.
      expect(condition.getValues(), equals(["record().map('name')"]));
    });

    test('Test 9: Complex nested combination', () {
      final record = TestRecord()..register();
      // Build an expression: (name equals 'John' AND active equals true) OR (age equals 25 AND name contains 'D')
      final condition1 = record.name
          .equals("John")
          .and(record.active.equals(true));
      final condition2 = record.age.equals(25).and(record.name.contains("D"));
      final condition = condition1
          .or(condition2)
          .setType(ConditionalType.sqlite);
      final expectedString =
          'json_extract(record, "\$.name") = ? AND json_extract(record, "\$.active") = ? OR json_extract(record, "\$.age") = ? AND json_extract(record, "\$.name") LIKE ?';
      expect(condition.toString(), equals(expectedString));
      expect(condition.getValues(), equals(["John", true, 25, "D"]));
    });

    test('Test 10: Multiple nested conditions with mixed operators', () {
      final record = TestRecord()..register();
      // Build an expression:
      // ((name equals "John" OR name equals "Doe") AND active equals true) OR (name contains "Test" AND age equals 40)
      final orPart = record.name.equals("John").or(record.name.equals("Doe"));
      final andPart1 = orPart.and(record.active.equals(true));
      final andPart2 = record.name.contains("Test").and(record.age.equals(40));
      final condition = andPart1.or(andPart2).setType(ConditionalType.sqlite);
      final expectedString =
          'json_extract(record, "\$.name") = ? OR json_extract(record, "\$.name") = ? AND json_extract(record, "\$.active") = ? OR json_extract(record, "\$.name") LIKE ? AND json_extract(record, "\$.age") = ?';
      expect(condition.toString(), equals(expectedString));
      expect(condition.getValues(), equals(["John", "Doe", true, "Test", 40]));
    });
  });
}
