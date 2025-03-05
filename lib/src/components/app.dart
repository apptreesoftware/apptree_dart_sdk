import "package:apptree_dart_sdk/apptree.dart";
import "package:yaml_writer/yaml_writer.dart";
import "package:apptree_dart_sdk/src/util/file.dart";

class App {
  final String name;
  final int configVersion;
  List<Feature> features = [];
  Map<String, MenuItem> menuItems = {};
  List<Template> templates = [];
  App({required this.name, required this.configVersion});

  void addFeature(Feature feature, {required MenuItem menuItem}) {
    features.add(feature);
    menuItem.setId(feature.id);
    menuItems[menuItem.title] = menuItem;
  }

  void addTemplate(Template template) {
    // If Template is already in templates, skip
    if (templates.any((t) => t.id == template.id)) {
      return;
    }
    templates.add(template);
  }

  Map<String, dynamic> toDict() {
    List<String> featureIds =
        features.map((feature) => '${feature.id}.yaml').toList();
    featureIds.add("menu.yaml");
    return {
      "name": name,
      "configVersion": configVersion,
      "merge": featureIds,
      "templates": templates.map((t) => "templates/${t.id}.fsx").toList(),
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
        templates.add(feature.getTemplate(buildContext));
      }
    }

    for (var template in templates) {
      writeTemplate(name, template.id, template.toFsx());
    }

    writeConfigYaml(name, YAMLWriter().write(configDict));

    // Initialize Menu Items
    Menu menu = Menu(menuItems: menuItems);
    writeYaml(name, "menu", menu.toYaml());

    for (var feature in features) {
      writeFeature(feature, buildContext: buildContext);
    }

    toYaml();
  }

  void writeFeature(Feature feature, {required BuildContext buildContext}) {
    var buildResult = feature.build(buildContext);
    print("Writing feature: ${feature.id}");

    if (buildResult.errors.isNotEmpty) {
      for (var error in buildResult.errors) {
        print("Invalid feature: ${error.identifier} - ${error.message}");
        for (var childError in error.childErrors) {
          print("  - ${childError.identifier} - ${childError.message}");
        }
      }
    }

    var yaml = YAMLWriter(
      allowUnquotedStrings: true,
    ).write({"features": buildResult.featureData});
    writeYaml(name, feature.id, yaml);

    for (var childFeature in buildResult.childFeatures) {
      writeFeature(childFeature, buildContext: buildContext);
    }
  }
}
