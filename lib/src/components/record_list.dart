import 'package:apptree_dart_sdk/models.dart';
import 'package:apptree_dart_sdk/src/components/feature.dart';
import 'package:apptree_dart_sdk/src/components/view.dart';

class RecordList<I extends Request, R extends Record> extends Feature {
  final CollectionEndpoint<I, R> dataSource;
  final String noResultsText;
  final bool showDivider;
  final List<TopAccessoryView> topAccessoryViews;
  final TemplateBuilder<R> templateBuilder;
  final OnItemSelectedBuilder<R>? onItemSelected;

  RecordList({
    required super.id,
    required this.dataSource,
    required this.noResultsText,
    required this.showDivider,
    required this.topAccessoryViews,
    required this.templateBuilder,
    required this.onItemSelected,
  });

  @override
  BuildResult build(BuildContext context) {
    var navigation =
        onItemSelected != null
            ? onItemSelected!(context, dataSource.record)
            : null;
    var featureData = {
      id: {
        "recordList": {
          "onLoad": dataSource.onLoad().toDict(),
          "dataSource": dataSource.id,
          "noResultsText": noResultsText,
          "showDivider": showDivider,
          "topAccessoryViews":
              topAccessoryViews.map((view) => view.toDict()).toList(),
          "template": templateBuilder(context, dataSource.record).toDict(),
          "onItemSelected":
              navigation != null
                  ? [
                    {'navigateTo': navigation.toDict()},
                  ]
                  : null,
        },
      },
    };

    return BuildResult(
      featureData: featureData,
      childFeatures: [if (navigation != null) navigation.feature],
    );
  }
}

// class FormRecordList extends Feature {
//   final bool showHeader;
//   final String headerText;
//   final bool collapsed;
//   final bool collapsible;
//   final String placeholderText;
//   final String sort;
//   final String bindTo;
//   final Template template;
//   final OnItemSelectedForm onItemSelected;
//   FormRecordList({
//     required super.id,
//     required this.bindTo,
//     required this.template,
//     required this.showHeader,
//     required this.headerText,
//     required this.collapsed,
//     required this.collapsible,
//     required this.placeholderText,
//     required this.sort,
//     required this.onItemSelected,
//   });

//   @override
//   Map<String, dynamic> toDict() {
//     template.setIsFormTemplate(true);
//     return {
//       "showHeader": showHeader,
//       "headerText": headerText,
//       "collapsed": collapsed,
//       "collapsible": collapsible,
//       "placeholderText": placeholderText,
//       "sort": sort,
//       "bindTo": bindTo,
//       "template": template.toDict(),
//       "onItemSelected": onItemSelected.toDict(),
//     };
//   }
// }
