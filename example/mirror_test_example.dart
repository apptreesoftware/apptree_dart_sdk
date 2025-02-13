import 'package:apptree_dart_sdk/base.dart';
import 'package:apptree_dart_sdk/src/components/generic.dart';

class TestClass extends Record {
  final IntField id = IntField();
  final StringField name = StringField();
  final BoolField isActive = BoolField();
  final TestSubclass testSubclass = TestSubclass();
}

class TestSubclass extends Record {
  final StringField name = StringField();
  final IntField id = IntField();
  final TestSubSubclass testSubSubclass = TestSubSubclass();
}

class TestSubSubclass extends Record {
  final StringField description = StringField();
  final IntField age = IntField();
}

class TestRecordListBuilder extends Builder {
  final TestClass record = TestClass();

  TestRecordListBuilder() : super(id: 'test_record_list', record: TestClass());

  @override
  Feature build() {
    return RecordList(
        id: id,
        onLoad: OnLoad(),
        dataSource: 'test_data_source',
        noResultsText: 'No results',
        showDivider: true,
        topAccessoryViews: [],
        template: Template(
          id: 'test_template', 
          values: [
            Value(id: record.id, value: record.id.value),
          ]),
        onItemSelected: OnItemSelected(builder: TestRecordListBuilder()));
  }
}

// class Expression {
//   Field field1;
//   Field field2;
//   String operator;

//   Expression({
//     required this.field1,
//     required this.field2,
//     required this.operator,
//   });

//   @override
//   String toString() {
//     return '${field1.fullFieldPath} $operator ${field2.fullFieldPath}';
//   }
// }

// void main() {
//   final testClass = TestClass()..register();

// }
