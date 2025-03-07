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
      childFeatures: [],
    );
  }
}
