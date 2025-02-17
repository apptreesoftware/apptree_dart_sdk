import "package:apptree_dart_sdk/base.dart";
import "package:yaml_writer/yaml_writer.dart";
import "package:apptree_dart_sdk/src/util/file.dart";

class App {
  final String name;
  final String version;
  List<Builder> builders = [];
  List<Feature> features = [];
  List<MenuItem> menuItems = [];
  List<String> layouts = [];
  App({required this.name, required this.version});

  void addFeature(Builder builder, MenuItem? menuItem) {
    builders.add(builder);
    if (menuItem != null) {
      menuItem.setId(builder.id);
      menuItems.add(menuItem);
    }
  }

  void buildFeature(Builder builder) {
    Feature feature = builder.build();
    if (feature is RecordList) {
      buildFeature(feature.onItemSelected.builder);
    }
    if (feature is Form) {
      for (var field in feature.fields.getRecordListFields()) {
        buildFeature(field.builder);
      }
    }
    features.add(feature);
  }

  Map<String, dynamic> toDict() {
    return {
      "name": name,
      "version": version,
      "merge": features.map((feature) => '${feature.id}.yaml').toList(),
      "layouts": layouts
    };
  }

  void toYaml() {
    Map<String, dynamic> app = toDict();

    writeYaml(name, "template_merge.apptreemobile", YAMLWriter().write(app));
  }

  void initialize() {
    for (var builder in builders) {
      buildFeature(builder);
    }

    // Initialize Menu Items
    Menu menu = Menu(menuItems: menuItems);
    writeYaml(name, "menu", menu.toYaml());

    // Output Features
    for (var feature in features) {
      writeYaml(name, feature.id, feature.toYaml());
    }

    layouts = copyTemplates(name);

    toYaml();
  }
}
