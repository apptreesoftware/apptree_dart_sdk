import 'package:server/src/errors.dart';

/// A generic utility class for validating JSON fields when deserializing model objects
class JsonUtils {
  /// Validates a field from JSON and adds validation errors to the invalidProperties map
  static T? validateField<T>({
    required String fieldName,
    required dynamic value,
    required Map<String, String> invalidProperties,
    String? customErrorMessage,
  }) {
    if (value is! T) {
      invalidProperties[fieldName] = customErrorMessage ??
          'Expected ${T.toString()}, got ${value.runtimeType}';
      // Return a dummy value that will be ignored if there are validation errors
      return null;
    }
    return value;
  }

  /// Validates all fields and throws InvalidModelException if any fields are invalid
  static void validateAndThrowIfInvalid({
    required Type modelType,
    required Map<String, String> invalidProperties,
  }) {
    if (invalidProperties.isNotEmpty) {
      throw InvalidModelException(
        modelType: modelType,
        invalidProperties: invalidProperties,
      );
    }
  }
}
