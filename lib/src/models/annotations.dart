import 'package:apptree_dart_sdk/src/models/endpoint.dart';

/// An annotation for fields that reference a list endpoint.
///
/// This annotation is used to associate a field with a ListEndpoint and
/// enforce type checking between the field and the endpoint's record type.
/// The field's type must match the second generic parameter of the ListEndpoint.
class ExternalField {
  /// The actual list endpoint class that this field references.
  /// This is used both to get the endpoint ID and to determine the expected field type.
  final ListEndpoint endpoint;
  final String key;

  /// Creates a new [ListField] annotation.
  ///
  /// The [endpoint] is required and specifies the ListEndpoint this field is associated with.
  /// The endpoint's record type (the second generic parameter) will be used to verify
  /// that the annotated field's type matches the expected type.
  const ExternalField({required this.endpoint, required this.key});

  /// Returns the endpoint ID for this list field.
  String get endpointId => endpoint.id;
}

class PkField {
  const PkField();
}
