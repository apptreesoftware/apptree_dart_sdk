import 'package:apptree_dart_sdk/models.dart';
import 'package:apptree_dart_sdk/components.dart';

class RecordList<INPUT extends Request, RECORD extends Record> extends Feature {
  final CollectionEndpoint<INPUT, RECORD> dataSource;
  final String noResultsText;
  final bool showDivider;
  final TopAccessoryViewBuilder? topAccessoryView;

  final RecordTemplateBuilder<RECORD> template;
  final OnItemSelectedBuilder<RECORD>? onItemSelected;
  final ToolbarBuilder? toolbar;
  final RequestBuilder<INPUT>? onLoadRequest;
  final ListFilterBuilder<RECORD>? filter;
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
    this.filter,
    this.mapSettings,
  });

  @override
  BuildResult build(BuildContext context) {
    var builder = BuildResultBuilder();

    var navigation =
        onItemSelected != null
            ? onItemSelected!(context, dataSource.record)
            : null;
    var toolbarResult = toolbar?.call(context);
    var builtToolbar = builder.addResult(toolbarResult?.build(context));
    var request = onLoadRequest?.call(context);

    // Process filters if available
    var filters = [];
    var filterResult = filter?.call(context, dataSource.record);
    if (filterResult != null) {
      for (var filter in filterResult) {
        var filterResult = filter.build(context);
        filters.add(filterResult.featureData);
        builder.addResult(filterResult);
      }
    }

    // Process map settings if available
    var mapSettingsResult = mapSettings?.call(context, dataSource.record);

    // Process top accessory views if available
    var topAccessoryViewResult =
        topAccessoryView?.call(context) ?? <AccessoryView>[];
    var topAccessoryViews = [];
    for (var view in topAccessoryViewResult) {
      var accessoryViewResult = view.build(context);
      topAccessoryViews.add(accessoryViewResult.featureData);
      builder.addResult(accessoryViewResult);
    }

    // Process navigation if available
    var navigateTo = builder.addResult(navigation?.build(context));

    // Process Template Data
    var templateData = template(context, dataSource.record).toDict();

    // Process map settings if available
    Map<String, dynamic>? mapSettingsData;
    if (mapSettingsResult != null) {
      mapSettingsData = mapSettingsResult.toDict();
    }
    builder.addEndpoint(dataSource);

    var featureData = {
      id: {
        "recordList": {
          if (request != null) "onLoad": [dataSource.buildRequest(request)],
          "dataSource": dataSource.id,
          "noResultsText": noResultsText,
          "showDivider": showDivider,
          "topAccessoryViews": topAccessoryViews,
          "template": templateData,
          if (filterResult != null) "filters": filters,
          if (mapSettingsData != null) "mapSettings": mapSettingsData,
          "onItemSelected":
              navigateTo != null
                  ? {'navigateTo': navigateTo.featureData}
                  : null,
          if (builtToolbar != null) "toolbar": builtToolbar.featureData,
        },
      },
    };

    return builder.build(featureData, 'RecordList: $id');
  }

  Template getTemplate(BuildContext context) {
    return template(context, dataSource.record);
  }
}
