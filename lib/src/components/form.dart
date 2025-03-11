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
  final bool showBorder;
  final String title;

  const FormField({
    this.visibleWhen,
    required this.id,
    this.layoutDirection = LayoutDirection.vertical,
    this.layoutSize = FormFieldLayoutSize.defaultSize,
    this.showBorder = true,
    required this.title,
  });

  FormFieldLayoutInfo get layoutInfo =>
      FormFieldLayoutInfo(direction: layoutDirection, size: layoutSize, id: id);

  BuildResult build(BuildContext context);

  Map<String, dynamic> get baseData {
    return {
      if (showBorder) "showBorder": showBorder,
      "title": title,
      if (visibleWhen != null) "visibleWhen": visibleWhen.toString(),
    };
  }
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
  Header({
    required super.title,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    required super.id,
  });

  @override
  BuildResult build(BuildContext context) {
    var baseData = super.baseData;
    return BuildResult(
      buildIdentifier: 'Header: $id',
      featureData: {"header": baseData},
      childFeatures: [],
      endpoints: [],
    );
  }
}

abstract class BindingFormField extends FormField {
  final FieldBase bindTo;

  const BindingFormField({
    required super.id,
    required super.title,
    required this.bindTo,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.showBorder,
  });
  (String?, BuildError?) buildBinding() {
    try {
      return (bindTo.bindingFieldPath, null);
    } catch (e) {
      return (null, BuildError(identifier: id, message: e.toString()));
    }
  }

  @override
  Map<String, dynamic> get baseData {
    var baseData = super.baseData;
    baseData["bindTo"] = bindTo.bindingFieldPath;
    return baseData;
  }
}

abstract class FormInputField extends BindingFormField {
  final bool required;
  final bool editable;
  final Conditional? requiredWhen;
  final Conditional? enabledWhen;
  final List<FormAction>? onValueChanged;

  const FormInputField({
    required super.bindTo,
    required super.id,
    required super.title,
    super.showBorder,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    this.required = false,
    this.editable = true,
    this.requiredWhen,
    this.enabledWhen,
    this.onValueChanged,
  });

  @override
  Map<String, dynamic> get baseData {
    var baseData = super.baseData;
    baseData["title"] = title;
    baseData["required"] = required;
    baseData["editable"] = editable;
    if (requiredWhen != null) {
      baseData["requiredWhen"] = requiredWhen.toString();
    }
    if (enabledWhen != null) {
      baseData["enabledWhen"] = enabledWhen.toString();
    }
    if (visibleWhen != null) {
      baseData["visibleWhen"] = visibleWhen.toString();
    }
    return baseData;
  }
}

enum TextCapitalization {
  /// Defaults to an uppercase keyboard for the first letter of each word.
  ///
  /// Corresponds to `InputType.TYPE_TEXT_FLAG_CAP_WORDS` on Android, and
  /// `UITextAutocapitalizationTypeWords` on iOS.
  words,

  /// Defaults to an uppercase keyboard for the first letter of each sentence.
  ///
  /// Corresponds to `InputType.TYPE_TEXT_FLAG_CAP_SENTENCES` on Android, and
  /// `UITextAutocapitalizationTypeSentences` on iOS.
  sentences,

  /// Defaults to an uppercase keyboard for each character.
  ///
  /// Corresponds to `InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS` on Android, and
  /// `UITextAutocapitalizationTypeAllCharacters` on iOS.
  characters,

  /// Defaults to a lowercase keyboard.
  none,
}

class TextInput extends FormInputField {
  final int? minLength;
  final int? maxLength;
  final bool barcodeScanEnabled;
  final TextCapitalization textCapitalization;
  final bool isMultiline;

  const TextInput({
    required super.id,
    required super.title,
    required super.bindTo,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.showBorder,
    super.onValueChanged,
    super.requiredWhen,
    super.enabledWhen,
    super.required,
    super.editable,
    this.minLength,
    this.maxLength,
    this.barcodeScanEnabled = false,
    this.textCapitalization = TextCapitalization.none,
    this.isMultiline = false,
  });

