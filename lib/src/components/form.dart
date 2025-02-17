import "package:apptree_dart_sdk/src/components/feature.dart";
import "package:yaml_writer/yaml_writer.dart";
class Form extends Feature {
  final Toolbar toolbar;
  final FormFields fields;
  final List<String> layout;

  Form({
    required super.id,
    required this.toolbar,
    required this.fields,
    required this.layout,
  });

  @override
  Map<String, dynamic> toDict() {
    return {
      "form": {
        "id": id,
        "toolbar": toolbar.toDict(),
        "fields": fields.toDict(),
        "layout": layout,
      },
    };
  }

  @override
  String toYaml() {
    return YAMLWriter().write(toDict());
  }
}

class Toolbar {
  final List<ToolbarItem> items;

  Toolbar({required this.items});

  Map<String, dynamic> toDict() {
    return {
      "items": items.map((item) => item.toDict()).toList(),
    };
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
      "submitForm": {
        "url": url,
        "title": title,
      }
    };
  }
}

class FormFields {
  final Map<String, FormField> fields;

  FormFields({required this.fields});

  Map<String, dynamic> toDict() {
    return fields.map((key, value) => MapEntry(key, value.toDict()));
  }
}

abstract class FormField {
  Map<String, dynamic> toDict();
}

class Header extends FormField {
  final String title;

  Header({required this.title});

  @override
  Map<String, dynamic> toDict() {
    return {
      "header": title,
    };
  }
}

class TextInput extends FormField {
  final String title;
  final String bindTo; // TODO: This should be a Field object
  final bool required;

  TextInput(
      {required this.title, required this.bindTo, required this.required});

  @override
  Map<String, dynamic> toDict() {
    return {
      "textInput": {
        "title": title,
        "bindTo": bindTo,
        "required": required,
      },
    };
  }
}

class Text extends FormField {
  final String title;
  final String displayValue;

  Text({required this.title, required this.displayValue});

  @override
  Map<String, dynamic> toDict() {
    return {
      "text": {
        "title": title,
        "displayValue": displayValue,
      },
    };
  }
}
