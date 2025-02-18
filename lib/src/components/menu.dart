import 'package:yaml_writer/yaml_writer.dart';

class MenuItem {
  final String title;
  final String icon;
  final bool defaultItem;
  final int order;
  String id = "";

  MenuItem(
      {required this.title,
      required this.icon,
      required this.defaultItem,
      required this.order});

  void setId(String id) {
    this.id = id;
  }

  Map<String, dynamic> toDict() {
    return {
      "title": title,
      "icon": icon,
      "default": defaultItem,
      "order": order,
      "onSelected": [
        {
          "navigateTo": {"id": id}
        }
      ]
    };
  }
}

class Menu {
  final Map<String, MenuItem> menuItems;

  Menu({required this.menuItems});

  Map<String, dynamic> toDict() {
    return {
      "menu": {
        "items": menuItems.map((key, menuItem) => MapEntry(key, menuItem.toDict())),
      }
    };
  }

  String toYaml() {
    return YAMLWriter().write(toDict());
  }
}
