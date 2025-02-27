import 'package:apptree_dart_sdk/models.dart';
import 'package:apptree_dart_sdk/components.dart';

class RecordList<I extends Request, R extends Record> extends Feature {
  final CollectionEndpoint<I, R> dataSource;
  final String noResultsText;
  final bool showDivider;
  final List<TopAccessoryView> topAccessoryViews;
  final TemplateBuilder<R> templateBuilder;
  final OnItemSelectedBuilder<R>? onItemSelected;
  final ToolbarBuilder? toolbarBuilder;

  RecordList({
    required super.id,
    required this.dataSource,
    required this.noResultsText,
    required this.showDivider,
    required this.topAccessoryViews,
    required this.templateBuilder,
    required this.onItemSelected,
    this.toolbarBuilder,
  });

  @override
  BuildResult build(BuildContext context) {
    var navigation =
        onItemSelected != null
            ? onItemSelected!(context, dataSource.record)
            : null;

    var toolbar = toolbarBuilder?.call(context);
    var builtToolbar = toolbar?.build(context);

    var navigateTo = navigation?.build(context);

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
              navigateTo != null
                  ? [
                    {'navigateTo': navigateTo.featureData},
                  ]
                  : null,
          if (builtToolbar != null) "toolbar": builtToolbar.featureData,
        },
      },
    };

    return BuildResult(
      featureData: featureData,
      childFeatures: navigateTo?.childFeatures ?? [],
    );
  }

  Template getTemplate(BuildContext context) {
    return templateBuilder(context, dataSource.record);
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
