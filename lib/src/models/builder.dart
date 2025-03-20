import 'package:apptree_dart_sdk/apptree.dart';

typedef RecordTemplateBuilder<I extends Record> =
    Template Function(BuildContext context, I record);

typedef TemplateBuilder = Template Function(BuildContext context);

typedef OnItemSelectedBuilder<I extends Record> =
    NavigateTo Function(BuildContext context, I record);

typedef FormFieldsBuilder<I extends Record> =
    List<FormField> Function(BuildContext context, I record);

typedef TopAccessoryViewBuilder =
    List<AccessoryView> Function(BuildContext context);

typedef DisplayValueBuilder<I extends Record> =
    String Function(BuildContext context, I record);

typedef ToolbarBuilder = Toolbar Function(BuildContext context);
typedef RequestBuilder<I> = I Function(BuildContext context);

typedef ListFilterBuilder<I extends Record> =
    List<ListFilter> Function(BuildContext context, I record);

typedef MapSettingsBuilder<I extends Record> =
    MapSettings Function(BuildContext context, I record);

typedef FormToolbarBuilder<I extends Record> =
    Toolbar Function(BuildContext context, I record);

class BuildContext<APP extends Record> extends Record {
  final User user;
  final APP app;

  BuildContext({required this.user, required this.app});

  IntField get recordCount =>
      IntField()
        ..parent = this
        ..relativeFieldPath = 'recordCount()';

  DateTimeField get currentDateTime =>
      DateTimeField()
        ..parent = this
        ..relativeFieldPath = 'currentDateTime()';

  DateTimeField get currentDate =>
      DateTimeField()
        ..parent = this
        ..relativeFieldPath = 'currentDate()';

  LocationField get location =>
      LocationField()
        ..parent = this
        ..relativeFieldPath = 'location()';
}

class BuildResultBuilder {
  final List<BuildError> errors = [];
  final List<Template> templates = [];
  final List<Endpoint> endpoints = [];
  final List<Feature> childFeatures = [];

  void addEndpoint(Endpoint endpoint) {
    endpoints.add(endpoint);
  }

  BuildResult? addResult(BuildResult? result) {
    if (result == null) return null;
    if (result.errors.isNotEmpty) {
      errors.addAll(result.errors);
    }
    if (result.templates.isNotEmpty) {
      templates.addAll(result.templates);
    }
    if (result.endpoints.isNotEmpty) {
      endpoints.addAll(result.endpoints);
    }
    if (result.childFeatures.isNotEmpty) {
      childFeatures.addAll(result.childFeatures);
    }
    return result;
  }

  List<BuildResult> addResults(List<BuildResult> results) {
    for (var result in results) {
      addResult(result);
    }
    return results;
  }

  void addError(BuildError error) {
    errors.add(error);
  }

  BuildResult build(Map<String, dynamic> featureData, String identifier) {
    return BuildResult(
      buildIdentifier: identifier,
      errors: errors,
      templates: templates,
      endpoints: endpoints,
      childFeatures: childFeatures,
      featureData: featureData,
    );
  }
}

class BuildResult {
  final Map<String, dynamic> featureData;
  final List<Feature> childFeatures;
  final List<BuildError> errors;
  final List<Template> templates;
  final List<Endpoint> endpoints;
  final String buildIdentifier;
  BuildResult({
    required this.buildIdentifier,
    required this.featureData,
    required this.childFeatures,
    this.errors = const [],
    this.templates = const [],
    this.endpoints = const [],
  });

  BuildResult? addResult(BuildResult? result) {
    if (result == null) return null;
    if (result.errors.isNotEmpty) {
      errors.addAll(result.errors);
    }
    if (result.templates.isNotEmpty) {
      templates.addAll(result.templates);
    }
    if (result.endpoints.isNotEmpty) {
      endpoints.addAll(result.endpoints);
    }
    if (result.childFeatures.isNotEmpty) {
      childFeatures.addAll(result.childFeatures);
    }
    return this;
  }
}

abstract class Builder {
  final String id;

  Builder({required this.id});
}

abstract class RecordListBuilder<I extends Request, R extends Record>
    extends Builder {
  final CollectionEndpoint<I, R> endpoint;

  RecordListBuilder({required super.id, required this.endpoint});

  RecordList build(R record);
}

// abstract class FormRecordListBuilder<I extends Request, R extends Record>
//     extends Builder {
//   FormRecordListBuilder({required super.id, required this.endpoint});

//   FormRecordList build(R record);
// }

abstract class FormBuilder<I extends Request, R extends Record>
    extends Builder {
  final CollectionEndpoint<I, R> endpoint;
  FormBuilder({required super.id, required this.endpoint});

  Form build(R record);
}
