import 'package:apptree_dart_sdk/apptree.dart';

abstract class RecordListAction extends Action {
  const RecordListAction({super.analytics});
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
