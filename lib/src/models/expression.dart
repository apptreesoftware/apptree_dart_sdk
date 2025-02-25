import 'package:apptree_dart_sdk/src/models/record.dart';

abstract class Operator {
  String get value;
}

class Equals extends Operator {
  @override
  final String value = '==';
}

class NotEquals extends Operator {
  @override
  final String value = '!=';
}

class GreaterThan extends Operator {
  @override
  final String value = '>';
}

class LessThan extends Operator {
  @override
  final String value = '<';
}

class GreaterThanOrEqual extends Operator {
  @override
  final String value = '>=';
}

class LessThanOrEqual extends Operator {
  @override
  final String value = '<=';
}

class And extends Operator {
  @override
  final String value = '&&';
}

class Or extends Operator {
  @override
  final String value = '||';
}

class Contains extends Operator {
  @override
  final String value = 'contains';
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
    conditions
        .add(AdditionalConditional(operator: And(), condition: condition));
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
    return '${field1.getFormPath()} ${operator.value} ${field2.fullFieldPath}';
  }
}

class StringExpression extends Conditional {
  final Field field1;
  final String value;

  StringExpression({required this.field1, required super.operator, required this.value});

  @override
  String toString() {
    return '${field1.getFormPath()} ${operator.value} "$value"';
  }
}

class ContainsExpression extends Conditional {
  final Field field1;
  final String value;

  ContainsExpression({required this.field1, required super.operator, required this.value});

  @override
  String toString() {
    return '${field1.getFormPath()}.${operator.value}("$value")';
  }
}

class TrueExpression extends Conditional {
  final Field field1;

  TrueExpression({required this.field1, required super.operator});

  @override
  String toString() {
    return '${field1.getFormPath()} ${operator.value} true';
  }
}

class FalseExpression extends Conditional {
  final Field field1;

  FalseExpression({required this.field1, required super.operator});

  @override
  String toString() {
    return '${field1.getFormPath()} ${operator.value} false';
  }
}
