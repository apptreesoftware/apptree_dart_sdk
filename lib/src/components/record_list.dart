import 'package:apptree_dart_sdk/models.dart';
import 'package:apptree_dart_sdk/components.dart';

class RecordList<INPUT extends Request, RECORD extends Record> extends Feature {
  final CollectionEndpoint<INPUT, RECORD> dataSource;
  final String noResultsText;
  final bool showDivider;
  final List<TopAccessoryView> topAccessoryViews;
  final TemplateBuilder<RECORD> template;
  final OnItemSelectedBuilder<RECORD>? onItemSelected;
  final ToolbarBuilder? toolbar;
  final RequestBuilder<INPUT>? onLoadRequest;

  RecordList({
    required super.id,
    required this.dataSource,
    required this.noResultsText,
    required this.showDivider,
    required this.topAccessoryViews,
    required this.template,
    required this.onItemSelected,
    this.toolbar,
    this.onLoadRequest,
  });

  @override
  BuildResult build(BuildContext context) {
    var navigation =
        onItemSelected != null
            ? onItemSelected!(context, dataSource.record)
            : null;
    var toolbarResult = toolbar?.call(context);
    var builtToolbar = toolbarResult?.build(context);
    var request = onLoadRequest?.call(context);
    var navigateTo = navigation?.build(context);

    var featureData = {
      id: {
        "recordList": {
          if (request != null) "onLoad": [dataSource.buildRequest(request)],
          "dataSource": dataSource.id,
          "noResultsText": noResultsText,
          "showDivider": showDivider,
          "topAccessoryViews":
              topAccessoryViews.map((view) => view.toDict()).toList(),
          "template": template(context, dataSource.record).toDict(),
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
      childFeatures: [
        if (navigateTo != null) ...navigateTo.childFeatures,
        if (builtToolbar != null) ...builtToolbar.childFeatures,
      ],
    );
  }

  Template getTemplate(BuildContext context) {
    return template(context, dataSource.record);
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
