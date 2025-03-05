import 'package:apptree_dart_sdk/apptree.dart';

typedef TemplateBuilder<I extends Record> =
    Template Function(BuildContext context, I record);

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

class BuildContext {
  final User user;

  BuildContext({required this.user});
}

class BuildResult {
  final Map<String, dynamic> featureData;
  final List<Feature> childFeatures;
  final List<BuildError> errors;
  final List<Template> templates;

  BuildResult({
    required this.featureData,
    required this.childFeatures,
    this.errors = const [],
    this.templates = const [],
  });
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
