import 'package:apptree_dart_sdk/base.dart';

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
          values: Values(values: {
            "TestId": Value(value: record.testSubclass.id),
            "TestName": Value(value: record.name),
          }),
        ),
        onItemSelected: OnItemSelected(builder: TestFormBuilder()));
  }
}

class TestFormBuilder extends Builder {
  final TestClass record = TestClass();

  TestFormBuilder() : super(id: 'test_form', record: TestClass());

  @override
  Feature build() {
    return Form(
      id: id,
      toolbar: Toolbar(items: [
        ToolbarItem(title: "Submit", actions: [
          SubmitFormAction(url: "<insert_url>", title: "Updating Card")
        ])
      ]),
      fields: FormFields(fields: {
        "Header": Header(title: "Test Form"),
        "Id": Text(title: "Id", displayValue: "id"),
        "Name": TextInput(title: "Name", bindTo: "name", required: true),
      }),
    );
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

void main() {
  final app = App(name: "TestApp", version: "1.0.0");
  app.addFeature(TestRecordListBuilder(),
      MenuItem(title: "Test", icon: "dashboard", defaultItem: false, order: 1));
  app.initialize();
}
