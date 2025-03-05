import 'package:apptree_dart_sdk/apptree.dart';

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
            statement: json_extract(record,'$.Status.ClosingStatusFlag') = ? AND ActiveFlag = ?
            record.Status.ClosingStatusFlag.equals(false).and(record.ActiveFlag).equals('TRUE')
            values:
              - false
              - 'TRUE'
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

class SelectListInputAccessoryView<I extends Request, T extends Record>
    extends AccessoryView {
  final String label;
  final String bindTo;
  final String displayValue;
  final String placeholderText;
  final bool allowClear;
  final List<ListFilter>? filters;
  final String? sort;
  final TemplateBuilder<T> template;
  final ListEndpoint<I, T> listEndpoint;

  SelectListInputAccessoryView({
    super.visibleWhen,
    required this.label,
    required this.bindTo,
    required this.displayValue,
    required this.placeholderText,
    this.allowClear = true,
    this.filters,
    this.sort,
    required this.template,
    required this.listEndpoint,
  });

  @override
  BuildResult build(BuildContext context) {
    var filterResults = <BuildResult>[];
    if (filters != null) {
      filterResults = filters!.map((filter) => filter.build(context)).toList();
    }
    var filterErrors = filterResults.expand((result) => result.errors).toList();
    var filterData = filterResults.map((result) => result.featureData).toList();

    BuildError? rootBuildError;
    List<BuildError> childBuildErrors = [];

    if (filterErrors.isNotEmpty) {
      childBuildErrors.addAll(filterErrors);
    }

    var templateResult = template(context, listEndpoint.record);
    var templateBuildResult = templateResult.build(context);

    childBuildErrors.addAll(templateBuildResult.errors);

    if (childBuildErrors.isNotEmpty) {
      rootBuildError = BuildError(
        message: 'Filters contain errors',
        identifier: 'SelectListInput bound to $bindTo',
        childErrors: childBuildErrors,
      );
    }

    return BuildResult(
      childFeatures: [],
      errors: rootBuildError != null ? [rootBuildError] : [],
      templates: [templateResult],
      featureData: {
        'selectListInput': {
          'label': label,
          if (visibleWhen != null) 'visibleWhen': visibleWhen?.toString(),
          'allowClear': allowClear,
          if (filters != null && filters!.isNotEmpty) 'filters': filterData,
          if (sort != null) 'sort': sort,
          'list': listEndpoint.id,
          'template': templateBuildResult.featureData,
        },
      },
    );
  }
}

class SegmentedControlAccessoryView extends AccessoryView {
  final List<SegmentItem> segments;
  final String defaultValue;
  final String bindTo;

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
    var buildErrors = <BuildError>[];
    var defaultIsValid = segments.any(
      (segment) => segment.value == defaultValue,
    );

    if (!defaultIsValid) {
      buildErrors.add(
        BuildError(
          message: 'defaultValue must be a valid segment',
          identifier: 'SegmentedControlAccessoryView',
        ),
      );
    }

    return BuildResult(
      childFeatures: [],
      errors: buildErrors,
      featureData: {
        'segmentedControlInput': {
          if (visibleWhen != null) 'visibleWhen': visibleWhen?.toString(),
          'segments': segments.map((segment) => segment.toJson()).toList(),
          'default': defaultValue,
          'bindTo': bindTo,
        },
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
