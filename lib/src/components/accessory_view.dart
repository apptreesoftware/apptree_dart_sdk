import 'package:apptree_dart_sdk/models.dart';

abstract class AccessoryView {
  Conditional? visibleWhen;

  AccessoryView({this.visibleWhen});

  BuildResult build(BuildContext context);
}

/*
    - selectListInput:
        allowClear: true
        label: "Status"
        list: requestStatuses
        displayValue: "${context().woWorkbenchStatusMultiFilter.map('Name').join(', ')}"
        # displayValue: Name
        value: Name
        bindTo: woWorkbenchStatusMultiFilter
        placeholderText: "Select to filter"
        filters:
          - when: context().woWorkbenchStatusFilter == 'todo'
            statement: json_extract(record,'$.Status.ClosingStatusFlag') = ? AND ActiveFlag = 'TRUE'
            values:
              - false
          - when: context().woWorkbenchStatusFilter == 'complete' 
            statement: json_extract(record,'$.Status.ClosingStatusFlag') = ? AND ActiveFlag = 'TRUE'
            values:
              - true
        sort: TabOrder ASC
        multiSelect: true
        template:
          id: title
          vars:
            title: "{{Name}}"
*/

// class SelectListInputAccessoryView extends AccessoryView {
//   final String label;
//   final StringField bindTo;
//   final List<SegmentItem> segments;
//   final StringField displayValue;
//   final String placeholderText;
//   final bool allowClear;
//   final bool multiSelect;
//   final List<Conditional> filters;
//   final StringField sort;
//   final StringField template;

// }

class SegmentedControlAccessoryView extends AccessoryView {
  final List<SegmentItem> segments;
  final String defaultValue;
  final StringField bindTo;

  SegmentedControlAccessoryView({
    required this.segments,
    required this.defaultValue,
    required this.bindTo,
  }) : assert(
         segments.any((segment) => segment.value == defaultValue),
         'defaultValue must be a valid segment',
       );

  @override
  BuildResult build(BuildContext context) {
    return BuildResult(
      childFeatures: [],
      featureData: {
        'segments': segments.map((segment) => segment.toJson()).toList(),
        'defaultValue': defaultValue,
        'bindTo': bindTo.value,
      },
    );
  }
}

class SegmentItem {
  final String title;
  final String value;

  SegmentItem({required this.title, required this.value});

  Map<String, dynamic> toJson() {
    return {'title': title, 'value': value};
  }
}
