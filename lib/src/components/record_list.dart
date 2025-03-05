import 'package:apptree_dart_sdk/models.dart';
import 'package:apptree_dart_sdk/components.dart';

class RecordList<INPUT extends Request, RECORD extends Record, VARIABLE>
    extends Feature {
  final CollectionEndpoint<INPUT, RECORD> dataSource;
  final String noResultsText;
  final bool showDivider;
  final TopAccessoryViewBuilder? topAccessoryView;

  final TemplateBuilder<RECORD> template;
  final OnItemSelectedBuilder<RECORD>? onItemSelected;
  final ToolbarBuilder? toolbar;
  final RequestBuilder<INPUT>? onLoadRequest;
  final ListFilterBuilder<RECORD>? filters;
  final MapSettingsBuilder<RECORD>? mapSettings;

  RecordList({
    required super.id,
    required this.dataSource,
    required this.noResultsText,
    required this.showDivider,
    this.topAccessoryView,
    required this.template,
    required this.onItemSelected,
    this.toolbar,
    this.onLoadRequest,
    this.filters,
    this.mapSettings,
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
    var topAccessoryViewResult =
        topAccessoryView?.call(context) ?? <AccessoryView>[];
    var filtersResult = filters?.call(context, dataSource.record);
    var mapSettingsResult = mapSettings?.call(context, dataSource.record);
    var buildErrors = <BuildError>[];

    var topAccessoryViews = [];
    for (var view in topAccessoryViewResult) {
      var accessoryViewResult = view.build(context);
      topAccessoryViews.add(accessoryViewResult.featureData);
      buildErrors.addAll(accessoryViewResult.errors);
    }

    var navigateTo = navigation?.build(context);

    var templateData = template(context, dataSource.record).toDict();

    // Process map settings if available
    Map<String, dynamic>? mapSettingsData;
    if (mapSettingsResult != null) {
      mapSettingsData = mapSettingsResult.toDict();
    }

    var featureData = {
      id: {
        "recordList": {
          if (request != null) "onLoad": [dataSource.buildRequest(request)],
          "dataSource": dataSource.id,
          "noResultsText": noResultsText,
          "showDivider": showDivider,
          "topAccessoryViews": topAccessoryViews,
          "template": templateData,
          if (filtersResult != null) "filters": filtersResult,
          if (mapSettingsData != null) "mapSettings": mapSettingsData,
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
