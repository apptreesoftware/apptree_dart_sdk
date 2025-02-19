import "package:yaml_writer/yaml_writer.dart";

abstract class Feature {
  final String id;

  Feature({required this.id});

  Map<String, dynamic> toDict();

  String toYaml() {
    return YAMLWriter(allowUnquotedStrings: true).write({"features": toDict()});
  }
}
