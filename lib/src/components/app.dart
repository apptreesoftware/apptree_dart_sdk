import "package:apptree_dart_sdk/apptree.dart";
import "package:yaml_writer/yaml_writer.dart";
import "package:apptree_dart_sdk/src/util/file.dart";

class App {
  final String name;
  final int configVersion;
  List<Feature> features = [];
  Map<String, MenuItem> menuItems = {};
  List<String> layouts = [];
  App({required this.name, required this.configVersion});

  void addFeature(Feature feature, {required MenuItem menuItem}) {
    features.add(feature);
    menuItem.setId(feature.id);
    menuItems[menuItem.title] = menuItem;
  }

  Map<String, dynamic> toDict() {
    List<String> featureIds =
        features.map((feature) => '${feature.id}.yaml').toList();
    featureIds.add("menu.yaml");
    return {
      "name": name,
      "configVersion": configVersion,
      "merge": featureIds,
      "templates": layouts,
    };
  }

  void toYaml() {
    Map<String, dynamic> app = toDict();

    writeYaml(
      name,
      "template_merge",
      YAMLWriter().write(app),
      extension: '.apptreemobile',
    );
  }

  void initialize() {
    Map<String, dynamic> configDict = {};
    var buildContext = BuildContext(user: User());

    for (var feature in features) {
      if (feature is RecordList) {
        configDict[feature.dataSource.id] = {"output": true, "skip": false};
        writeModelYaml(
          name,
          feature.dataSource.id,
          feature.dataSource.getModelYaml(),
        );
      }
    }

    writeConfigYaml(name, YAMLWriter().write(configDict));

    // Initialize Menu Items
    Menu menu = Menu(menuItems: menuItems);
    writeYaml(name, "menu", menu.toYaml());

    for (var feature in features) {
      writeFeature(feature, buildContext: buildContext);
    }

    layouts = copyTemplates(name);

    toYaml();
  }

  void writeFeature(Feature feature, {required BuildContext buildContext}) {
    var buildResult = feature.build(buildContext);
    var yaml = YAMLWriter(
      allowUnquotedStrings: true,
    ).write({"features": buildResult.featureData});
    writeYaml(name, feature.id, yaml);

    for (var childFeature in buildResult.childFeatures) {
      writeFeature(childFeature, buildContext: buildContext);
    }
  }
}