  @override
  BuildResult build(BuildContext context) {
    var (bindingFieldPath, error) = buildBinding();
    return BuildResult(
      buildIdentifier: 'TextInput: $id',
      featureData: {
        "textInput": {
          ...baseData,
          "isMultiline": isMultiline,
          "textCapitalization": textCapitalization.name,
          "barcodeScanEnabled": barcodeScanEnabled,
          if (minLength != null) "minLength": minLength,
          if (maxLength != null) "maxLength": maxLength,
        },
      },
      childFeatures: [],
      errors: error != null ? [error] : [],
      endpoints: [],
    );
  }
}

class Text extends FormField {
  final String displayValue;

  Text({
    required super.title,
    required this.displayValue,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    required super.id,
  });

  @override
  BuildResult build(BuildContext context) {
    var baseData = super.baseData;
    return BuildResult(
      buildIdentifier: 'Text: $id',
      featureData: {
        "text": {...baseData, "displayValue": displayValue},
      },
      childFeatures: [],
      endpoints: [],
    );
  }
}

class DurationInput extends FormInputField {
  final int minuteInterval;
  final int maxDuration;
  final String? minuteIntervalBinding;

  const DurationInput({
    this.minuteInterval = 1,
    this.maxDuration = 3600,
    this.minuteIntervalBinding,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    required super.bindTo,
    required super.id,
    required super.title,
    super.required = false,
    super.editable = true,
  });

  @override
  BuildResult build(BuildContext context) {
    var (bindingFieldPath, error) = buildBinding();
    return BuildResult(
      buildIdentifier: 'FormDurationInputField: $id',
      featureData: {
        "durationInput": {
          ...baseData,
          "minuteInterval": minuteInterval,
          "maxDuration": maxDuration,
          if (minuteIntervalBinding != null)
            "minuteIntervalBinding": minuteIntervalBinding,
        },
      },
      childFeatures: [],
      errors: error != null ? [error] : [],
      endpoints: [],
    );
  }
}

class DateInput extends FormInputField {
  const DateInput({
    required super.id,
    required super.title,
    required super.bindTo,
    super.required,
    super.editable,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.showBorder,
    super.onValueChanged,
    super.requiredWhen,
    super.enabledWhen,
  });

  @override
  BuildResult build(BuildContext context) {
    var (bindingFieldPath, error) = buildBinding();
    return BuildResult(
      buildIdentifier: 'FormDateInputField: $id',
      featureData: {
        "dateInput": {...baseData},
      },
      childFeatures: [],
      errors: error != null ? [error] : [],
      endpoints: [],
    );
  }
}

class TimeInput extends FormInputField {
  const TimeInput({
    required super.id,
    required super.title,
    required super.bindTo,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.showBorder,
    super.onValueChanged,
    super.requiredWhen,
    super.enabledWhen,
  });

  @override
  BuildResult build(BuildContext context) {
    var (bindingFieldPath, error) = buildBinding();
    return BuildResult(
      buildIdentifier: 'FormTimeInputField: $id',
      featureData: {
        "timeInput": {...baseData},
      },
      childFeatures: [],
      errors: error != null ? [error] : [],
      endpoints: [],
    );
  }
}

enum NumberInputFormat { none, decimal, currency }

class NumberInput extends FormInputField {
  final NumberInputFormat numberFormat;

  const NumberInput({
    required super.id,
    required super.title,
    required super.bindTo,
    super.required,
    super.editable,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.showBorder,
    super.onValueChanged,
    super.requiredWhen,
    super.enabledWhen,
    this.numberFormat = NumberInputFormat.none,
  });

  @override
  BuildResult build(BuildContext context) {
    var (bindingFieldPath, error) = buildBinding();
    return BuildResult(
      buildIdentifier: 'FormNumberInputField: $id',
      featureData: {
        "numberInput": {...baseData, "numberFormat": numberFormat.name},
      },
      childFeatures: [],
      errors: error != null ? [error] : [],
      endpoints: [],
    );
  }
}

class BarcodeInput extends FormInputField {
  const BarcodeInput({
    required super.id,
    required super.title,
    required super.bindTo,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.showBorder,
    super.onValueChanged,
    super.requiredWhen,
    super.enabledWhen,
  });

  @override
  BuildResult build(BuildContext context) {
    var (bindingFieldPath, error) = buildBinding();
    return BuildResult(
      buildIdentifier: 'FormBarcodeInputField: $id',
      featureData: {
        "barcodeInput": {...baseData},
      },
      childFeatures: [],
      errors: error != null ? [error] : [],
      endpoints: [],
    );
  }
}

