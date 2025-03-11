import 'package:server/server.dart';

class CardSubmissionRequest {
  final string appVersion;

  CardSubmissionRequest({required this.appVersion});

  factory CardSubmissionRequest.fromJson(Map<String, dynamic> json) {
    final invalidProperties = <String, String>{};
    final appVersion = JsonUtils.validateField<string>(fieldName: 'appVersion', value: json['appVersion'], invalidProperties: invalidProperties);
    JsonUtils.validateAndThrowIfInvalid(modelType: CardSubmissionRequest, invalidProperties: invalidProperties);
    return CardSubmissionRequest(appVersion: appVersion!);
  }

  Map<String, dynamic> toJson() {
    return {'appVersion': appVersion};
  }
}
