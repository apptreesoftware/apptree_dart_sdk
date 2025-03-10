import 'package:apptree_dart_sdk/apptree.dart';

class Toolbar {
  final List<ToolbarItem> items;

  Toolbar({required this.items});

  BuildResult build(BuildContext context) {
    var builder = BuildResultBuilder();
    var builtItems = builder.addResults(
      items.map((item) => item.build(context)).toList(),
    );

    return builder.build({
      "items": builtItems.map((item) => item.featureData).toList(),
    }, 'Toolbar');
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
    var builder = BuildResultBuilder();
    var builtActions = builder.addResults(
      actions.map((action) => action.build(context)).toList(),
    );
    return builder.build({
      if (title != null) "title": title,
      if (icon != null) "icon": icon?.id,
      if (visibleWhen != null) "visibleWhen": visibleWhen?.toString(),
      "actions": builtActions.map((action) => action.featureData).toList(),
    }, 'ToolbarItem: ${title ?? icon?.id}');
  }
}