class SignatureInput extends FormInputField {
  final String? placeholderText;
  const SignatureInput({
    required super.id,
    required super.title,
    required super.bindTo,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.showBorder,
    super.onValueChanged,
    super.requiredWhen,
    super.enabledWhen,
    this.placeholderText,
  });

  @override
  BuildResult build(BuildContext context) {
    var (bindingFieldPath, error) = buildBinding();
    return BuildResult(
      buildIdentifier: 'FormSignatureInputField: $id',
      featureData: {
        "signatureInput": {
          ...baseData,
          if (placeholderText != null) "placeholderText": placeholderText,
        },
      },
      childFeatures: [],
      errors: error != null ? [error] : [],
      endpoints: [],
    );
  }
}

class StarRatingInput extends FormInputField {
  final Color? color;
  final int starCount;
  const StarRatingInput({
    required super.id,
    required super.title,
    required super.bindTo,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.showBorder,
    super.onValueChanged,
    super.requiredWhen,
    super.enabledWhen,
    this.color,
    this.starCount = 5,
  });

  @override
  BuildResult build(BuildContext context) {
    var (bindingFieldPath, error) = buildBinding();
    return BuildResult(
      buildIdentifier: 'FormStarRatingInputField: $id',
      featureData: {
        "starRatingInput": {
          ...baseData,
          if (color != null) "color": color?.hex,
          "starCount": starCount,
        },
      },
      childFeatures: [],
      errors: error != null ? [error] : [],
      endpoints: [],
    );
  }
}

class MapInputField extends FormInputField {
  final MapSettings mapSettings;

  MapInputField({
    required super.bindTo,
    required super.id,
    required super.title,
    super.showBorder,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.required,
    super.editable,
    super.requiredWhen,
    super.enabledWhen,
    super.onValueChanged,
    required this.mapSettings,
  });

  @override
  BuildResult build(BuildContext context) {
    var (bindingFieldPath, error) = buildBinding();
    return BuildResult(
      buildIdentifier: 'FormMapInputField: $id',
      featureData: {
        "mapInput": {...baseData, "mapSettings": mapSettings.toDict()},
      },
      childFeatures: [],
      errors: error != null ? [error] : [],
      endpoints: [],
    );
  }
}

class SelectListInput<I extends Record> extends FormInputField {
  final ListEndpoint<I> endpoint;
  final String displayFormat;
  final TemplateBuilder template;
  final bool barcodeScanEnabled;
  final bool allowClear;
  final bool multiSelect;
  final int minimumSearchLength;

  const SelectListInput({
    required super.id,
    required super.title,
    required super.bindTo,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.required,
    super.editable,
    super.requiredWhen,
    super.enabledWhen,
    super.onValueChanged,
    required this.endpoint,
    required this.displayFormat,
    required this.template,
    this.barcodeScanEnabled = false,
    this.allowClear = true,
    this.multiSelect = false,
    this.minimumSearchLength = 3,
  });

  @override
  BuildResult build(BuildContext context) {
    var template = this.template(context);
    var builder = BuildResultBuilder();
    var errors = <BuildError>[];

    var templateResult = builder.addResult(template.build(context));
    if (templateResult?.errors != null) {
      errors.addAll(templateResult!.errors);
    }

    var (bindingFieldPath, error) = buildBinding();
    if (error != null) {
      errors.add(error);
    }
    var baseData = super.baseData;

    return BuildResult(
      buildIdentifier: 'FormSelectListInputField: $id',
      featureData: {
        "selectListInput": {
          ...baseData,
          "list": endpoint.id,
          "displayFormat": displayFormat,
          "template": templateResult?.featureData,
          if (barcodeScanEnabled) "barcodeScanEnabled": barcodeScanEnabled,
          if (allowClear) "allowClear": allowClear,
          if (multiSelect) "multiSelect": multiSelect,
          if (minimumSearchLength != 3)
            "minimumSearchLength": minimumSearchLength,
        },
      },
      childFeatures: [],
      errors: errors,
      endpoints: [],
    );
  }
}

