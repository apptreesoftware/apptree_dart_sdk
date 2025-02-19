import "package:apptree_dart_sdk/base.dart";
import "package:yaml_writer/yaml_writer.dart";
import "package:apptree_dart_sdk/src/util/file.dart";

class App {
  final String name;
  final int configVersion;
  List<Builder> builders = [];
  List<Feature> features = [];
  Map<String, MenuItem> menuItems = {};
  List<String> layouts = [];
  App({required this.name, required this.configVersion});

  void addFeature(Builder builder, MenuItem? menuItem) {
    builders.add(builder);
    if (menuItem != null) {
      menuItem.setId(builder.id);
      menuItems[menuItem.title] = menuItem;
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
    if (feature is FormRecordList) {
      buildFeature(feature.onItemSelected.builder);
    }
    if (feature is! FormRecordList) {
      features.add(feature);
    }
  }

  Map<String, dynamic> toDict() {
    List<String> featureIds =
        features.map((feature) => '${feature.id}.yaml').toList();
    featureIds.add("menu.yaml");
    return {
      "name": name,
      "configVersion": configVersion,
      "merge": featureIds,
      "templates": layouts
    };
  }

  void toYaml() {
    Map<String, dynamic> app = toDict();

    writeYaml(name, "template_merge", YAMLWriter().write(app),
        extension: '.apptreemobile');
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
      if (feature is FormRecordList) {
        continue;
      }
      writeYaml(name, feature.id, feature.toYaml());
    }

    layouts = copyTemplates(name);

    toYaml();
  }
}
