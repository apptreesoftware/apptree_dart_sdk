class BuildError {
  final String message;
  final String identifier;

  final List<BuildError> childErrors;

  BuildError({
    required this.identifier,
    required this.message,
    this.childErrors = const [],
  });
}