class HierarchicalSelectListInput<I extends Record> extends SelectListInput<I> {
  final String parentKeyField;
  final String? breadcrumbKey;
  final String? initialSelectionPk;

  const HierarchicalSelectListInput({
    required super.id,
    required super.title,
    required super.bindTo,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.required,
    super.editable,
    super.requiredWhen,
    super.enabledWhen,
    super.onValueChanged,
    required super.endpoint,
    required super.displayFormat,
    required super.template,
    required this.parentKeyField,
    required this.breadcrumbKey,
    required this.initialSelectionPk,
  });

  @override
  BuildResult build(BuildContext context) {
    var template = this.template(context);
    var builder = BuildResultBuilder();
    var errors = <BuildError>[];

    var templateResult = builder.addResult(template.build(context));
    if (templateResult?.errors != null) {
      errors.addAll(templateResult!.errors);
    }

    var (bindingFieldPath, error) = buildBinding();
    if (error != null) {
      errors.add(error);
    }
    var baseData = super.baseData;

    return BuildResult(
      buildIdentifier: 'FormHierarchicalSelectListInputField: $id',
      featureData: {
        "hierarchicalSelectListInput": {
          ...baseData,
          "list": endpoint.id,
          "displayFormat": displayFormat,
          "template": templateResult?.featureData,
          "parentKeyField": parentKeyField,
          "breadcrumbKey": breadcrumbKey,
          "initialSelectionPk": initialSelectionPk,
          if (barcodeScanEnabled) "barcodeScanEnabled": barcodeScanEnabled,
          if (allowClear) "allowClear": allowClear,
          if (multiSelect) "multiSelect": multiSelect,
          if (minimumSearchLength != 3)
            "minimumSearchLength": minimumSearchLength,
        },
      },
      childFeatures: [],
      errors: errors,
      endpoints: [],
    );
  }
}

class FormRecordList<I extends Record> extends BindingFormField {
  final TemplateBuilder template;
  final String? placeholderText;
  final bool showHeader;
  final String? headerText;
  final bool collapsible;
  final bool collapsed;
  final String? addButtonTitle;
  final Conditional? enabledIf;
  final OnItemSelectedBuilder? onItemSelected;

  FormRecordList({
    required super.id,
    required super.title,
    required this.template,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
    super.showBorder,
    required super.bindTo,
    this.placeholderText,
    this.showHeader = true,
    this.headerText,
    this.collapsible = false,
    this.collapsed = false,
    this.addButtonTitle,
    this.enabledIf,
    this.onItemSelected,
  });

  @override
  BuildResult build(BuildContext context) {
    var template = this.template(context);
    var builder = BuildResultBuilder();
    var errors = <BuildError>[];

    var templateResult = builder.addResult(template.build(context));
    if (templateResult?.errors != null) {
      errors.addAll(templateResult!.errors);
    }

    var (bindingFieldPath, error) = buildBinding();
    if (error != null) {
      errors.add(error);
    }
    var record = instantiateRecord<I>();
    var onItemSelectedResult = onItemSelected?.call(context, record);

    var onItemSelectedResultData = onItemSelectedResult?.build(context);
    if (onItemSelectedResultData != null) {
      errors.addAll(onItemSelectedResultData.errors);
    }

    var baseData = super.baseData;

    return BuildResult(
      buildIdentifier: 'FormRecordList: $id',
      featureData: {
        "recordList": {
          ...baseData,
          "template": templateResult?.featureData,
          if (placeholderText != null) "placeholderText": placeholderText,
          "showHeader": showHeader,
          if (headerText != null) "headerText": headerText,
          if (collapsible) "collapsible": collapsible,
          if (collapsed) "collapsed": collapsed,
          if (addButtonTitle != null) "addButtonTitle": addButtonTitle,
          "bindTo": bindTo,
          if (enabledIf != null) "enabledIf": enabledIf.toString(),
          if (onItemSelectedResultData != null)
            "onItemSelected": onItemSelectedResultData.featureData,
        },
      },
      templates: [
        if (onItemSelectedResultData != null)
          ...(onItemSelectedResultData.templates),
        template,
      ],
      childFeatures: [
        if (onItemSelectedResultData != null)
          ...(onItemSelectedResultData.childFeatures),
      ],
      errors: errors,
    );
  }
}
