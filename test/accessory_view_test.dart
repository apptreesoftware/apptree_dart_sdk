import 'package:test/test.dart';
import 'package:apptree_dart_sdk/apptree.dart';

// Mock implementation for testing
class MockRecord extends Record {
  final StringField name = StringField();
  final IntField age = IntField();
}

class MockRequest extends Request {}

class MockListEndpoint extends ListEndpoint<MockRequest, MockRecord> {
  const MockListEndpoint() : super(id: 'mockList');
}

class MockTemplate extends Template {
  MockTemplate() : super(id: 'mockTemplate');

  @override
  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'values': {'test': 'value'},
    };
  }

  @override
  String toFsx() {
    return '<template id="$id"></template>';
  }
}

void main() {
  group('SelectListInputAccessoryView Tests', () {
    late BuildContext context;
    late SelectListInputAccessoryView<MockRequest, MockRecord> accessoryView;
    late MockListEndpoint mockListEndpoint;

    setUp(() {
      context = BuildContext(user: User());
      mockListEndpoint = const MockListEndpoint();

      accessoryView = SelectListInputAccessoryView<MockRequest, MockRecord>(
        label: 'Test Label',
        bindTo: 'testBindTo',
        displayValue: (context, record) => 'Display Value',
        placeholderText: 'Select an item',
        template: (context, record) => MockTemplate(),
        listEndpoint: mockListEndpoint,
      );
    });

    test('build() includes all required properties in featureData', () {
      final result = accessoryView.build(context);

      expect(
        result.featureData['selectListInput'],
        isA<Map<String, dynamic>>(),
      );
      expect(
        result.featureData['selectListInput']['label'],
        equals('Test Label'),
      );
      expect(
        result.featureData['selectListInput']['displayValue'],
        equals('Display Value'),
      );
      expect(result.featureData['selectListInput']['allowClear'], equals(true));
      expect(result.featureData['selectListInput']['list'], equals('mockList'));
      expect(
        result.featureData['selectListInput']['template'],
        isA<Map<String, dynamic>>(),
      );
    });

    test('build() excludes optional properties when not set', () {
      final result = accessoryView.build(context);

      expect(
        result.featureData['selectListInput'].containsKey('visibleWhen'),
        equals(false),
      );
      expect(
        result.featureData['selectListInput'].containsKey('filters'),
        equals(false),
      );
      expect(
        result.featureData['selectListInput'].containsKey('sort'),
        equals(false),
      );
    });

    test('build() includes optional properties when set', () {
      // Create an accessory view with optional properties set
      final conditionalAccessoryView =
          SelectListInputAccessoryView<MockRequest, MockRecord>(
            label: 'Test Label',
            bindTo: 'testBindTo',
            displayValue: (context, record) => 'Display Value',
            placeholderText: 'Select an item',
            template: (context, record) => MockTemplate(),
            listEndpoint: mockListEndpoint,
            visibleWhen: StringEquals(MockRecord().name, 'test'),
            sort: 'name:asc',
          );

      final result = conditionalAccessoryView.build(context);

      expect(
        result.featureData['selectListInput'].containsKey('visibleWhen'),
        equals(true),
      );
      expect(
        result.featureData['selectListInput'].containsKey('sort'),
        equals(true),
      );
      expect(result.featureData['selectListInput']['sort'], equals('name:asc'));
    });

    test('build() bubbles up template in BuildResult', () {
      final result = accessoryView.build(context);

      expect(result.templates, isNotEmpty);
      expect(result.templates.length, equals(1));
      expect(result.templates[0], isA<MockTemplate>());
      expect(result.templates[0].id, equals('mockTemplate'));
    });
  });

  group('SegmentedControlAccessoryView Tests', () {
    late BuildContext context;
    late SegmentedControlAccessoryView accessoryView;

    setUp(() {
      context = BuildContext(user: User());

      final segments = [
        SegmentItem(title: 'Option 1', value: 'value1'),
        SegmentItem(title: 'Option 2', value: 'value2'),
      ];

      accessoryView = SegmentedControlAccessoryView(
        segments: segments,
        defaultValue: 'value1',
        bindTo: 'testBindTo',
      );
    });

    test('build() includes all required properties in featureData', () {
      final result = accessoryView.build(context);

      expect(
        result.featureData['segmentedControlInput'],
        isA<Map<String, dynamic>>(),
      );
      expect(
        result.featureData['segmentedControlInput']['segments'],
        isA<List>(),
      );
      expect(
        result.featureData['segmentedControlInput']['segments'].length,
        equals(2),
      );
      expect(
        result.featureData['segmentedControlInput']['default'],
        equals('value1'),
      );
      expect(
        result.featureData['segmentedControlInput']['bindTo'],
        equals('testBindTo'),
      );
    });

    test('build() excludes optional properties when not set', () {
      final result = accessoryView.build(context);

      expect(
        result.featureData['segmentedControlInput'].containsKey('visibleWhen'),
        equals(false),
      );
    });

    test('build() includes optional properties when set', () {
      // Create a mock record with fields for the test
      final mockRecord = MockRecord()..register();

      final segments = [
        SegmentItem(title: 'Option 1', value: 'value1'),
        SegmentItem(title: 'Option 2', value: 'value2'),
      ];

      final conditionalAccessoryView = SegmentedControlAccessoryView(
        segments: segments,
        defaultValue: 'value1',
        bindTo: 'testBindTo',
        visibleWhen: StringEquals(mockRecord.name, 'test'),
      );

      final result = conditionalAccessoryView.build(context);

      expect(
        result.featureData['segmentedControlInput'].containsKey('visibleWhen'),
        equals(true),
      );
    });

    test('build() correctly formats segment items', () {
      final result = accessoryView.build(context);

      final segments =
          result.featureData['segmentedControlInput']['segments'] as List;
      expect(segments[0], isA<Map<String, dynamic>>());
      expect(segments[0]['title'], equals('Option 1'));
      expect(segments[0]['value'], equals('value1'));
      expect(segments[1]['title'], equals('Option 2'));
      expect(segments[1]['value'], equals('value2'));
    });

    test('build() validates defaultValue is a valid segment', () {
      final segments = [
        SegmentItem(title: 'Option 1', value: 'value1'),
        SegmentItem(title: 'Option 2', value: 'value2'),
      ];

      // Should work fine with valid default value
      final validAccessoryView = SegmentedControlAccessoryView(
        segments: segments,
        defaultValue: 'value1',
        bindTo: 'testBindTo',
      );

      final result = validAccessoryView.build(context);
      expect(result.errors, isEmpty);

      // Should fail with invalid default value
      bool assertionTriggered = false;
      try {
        SegmentedControlAccessoryView(
          segments: segments,
          defaultValue: 'invalidValue',
          bindTo: 'testBindTo',
        );
      } catch (e) {
        assertionTriggered = true;
      }

      expect(assertionTriggered, isTrue);
    });
  });
}
