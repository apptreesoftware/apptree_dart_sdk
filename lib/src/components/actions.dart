import 'package:apptree_dart_sdk/components.dart';

class NavigateTo {
  final Feature feature;
  final Map<String, dynamic>? data;

  NavigateTo({required this.feature, this.data});

  Map<String, dynamic> toDict() {
    return {'id': feature.id, if (data != null) 'navigationContext': data};
  }
}

class NavigationContext {}
