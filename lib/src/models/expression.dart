import 'package:apptree_dart_sdk/src/models/field.dart';

abstract class Operator {
  String get operator;
}

class Equals extends Operator {
  @override
  final String operator = '==';
}

class NotEquals extends Operator {
  @override
  final String operator = '!=';
}

class GreaterThan extends Operator {
  @override
  final String operator = '>';
}

class LessThan extends Operator {
  @override
  final String operator = '<';
}

class GreaterThanOrEqual extends Operator {
  @override
  final String operator = '>=';
}

class LessThanOrEqual extends Operator {
  @override
  final String operator = '<=';
}

class And extends Operator {
  @override
  final String operator = '&&';
}

class Or extends Operator {
  @override
  final String operator = '||';
}

class AdditionalConditional {
  final Operator operator;
  final Conditional condition;

  AdditionalConditional({required this.operator, required this.condition});
}

abstract class Conditional {
  Operator operator;
  List<AdditionalConditional> conditions = [];

  Conditional({required this.operator});

  void and(Conditional condition) {
    conditions.add(AdditionalConditional(operator: And(), condition: condition));
  }

  void or(Conditional condition) {
    conditions.add(AdditionalConditional(operator: Or(), condition: condition));
  }
}

class Expression extends Conditional {
  final Field field1;
  final Field field2;

  Expression({
    required this.field1,
    required this.field2,
    required super.operator,
  });

  @override
  String toString() {
    return '${field1.fullFieldPath} $operator ${field2.fullFieldPath}';
  }
}

class TrueExpression extends Conditional {
  final Field field1;

  TrueExpression({required this.field1, required super.operator});

  @override
  String toString() {
    return '${field1.fullFieldPath} $operator true';
  }
}

class FalseExpression extends Conditional {
  final Field field1;

  FalseExpression({required this.field1, required super.operator});

  @override
  String toString() {
    return '${field1.fullFieldPath} $operator false';
  }
}
