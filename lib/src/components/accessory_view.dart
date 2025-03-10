import 'package:apptree_dart_sdk/apptree.dart';

abstract class AccessoryView {
  Conditional? visibleWhen;

  AccessoryView({this.visibleWhen});

  BuildResult build(BuildContext context);
}

class SelectListInputAccessoryView<I extends Request, T extends Record>
    extends AccessoryView {
  final String label;
  final String bindTo;
  final DisplayValueBuilder<T> displayValue;
  final String placeholderText;
  final bool allowClear;
  final List<ListFilter>? filters;
  final String? sort;
  final RecordTemplateBuilder<T> template;
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
    var builder = BuildResultBuilder();
    if (filters != null) {
      filterResults = builder.addResults(
        filters!.map((filter) => filter.build(context)).toList(),
      );
    }

    var filterData = filterResults.map((result) => result.featureData).toList();
    var displayValueFormat = displayValue(context, listEndpoint.record);

    var templateResult = template(context, listEndpoint.record);
    var templateBuildResult = builder.addResult(templateResult.build(context));
    if (bindTo.isEmpty) {
      builder.addError(
        BuildError(
          message: 'bindTo cannot be empty',
          identifier: 'SelectListInputAccessoryView',
        ),
      );
    }
    //childBuildErrors.addAll(templateBuildResult.errors);

    return builder.build({
      'selectListInput': {
        'label': label,
        'displayValue': displayValueFormat,
        if (visibleWhen != null) 'visibleWhen': visibleWhen?.toString(),
        'allowClear': allowClear,
        if (filters != null && filters!.isNotEmpty) 'filters': filterData,
        if (sort != null) 'sort': sort,
        'list': listEndpoint.id,
        'template': templateBuildResult?.featureData,
      },
    }, 'SelectListInput bound to $bindTo');
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
    super.visibleWhen,
  });

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
    if (segments.length < 2) {
      buildErrors.add(
        BuildError(
          message: 'At least 2 segments are required',
          identifier: 'SegmentedControlAccessoryView',
        ),
      );
    }
    return BuildResult(
      buildIdentifier: 'SegmentedControlAccessoryView bound to $bindTo',
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
      endpoints: [],
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

class TemplateAccessoryView extends AccessoryView {
  final TemplateBuilder template;

  TemplateAccessoryView({required this.template, super.visibleWhen});

  @override
  BuildResult build(BuildContext context) {
    var templateResult = template(context);

    var templateBuildResult = templateResult.build(context);

    var childBuildErrors = templateBuildResult.errors;
    BuildError? rootBuildError;

    if (childBuildErrors.isNotEmpty) {
      rootBuildError = BuildError(
        message: 'Template contains errors',
        identifier: 'TemplateAccessoryView',
        childErrors: childBuildErrors,
      );
    }

    return BuildResult(
      buildIdentifier: 'TemplateAccessoryView',
      childFeatures: [],
      templates: [templateResult],
      errors: rootBuildError != null ? [rootBuildError] : [],
      featureData: {
        'dynamic': {
          'template': templateBuildResult.featureData,
          if (visibleWhen != null) 'visibleWhen': visibleWhen?.toString(),
        },
      },
      endpoints: [],
    );
  }
}
