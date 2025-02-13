abstract class Feature {
  final String id;

  Feature({required this.id});

  Map<String, dynamic> toDict();

  // String toYaml();
}
