import 'package:test/test.dart';
import 'package:apptree_dart_sdk/src/models/expression.dart';
import 'package:apptree_dart_sdk/src/models/record.dart';

// Mock Record class for testing
class TestRecord extends Record {
  final StringField status = StringField();
  final BoolField closingStatusFlag = BoolField();
  final BoolField completeStatusFlag = BoolField();
  final BoolField isPMRequest = BoolField();
  final StringField statusId = StringField();
  final StringField propertyId = StringField();
  final StringField requestTypeId = StringField();
  final StringField requestPriorityId = StringField();

  TestRecord() {
    register();
  }
}

void main() {
  late TestRecord record;

  setUp(() {
    record = TestRecord();
  });

  group('SQL Expression Tests', () {
    test('todo status filter generates correct SQL', () {
      final condition = record.closingStatusFlag
          .equals(false)
          .and(record.completeStatusFlag.equals(false))
          .setType(ConditionalType.sqlite);

      expect(
        condition.toString(),
        'json_extract(record, "\$.closingStatusFlag") = ? AND json_extract(record, "\$.completeStatusFlag") = ?',
      );
      expect(condition.getValues(), [false, false]);
    });

    test('complete status filter generates correct SQL', () {
      final condition = record.closingStatusFlag
          .equals(true)
          .or(record.completeStatusFlag.equals(true))
          .setType(ConditionalType.sqlite);

      expect(
        condition.toString(),
        'json_extract(record, "\$.closingStatusFlag") = ? OR json_extract(record, "\$.completeStatusFlag") = ?',
      );
      expect(condition.getValues(), [true, true]);
    });

    test('PM filter generates correct SQL', () {
      final condition = record.isPMRequest
          .equals(true)
          .setType(ConditionalType.sqlite);

      expect(
        condition.toString(),
        'json_extract(record, "\$.isPMRequest") = ?',
      );
      expect(condition.getValues(), [true]);
    });

    test('non-PM filter generates correct SQL', () {
      final condition = record.isPMRequest
          .equals(false)
          .setType(ConditionalType.sqlite);

      expect(
        condition.toString(),
        'json_extract(record, "\$.isPMRequest") = ?',
      );
      expect(condition.getValues(), [false]);
    });

    test('status multi-filter generates correct SQL', () {
      final condition = StringEquals(
        record.statusId,
        "1,2,3",
      ).setType(ConditionalType.sqlite);

      expect(condition.toString(), 'json_extract(record, "\$.statusId") = ?');
      expect(condition.getValues(), ["1,2,3"]);
    });

    test('property multi-filter generates correct SQL', () {
      final condition = StringEquals(
        record.propertyId,
        "prop1,prop2",
      ).setType(ConditionalType.sqlite);

      expect(condition.toString(), 'json_extract(record, "\$.propertyId") = ?');
      expect(condition.getValues(), ["prop1,prop2"]);
    });

    test('type multi-filter generates correct SQL', () {
      final condition = StringEquals(
        record.requestTypeId,
        "type1,type2",
      ).setType(ConditionalType.sqlite);

      expect(
        condition.toString(),
        'json_extract(record, "\$.requestTypeId") = ?',
      );
      expect(condition.getValues(), ["type1,type2"]);
    });

    test('priority multi-filter generates correct SQL', () {
      final condition = StringEquals(
        record.requestPriorityId,
        "high,medium",
      ).setType(ConditionalType.sqlite);

      expect(
        condition.toString(),
        'json_extract(record, "\$.requestPriorityId") = ?',
      );
      expect(condition.getValues(), ["high,medium"]);
    });

    test('complex AND condition generates correct SQL', () {
      final condition = record.isPMRequest
          .equals(true)
          .and(record.closingStatusFlag.equals(false))
          .setType(ConditionalType.sqlite);

      expect(
        condition.toString(),
        'json_extract(record, "\$.isPMRequest") = ? AND json_extract(record, "\$.closingStatusFlag") = ?',
      );
      expect(condition.getValues(), [true, false]);
    });

    test('complex OR condition generates correct SQL', () {
      final condition = record.statusId
          .equals("1")
          .or(record.propertyId.equals("prop1"))
          .setType(ConditionalType.sqlite);

      expect(
        condition.toString(),
        'json_extract(record, "\$.statusId") = ? OR json_extract(record, "\$.propertyId") = ?',
      );
      expect(condition.getValues(), ["1", "prop1"]);
    });
  });
}
