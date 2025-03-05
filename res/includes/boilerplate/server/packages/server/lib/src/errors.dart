class InvalidModelException implements Exception {
  final Type modelType;
  final Map<String, String> invalidProperties;

  InvalidModelException({
    required this.modelType,
    required this.invalidProperties,
  });

  @override
  String toString() {
    final propertiesString = invalidProperties.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(', ');

    return 'InvalidModelException: Failed to parse $modelType. Invalid properties: $propertiesString';
  }
}

class JsonInputException implements Exception {
  final String message;

  JsonInputException(this.message);

  @override
  String toString() {
    return 'The request body is not a valid JSON. Ensure that your request body is a valid JSON object and that the content type is application/json.';
  }
}
