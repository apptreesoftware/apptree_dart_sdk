import "package:apptree_dart_sdk/base.dart";
import "package:apptree_dart_sdk/src/models/expression.dart";

class Form<I extends Record> extends Feature {
  final ToolbarBuilder toolbarBuilder;
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
    for (var field in fields) {
      fieldMap[field.id] = field.build(context);
    }

    var layouts = fields.map((field) => field.layoutInfo).toList();
    var featureData = {
      id: {
        "form": {
          "toolbar": toolbarBuilder(context).toDict(),
          "fields": fieldMap,
          "layout": layouts,
        },
      },
    };
    return BuildResult(featureData: featureData, childFeatures: []);
  }
}

class Toolbar {
  final List<ToolbarItem> items;

  Toolbar({required this.items});

  Map<String, dynamic> toDict() {
    return {"items": items.map((item) => item.toDict()).toList()};
  }
}

class ToolbarItem {
  final String title;
  final List<ToolbarAction> actions;

  ToolbarItem({required this.title, required this.actions});

  Map<String, dynamic> toDict() {
    return {
      "title": title,
      "actions": actions.map((action) => action.toDict()).toList(),
    };
  }
}

abstract class ToolbarAction {
  Map<String, dynamic> toDict();
}

class SubmitFormAction extends ToolbarAction {
  final String url;
  final String title;

  SubmitFormAction({required this.url, required this.title});

  @override
  Map<String, dynamic> toDict() {
    return {
      "submitForm": {"url": url, "title": title},
    };
  }
}

// class FormFields {
//   final Map<String, FormField> fields;
//   //List<RecordListFormField> recordListFields = [];

//   FormFields({required this.fields}) {
//     for (var field in fields.values) {
//       // if (field is RecordListFormField) {
//       //   recordListFields.add(field);
//       // }
//     }
//   }

//   // List<RecordListFormField> getRecordListFields() {
//   //   return recordListFields;
//   // }

//   Map<String, dynamic> toDict() {
//     return fields.map((key, value) => MapEntry(key, value.toDict()));
//   }
// }

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

  Map<String, dynamic> build(BuildContext context);
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
  Map<String, dynamic> build(BuildContext context) {
    return {
      "header": {
        "title": title,
        if (visibleWhen != null) "visibleWhen": visibleWhen.toString(),
      },
    };
  }
}

class TextInput extends FormField {
  final String title;
  final Field bindTo; // TODO: This should be a Field object
  final bool required;

  TextInput({
    required this.title,
    required this.bindTo,
    required this.required,
    required super.id,
    super.visibleWhen,
    super.layoutDirection,
    super.layoutSize,
  });

  @override
  Map<String, dynamic> build(BuildContext context) {
    return {
      "textInput": {
        "title": title,
        "bindTo": bindTo.relativeFieldPath,
        "required": required,
        if (visibleWhen != null) "visibleWhen": visibleWhen.toString(),
      },
    };
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
  Map<String, dynamic> build(BuildContext context) {
    return {
      "text": {
        "title": title,
        "displayValue": displayValue,
        if (visibleWhen != null) "visibleWhen": visibleWhen.toString(),
      },
    };
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
