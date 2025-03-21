import 'package:test/test.dart';
import 'package:apptree_dart_sdk/apptree.dart';

// Test classes
class SimpleRecord extends Record {
  @PkField()
  final StringField id = StringField();
  final StringField name = StringField();
  final IntField age = IntField();
}

class ComplexRecord extends Record {
  @PkField()
  final StringField id = StringField();
  final StringField name = StringField();
  final SimpleRecord nested = SimpleRecord();
  final DateTimeField completedOn = DateTimeField();
  final List<SimpleRecord> records = [];

  @ExternalField(endpoint: MyListEndpoint(), key: 'listRecordId')
  final ListRecord listRecord = ListRecord();
}

class SimpleRequest extends Request {
  final String name;
  final int age;

  SimpleRequest({required this.name, required this.age});
}

class ListRecord extends Record {
  @PkField()
  final StringField id = StringField();
  final StringField name = StringField();
  final IntField age = IntField();
}

class MyListEndpoint extends ListEndpoint<ListRecord> {
  const MyListEndpoint() : super(id: 'listData');
}

class ComplexRequest extends Request {
  final String owner;
  final Map<String, int> scores;
  final List<SimpleRequest> requests;

  ComplexRequest({
    required this.owner,
    required this.scores,
    required this.requests,
  });
}

class EmptyRequest extends Request {}

void main() {
  group('instantiateRecord Tests', () {
    test('should instantiate a simple record', () {
      final record = instantiateRecord<SimpleRecord>();
      expect(record, isA<SimpleRecord>());
      expect(record.fieldName, isA<StringField>());
      expect(record.age, isA<IntField>());
    });

    test('should instantiate a complex record with nested records', () {
      final record = instantiateRecord<ComplexRecord>();
      expect(record, isA<ComplexRecord>());
      expect(record.fieldName, isA<StringField>());
      expect(record.nested, isA<SimpleRecord>());
      expect(record.records, isA<List<SimpleRecord>>());
      expect(record.listRecord, isA<ListRecord>());
      expect(record.listRecord.listEndpoint, isA<MyListEndpoint>());
    });

    test('should output correct field paths', () {
      final record = instantiateRecord<ComplexRecord>();
      expect(record, isA<ComplexRecord>());
      expect(record.name.value, equals(r'record().name'));
      expect(record.nested.value, equals(r'record().nested'));
      expect(record.nested.age.value, equals(r'record().nested.age'));
      expect(
        record.listRecord.value,
        equals(r'getListItem("listData", record().listRecordId)'),
      );
      expect(
        record.listRecord.name.value,
        equals(r'getListItem("listData", record().listRecordId).name'),
      );
      expect(
        record.completedOn.format('yyyy-MM-dd').toUpper().value,
        equals(r'record().completedOn.format("yyyy-MM-dd").toUpper()'),
      );
    });

    test('should register fields after instantiation', () {
      final record = instantiateRecord<SimpleRecord>();
      expect(record.name.parent, equals(record));
      expect(record.age.parent, equals(record));
    });
  });

  group('describeRequest Tests', () {
    test('should describe a simple request with primitive types', () {
      final description = describeRequest<SimpleRequest>();
      expect(description, {'name': 'string', 'age': 'int'});
    });

    test('should describe a complex request with nested types', () {
      final description = describeRequest<ComplexRequest>();
      expect(description, {
        'owner': 'string',
        'scores': {
          'map': ['string', 'int'],
        },
        'requests': [
          {'name': 'string', 'age': 'int'},
        ],
      });
    });

    test('should handle empty request class', () {
      final description = describeRequest<EmptyRequest>();
      expect(description, isEmpty);
    });
  });
}
