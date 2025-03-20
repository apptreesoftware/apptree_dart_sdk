class BaseRequest {
  final String app;
  final String username;

  BaseRequest({required this.app, required this.username});

  static BaseRequest fromJson(Map<String, dynamic> json) {
    return BaseRequest(app: json['app'], username: json['username']);
  }
}

class CollectionRequest extends BaseRequest {
  final String collection;

  CollectionRequest({
    required this.collection,
    required super.app,
    required super.username,
  });
}
