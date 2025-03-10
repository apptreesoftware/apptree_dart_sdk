import 'package:apptree_dart_sdk/models.dart';

/*
        filters:
          - when: context().woWorkbenchStatusFilter == 'todo'
            statement: json_extract(record,'$.Status.ClosingStatusFlag') = ? AND ActiveFlag = 'TRUE'
            values:
              - false
          - when: context().woWorkbenchStatusFilter == 'complete' 
            statement: json_extract(record,'$.Status.ClosingStatusFlag') = ? AND ActiveFlag = 'TRUE'
            values:
              - true
*/

class ListFilter {
  final Conditional? when;
  final Conditional statement;

  ListFilter({required this.when, required this.statement});

  BuildResult build(BuildContext context) {
    //Validate values are type of string/bool/int. If not, include each one in the BuildResult.errors
    List<dynamic> values = statement.getValues();
    List<BuildError> errors = [];
    var index = 0;
    for (var value in values) {
      if (value is! String && value is! bool && value is! int) {
        errors.add(
          BuildError(
            message: 'Values must be a string, bool, or int',
            identifier: 'Value [$index]',
          ),
        );
      }
    }

    return BuildResult(
      buildIdentifier: 'ListFilter',
      childFeatures: [],
      featureData: {
        if (when != null) 'when': when?.toString(),
        'statement': statement.setType(ConditionalType.sqlite).toString(),
        'values': statement.getValues(),
      },
      errors: errors,
      endpoints: [],
    );
  }
}
