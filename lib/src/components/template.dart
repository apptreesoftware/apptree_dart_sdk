import 'package:apptree_dart_sdk/src/components/generic.dart';

class Template {
  final String id;
  final Values values;
  bool isFormTemplate = false;

  Template({required this.id, required this.values});

  void setIsFormTemplate(bool isFormTemplate) {
    this.isFormTemplate = isFormTemplate;
  }

  Map<String, dynamic> toDict() {
      return {
        'id': id,
        'values': values.toDict()
    };
  }
}
