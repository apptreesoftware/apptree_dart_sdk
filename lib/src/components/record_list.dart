import 'package:apptree_dart_sdk/src/components/feature.dart';
import 'package:apptree_dart_sdk/src/components/callback.dart';
import 'package:apptree_dart_sdk/src/components/view.dart';
import 'package:apptree_dart_sdk/src/components/template.dart';

class RecordList extends Feature {  
  final OnLoad onLoad;
  final String dataSource;
  final String noResultsText;
  final bool showDivider;
  final List<TopAccessoryView> topAccessoryViews;
  final Template template;
  final OnItemSelected onItemSelected;

  RecordList({required super.id, required this.onLoad, required this.dataSource, required this.noResultsText, required this.showDivider, required this.topAccessoryViews, required this.template, required this.onItemSelected});

  @override
  Map<String, dynamic> toDict() {
    return {
      "record_list": {
        "id": id,
        "onLoad": onLoad.toDict(),
        "dataSource": dataSource,
        "noResultsText": noResultsText,
        "showDivider": showDivider,
        "topAccessoryViews": topAccessoryViews.map((view) => view.toDict()).toList(),
        "template": template.toDict(),
        "onItemSelected": onItemSelected.toDict(),
      },
    };
  }
}

class FormRecordList extends Feature {
  final OnLoad onLoad;
  final String dataSource;
  final String noResultsText;
  final bool showDivider;
  final List<TopAccessoryView> topAccessoryViews;
  final Template template;
  final OnItemSelectedForm onItemSelectedForm;

  FormRecordList({required super.id, required this.onLoad, required this.dataSource, required this.noResultsText, required this.showDivider, required this.topAccessoryViews, required this.template, required this.onItemSelectedForm});
  
  @override
  Map<String, dynamic> toDict() {
    return {
      "record_list": {
        "id": id,
        "onLoad": onLoad.toDict(),
        "dataSource": dataSource,
        "noResultsText": noResultsText,
        "showDivider": showDivider,
        "topAccessoryViews": topAccessoryViews.map((view) => view.toDict()).toList(),
        "template": template.toDict(),
        "onItemSelected": onItemSelectedForm.toDict(),
      },
    };
  }
}