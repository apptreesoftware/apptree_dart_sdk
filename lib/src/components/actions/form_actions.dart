import 'package:apptree_dart_sdk/apptree.dart';

abstract class FormAction extends Action {
  const FormAction({super.analytics});
}

class SubmitFormAction<I extends Request, R extends Record> extends FormAction {
  final DisplayValueBuilder<R>? submissionTitle;
  final int? notificationDuration;
  final String? dependsOnSubmission;
  final SubmissionEndpoint<I, R> endpoint;
  final RequestBuilder<I>? request;

  SubmitFormAction({
    required this.submissionTitle,
    required this.endpoint,
    this.notificationDuration,
    this.dependsOnSubmission,
    this.request,
  });

  @override
  BuildResult build(BuildContext context) {
    var record = instantiateRecord<R>();
    var title = this.submissionTitle?.call(context, record);
    var submitRequest = this.request?.call(context);
    var request = endpoint.buildRequest(submitRequest);

    return BuildResult(
      buildIdentifier: 'SubmitFormAction',
      featureData: {
        "submitForm": {
          ...request,
          if (analytics != null) "analytics": analytics?.build(context),
          if (title != null) "title": title,
          if (notificationDuration != null)
            "notificationDuration": notificationDuration,
          if (dependsOnSubmission != null)
            "dependsOnSubmission": dependsOnSubmission,
        },
      },
      endpoints: [endpoint],
      childFeatures: [],
    );
  }
}

class ValueChangedAction extends FormAction {
  final SetValueAction? set;
  final ReloadFormFieldAction? reload;

  const ValueChangedAction({required this.set, required this.reload});

  @override
  BuildResult build(BuildContext context) {
    var setData = set?.build(context);
    var reloadData = reload?.build(context);
    var analytics = this.analytics?.build(context);
    return BuildResult(
      buildIdentifier: 'ValueChangedAction',
      featureData: {
        "onValueChanged": {
          if (setData != null) "set": setData,
          if (reloadData != null) "reload": reloadData,
          if (analytics != null) "analytics": analytics,
        },
      },
      childFeatures: [],
    );
  }
}

class SetValueAction extends FormAction {
  final String fieldId;
  final dynamic value;

  const SetValueAction({required this.fieldId, required this.value})
    : assert(value != null, 'value must not be null');

  @override
  BuildResult build(BuildContext context) {
    var analytics = this.analytics?.build(context);
    return BuildResult(
      buildIdentifier: 'SetValueAction',
      featureData: {
        "set": {
          "key": fieldId,
          "data": value,
          if (analytics != null) "analytics": analytics,
        },
      },
      childFeatures: [],
    );
  }
}

class ReloadFormFieldAction extends FormAction {
  final String fieldId;

  const ReloadFormFieldAction({required this.fieldId});

  @override
  BuildResult build(BuildContext context) {
    var analytics = this.analytics?.build(context);
    return BuildResult(
      buildIdentifier: 'ReloadFormFieldAction',
      featureData: {
        "reload": {
          "id": fieldId,
          if (analytics != null) "analytics": analytics,
        },
      },
      childFeatures: [],
    );
  }
}
