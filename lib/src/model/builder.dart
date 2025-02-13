import 'package:apptree_dart_sdk/src/components/feature.dart';
import 'package:apptree_dart_sdk/src/model/record.dart';

abstract class Builder {
  final String id;
  final Record record;

  Builder({required this.id, required this.record});

  Feature build();
}
