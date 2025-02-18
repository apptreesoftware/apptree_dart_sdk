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

  RecordList(
      {required super.id,
      required this.onLoad,
      required this.dataSource,
      required this.noResultsText,
      required this.showDivider,
      required this.topAccessoryViews,
      required this.template,
      required this.onItemSelected});

  @override
  Map<String, dynamic> toDict() {
    return {
      id: {
        "recordList": {
          "onLoad": onLoad.toDict(),
          "dataSource": dataSource,
          "noResultsText": noResultsText,
          "showDivider": showDivider,
          "topAccessoryViews":
              topAccessoryViews.map((view) => view.toDict()).toList(),
          "template": template.toDict(),
          "onItemSelected": onItemSelected.toDict(),
        },
      }
    };
  }
}

class FormRecordList extends Feature {
  final String bindTo;
  final String noResultsText;
  final bool showDivider;
  final List<TopAccessoryView> topAccessoryViews;
  final Template template;
  final OnItemSelectedForm onItemSelectedForm;
  final bool showHeader;
  final String headerText;
  final bool collapsed;
  final bool collapsible;
  final String placeholderText;
  final String sort;

  FormRecordList(
      {required super.id,
      required this.bindTo,
      required this.noResultsText,
      required this.showDivider,
      required this.topAccessoryViews,
      required this.template,
      required this.onItemSelectedForm,
      required this.showHeader,
      required this.headerText,
      required this.collapsed,
      required this.collapsible,
      required this.placeholderText,
      required this.sort});

  @override
  Map<String, dynamic> toDict() {
    return {
      "bindTo": bindTo,
      "noResultsText": noResultsText,
      "showDivider": showDivider,
      "showHeader": showHeader,
      "headerText": headerText,
      "collapsed": collapsed,
      "collapsible": collapsible,
      "placeholderText": placeholderText,
      "sort": sort,
      "topAccessoryViews":
          topAccessoryViews.map((view) => view.toDict()).toList(),
      "template": template.toDict(),
      "onItemSelected": onItemSelectedForm.toDict(),
    };
  }
}
