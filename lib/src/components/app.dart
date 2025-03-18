import "package:apptree_dart_sdk/apptree.dart";
import "package:yaml_writer/yaml_writer.dart";
import "package:apptree_dart_sdk/src/util/file.dart";

class App {
  final String name;
  final int configVersion;
  List<Feature> features = [];
  List<Feature> childFeatures = [];
  Map<String, MenuItem> menuItems = {};
  List<Template> templates = [];
  List<Endpoint> endpoints = [];
  App({required this.name, required this.configVersion});

  void addFeature(Feature feature, {required MenuItem menuItem}) {
    features.add(feature);
    menuItem.setId(feature.id);
    menuItems[menuItem.title] = menuItem;
  }

  void addChildFeature(Feature feature) {
    childFeatures.add(feature);
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
    featureIds.addAll(childFeatures.map((feature) => '${feature.id}.yaml'));
    featureIds.add("menu.yaml");
    return {
      "name": name,
      "configVersion": configVersion,
      "merge": featureIds,
      "templates": templates.map((t) => "templates/${t.id}.fsx").toList(),
      "environment": {
        "url": "https://corey.apptree.dev",
      },
    };
  }

  void toYaml() {
    Map<String, dynamic> app = toDict();

    writeYaml(
      name,
      "template_merge",
      YamlWriter().write(app),
      extension: '.apptreemobile',
    );
  }

  void initialize() {
    Map<String, dynamic> configDict = {};
    var buildContext = BuildContext(user: User());

    for (var template in templates) {
      writeTemplate(name, template.id, template.toFsx());
    }

    writeConfigYaml(name, YamlWriter().write(configDict));

    // Initialize Menu Items
    Menu menu = Menu(menuItems: menuItems);
    writeYaml(name, "menu", menu.toYaml());

    for (var feature in features) {
      writeFeature(feature, buildContext: buildContext);
    }

    toYaml();
  }

  BuildResult writeFeature(
    Feature feature, {
    required BuildContext buildContext,
  }) {
    // Build the feature
    var buildResult = feature.build(buildContext);
    print("Writing feature: ${feature.id}");

    // Write Templates
    if (buildResult.templates.isNotEmpty) {
      for (var template in buildResult.templates) {
        writeTemplate(name, template.id, template.toFsx());
        addTemplate(template);
      }
    }

    // If there are errors, print them
    if (buildResult.errors.isNotEmpty) {
      print("Error in ${buildResult.buildIdentifier}");
      for (var error in buildResult.errors) {
        print(
          "\tInvalid configuration: ${error.identifier} - ${error.message}",
        );
        for (var childError in error.childErrors) {
          print("  - ${childError.identifier} - ${childError.message}");
        }
      }
    }

    // Write the feature to the file
    var yaml = YamlWriter(
      allowUnquotedStrings: true,
    ).write({"features": buildResult.featureData});
    writeYaml(name, feature.id, yaml);

    // Recursively build and write child features
    for (var childFeature in buildResult.childFeatures) {
      writeFeature(childFeature, buildContext: buildContext);
      addChildFeature(childFeature);
    }

    if (buildResult.endpoints.isNotEmpty) {
      endpoints.addAll(buildResult.endpoints);
    }

    return buildResult;
  }
}
