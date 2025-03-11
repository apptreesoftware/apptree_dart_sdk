import 'package:server/server.dart';

class appVersion {
  final appVersion name;

  appVersion({required this.name});

  factory appVersion.fromJson(Map<String, dynamic> json) {
    final invalidProperties = <String, String>{};
    final name = JsonUtils.validateField<appVersion>(fieldName: 'name', value: json['name'], invalidProperties: invalidProperties);
    JsonUtils.validateAndThrowIfInvalid(modelType: appVersion, invalidProperties: invalidProperties);
    return appVersion(name: name!);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
