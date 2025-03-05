import 'package:apptree_dart_sdk/apptree.dart';

class Toolbar {
  final List<ToolbarItem> items;

  Toolbar({required this.items});

  BuildResult build(BuildContext context) {
    var builtItems = items.map((item) => item.build(context)).toList();
    return BuildResult(
      featureData: {
        "items": builtItems.map((item) => item.featureData).toList(),
      },
      childFeatures: builtItems.expand((item) => item.childFeatures).toList(),
    );
  }
}

class ToolbarItem {
  final String? title;
  final Icon? icon;
  final Conditional? visibleWhen;
  final List<Action> actions;
  final bool showTitleInToolbar;

  ToolbarItem({
    required this.title,
    this.icon,
    required this.actions,
    this.visibleWhen,
    this.showTitleInToolbar = false,
  }) : assert(
         title != null || icon != null,
         'ToolbarItem: Either title or icon must be provided',
       ),
       assert(
         actions.isNotEmpty,
         'ToolbarItem: At least one action must be provided',
       );

  BuildResult build(BuildContext context) {
    var builtActions = actions.map((action) => action.build(context)).toList();
    return BuildResult(
      featureData: {
        "title": title,
        "icon": icon?.id,
        "actions": builtActions.map((action) => action.featureData).toList(),
        if (visibleWhen != null) "visibleWhen": visibleWhen?.toString(),
      },
      childFeatures:
          builtActions.expand((action) => action.childFeatures).toList(),
    );
  }
}
