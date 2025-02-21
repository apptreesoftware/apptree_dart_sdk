import 'package:apptree_dart_sdk/src/components/feature.dart';
import 'package:apptree_dart_sdk/src/components/callback.dart';
import 'package:apptree_dart_sdk/src/components/view.dart';
import 'package:apptree_dart_sdk/src/components/template.dart';
import 'package:apptree_dart_sdk/src/models/endpoint.dart';
class RecordList extends Feature {
  final CollectionEndpoint collectionEndpoint;
  final String noResultsText;
  final bool showDivider;
  final List<TopAccessoryView> topAccessoryViews;
  final Template template;
  final OnItemSelected onItemSelected;

  RecordList(
      {required super.id,
      required this.collectionEndpoint,
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
          "onLoad": collectionEndpoint.onLoad().toDict(),
          "dataSource": collectionEndpoint.dataSource.dataSource,
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
  final bool showHeader;
  final String headerText;
  final bool collapsed;
  final bool collapsible;
  final String placeholderText;
  final String sort;
  final String bindTo;
  final Template template;
  final OnItemSelectedForm onItemSelected;
  FormRecordList(
      {
      required super.id,
      required this.bindTo,
      required this.template,
      required this.showHeader,
      required this.headerText,
      required this.collapsed,
      required this.collapsible,
      required this.placeholderText,
      required this.sort,
      required this.onItemSelected});

  @override
  Map<String, dynamic> toDict() {
    template.setIsFormTemplate(true);
    return {
      "showHeader": showHeader,
      "headerText": headerText,
      "collapsed": collapsed,
      "collapsible": collapsible,
      "placeholderText": placeholderText,
      "sort": sort,
      "bindTo": bindTo,
      "template": template.toDict(),
      "onItemSelected": onItemSelected.toDict(),
    };
  }
}
