import "package:apptree_dart_sdk/base.dart";
import "package:apptree_dart_sdk/src/components/feature.dart";
import "package:apptree_dart_sdk/src/components/menu.dart";
import "package:yaml_writer/yaml_writer.dart";
import "package:apptree_dart_sdk/src/util/file.dart";
class App {
  final String name;
  final String version;
  List<Builder> builders = [];
  List<Feature> features = [];
  List<MenuItem> menuItems = [];

  App({required this.name, required this.version});

  void addFeature(Builder builder, MenuItem? menuItem) {
    builders.add(builder);
    if (menuItem != null) {
      menuItem.setId(builder.id);
      menuItems.add(menuItem);
    }
  }

  Map<String, dynamic> toDict() {
    return {"name": name, "version": version, "merge": [], "layouts": []};
  }

  String toYaml() {
    return YAMLWriter().write(toDict());
  }

  void buildFeature(Builder builder) {
    Feature feature = builder.build();
    if (feature is RecordList) {
      buildFeature(feature.onItemSelected.builder);
    }
    // TODO: Handle FormRecordList
    features.add(feature);
  }

  void initialize() {
    for (var builder in builders) {
      buildFeature(builder);
    }

    // Initialize Menu Items
    Menu menu = Menu(menuItems: menuItems);
    writeYaml("menu", menu.toYaml());

    // Output Features
    for (var feature in features) {
      writeYaml(feature.id, feature.toYaml());
    }
  }
}
