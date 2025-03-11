import 'package:server/server.dart';

class MyCardsRequest {
  final string owner;
  final string filter;

  MyCardsRequest({required this.owner, required this.filter});

  factory MyCardsRequest.fromJson(Map<String, dynamic> json) {
    final invalidProperties = <String, String>{};
    final owner = JsonUtils.validateField<string>(fieldName: 'owner', value: json['owner'], invalidProperties: invalidProperties);
    final filter = JsonUtils.validateField<string>(fieldName: 'filter', value: json['filter'], invalidProperties: invalidProperties);
    JsonUtils.validateAndThrowIfInvalid(modelType: MyCardsRequest, invalidProperties: invalidProperties);
    return MyCardsRequest(owner: owner!, filter: filter!);
  }

  Map<String, dynamic> toJson() {
    return {'owner': owner, 'filter': filter};
  }
}
