import "package:apptree_dart_sdk/apptree.dart";
import "package:yaml_writer/yaml_writer.dart";

abstract class Feature {
  final String id;

  Feature({required this.id});

  BuildResult build(BuildContext context);

  String toYaml(BuildContext context) {
    return YamlWriter(
      allowUnquotedStrings: true,
    ).write({"features": build(context)});
  }
}
