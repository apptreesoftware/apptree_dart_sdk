import "package:apptree_dart_sdk/apptree.dart";

class Form<I extends Record> extends Feature {
  final FormToolbarBuilder<I>? toolbarBuilder;
  final FormFieldsBuilder<I> fieldsBuilder;
  late I record;

  Form({
    required super.id,
    required this.toolbarBuilder,
    required this.fieldsBuilder,
  }) {
    record = instantiateRecord<I>();
  }

  @override
  BuildResult build(BuildContext context) {
    var fields = fieldsBuilder(context, record);
    var fieldMap = <String, Map<String, dynamic>>{};

    var builder = BuildResultBuilder();
    for (var field in fields) {
      var buildResult = field.build(context);
      fieldMap[field.id] = buildResult.featureData;
      builder.addResult(buildResult);
    }

    var layouts = fields.map((field) => field.layoutInfo).toList();
    var toolbar = builder.addResult(
      toolbarBuilder?.call(context, record).build(context),
    );
    var featureData = {
      id: {
        "form": {
          "fields": fieldMap,
          "layout": layouts,
          if (toolbar != null) "toolbar": toolbar.featureData,
        },
      },
    };

    return builder.build(featureData, 'Form: $id');
  }
}

enum LayoutDirection { vertical, horizontal }

class FormFieldLayoutSize {
  final int xs;
  final int sm;
  final int md;
  final int lg;
  final int xl;

  const FormFieldLayoutSize({
    this.xs = 12,
    this.sm = 12,
    this.md = 12,
    this.lg = 12,
    this.xl = 12,
  });

  static const FormFieldLayoutSize defaultSize = FormFieldLayoutSize();
}

abstract class FormField {
  final Conditional? visibleWhen;
  final LayoutDirection layoutDirection;
  final FormFieldLayoutSize layoutSize;
  final String id;

  FormField({
    this.visibleWhen,
    required this.id,
    this.layoutDirection = LayoutDirection.vertical,
    this.layoutSize = FormFieldLayoutSize.defaultSize,
  });

  FormFieldLayoutInfo get layoutInfo =>
      FormFieldLayoutInfo(direction: layoutDirection, size: layoutSize, id: id);

  BuildResult build(BuildContext context);
}

class FormFieldLayoutInfo {
  final LayoutDirection direction;
  final FormFieldLayoutSize size;
  final String id;

  FormFieldLayoutInfo({
    required this.direction,
    required this.size,
    required this.id,
  });

  dynamic toJson() {
    if (direction == LayoutDirection.vertical &&
        size == FormFieldLayoutSize.defaultSize) {
      return id;
    }

    return {
      id: {
        "direction": direction.name,
        "size": {
          if (size.xs != FormFieldLayoutSize.defaultSize.xs) "xs": size.xs,
          if (size.sm != FormFieldLayoutSize.defaultSize.sm) "sm": size.sm,
          if (size.md != FormFieldLayoutSize.defaultSize.md) "md": size.md,
          if (size.lg != FormFieldLayoutSize.defaultSize.lg) "lg": size.lg,
          if (size.xl != FormFieldLayoutSize.defaultSize.xl) "xl": size.xl,
        },
      },
    };
  }
}

class Header extends FormField {
  final String title;

  Header({
    required this.title,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    required super.id,
  });

  @override
  BuildResult build(BuildContext context) {
    return BuildResult(
      buildIdentifier: 'Header: $id',
      featureData: {
        "header": {
          "title": title,
          if (visibleWhen != null) "visibleWhen": visibleWhen.toString(),
        },
      },
      childFeatures: [],
      endpoints: [],
    );
  }
}

abstract class BindingFormField extends FormField {
  final FieldBase bindTo;

  BindingFormField({
    required this.bindTo,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    required super.id,
  });
  (String?, BuildError?) buildBinding() {
    try {
      return (bindTo.bindingFieldPath, null);
    } catch (e) {
      return (null, BuildError(identifier: id, message: e.toString()));
    }
  }
}

class TextInput extends BindingFormField {
  final String title;
  final bool required;

  TextInput({
    required this.title,
    required super.bindTo,
    required this.required,
    required super.id,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
  });

  @override
  BuildResult build(BuildContext context) {
    var (bindingFieldPath, error) = buildBinding();
    return BuildResult(
      buildIdentifier: 'TextInput: $id',
      featureData: {
        "textInput": {
          "title": title,
          "bindTo": bindingFieldPath,
          "required": required,
          if (visibleWhen != null) "visibleWhen": visibleWhen.toString(),
        },
      },
      childFeatures: [],
      errors: error != null ? [error] : [],
      endpoints: [],
    );
  }
}

class Text extends FormField {
  final String title;
  final String displayValue;

  Text({
    required this.title,
    required this.displayValue,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    required super.id,
  });

  @override
  BuildResult build(BuildContext context) {
    return BuildResult(
      buildIdentifier: 'Text: $id',
      featureData: {
        "text": {
          "title": title,
          "displayValue": displayValue,
          if (visibleWhen != null) "visibleWhen": visibleWhen.toString(),
        },
      },
      childFeatures: [],
      endpoints: [],
    );
  }
}

// class RecordListFormField extends FormField {
//   final String title;
//   final FormRecordListBuilder builder;

//   RecordListFormField({
//     required this.title,
//     required this.builder,
//     super.visibleWhen,
//   });

//   @override
//   Map<String, dynamic> toDict() {
//     Feature feature = builder.build();
//     return {
//       "recordList": feature.toDict(),
//       "visibleWhen": visibleWhen == null ? "" : visibleWhen.toString(),
//     };
//   }
// }
