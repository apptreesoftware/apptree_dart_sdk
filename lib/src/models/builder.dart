import 'package:apptree_dart_sdk/src/models/record.dart';
import 'package:apptree_dart_sdk/src/models/request.dart';
import 'package:apptree_dart_sdk/src/components/record_list.dart';
import 'package:apptree_dart_sdk/src/components/form.dart';
import 'package:apptree_dart_sdk/src/components/feature.dart';
abstract class Builder {
  final String id;
  final Record record;

  Builder({required this.id, required this.record}) {
    record.register();
  }

  Feature build();
}

abstract class RecordListBuilder extends Builder {
  final Request request;

  RecordListBuilder({required super.id, required super.record, required this.request});

  @override
  RecordList build();
}

abstract class FormRecordListBuilder extends Builder {

  FormRecordListBuilder({required super.id, required super.record});

  @override
  FormRecordList build();
}

abstract class FormBuilder extends Builder {

  FormBuilder({required super.id, required super.record});

  @override
  Form build();
}

