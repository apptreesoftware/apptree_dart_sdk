import 'package:apptree_dart_sdk/components.dart';
import 'package:apptree_dart_sdk/models.dart';

class Analytics {
  final String tag;
  final Map<String, dynamic>? data;

  const Analytics({required this.tag, this.data});

  Map<String, dynamic> build(BuildContext context) {
    return {'tag': tag, if (data != null) 'data': data};
  }
}

abstract class Action {
  final Analytics? analytics;

  const Action({this.analytics});

  BuildResult build(BuildContext context);
}

abstract class FormAction extends Action {
  const FormAction({super.analytics});
}

abstract class RecordListAction extends Action {
  const RecordListAction({super.analytics});
}

class NavigateTo extends Action {
  final Feature feature;
  final Map<String, dynamic>? data;

  NavigateTo({required this.feature, this.data});

  @override
  BuildResult build(BuildContext context) {
    return BuildResult(
      featureData: {
        'id': feature.id,
        if (data != null) 'navigationContext': data,
      },
      childFeatures: [feature],
    );
  }
}

class ShowSortDialogAction extends RecordListAction {
  const ShowSortDialogAction({super.analytics});

  @override
  BuildResult build(BuildContext context) {
    return BuildResult(
      featureData: {
        'sort': {if (analytics != null) 'analytics': analytics?.build(context)},
      },
      childFeatures: [],
    );
  }
}

class ShowMapAction extends RecordListAction {
  const ShowMapAction({super.analytics});

  @override
  BuildResult build(BuildContext context) {
    return BuildResult(
      featureData: {
        'map': {if (analytics != null) 'analytics': analytics?.build(context)},
      },
      childFeatures: [],
    );
  }
}
