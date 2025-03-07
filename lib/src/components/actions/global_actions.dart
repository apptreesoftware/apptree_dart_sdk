import 'package:apptree_dart_sdk/apptree.dart';

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
