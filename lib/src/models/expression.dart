import 'package:apptree_dart_sdk/src/models/record.dart';

abstract class Operator {
  String get value;

  String get sqlValue;
}

class EQUALS extends Operator {
  @override
  final String value = '==';

  @override
  String get sqlValue => '=';
}

class NEQUALS extends Operator {
  @override
  final String value = '!=';

  @override
  String get sqlValue => '!=';
}

class CONTAINS extends Operator {
  @override
  final String value = 'contains';

  @override
  String get sqlValue => 'LIKE';
}

class AND extends Operator {
  @override
  final String value = '&&';

  @override
  String get sqlValue => 'AND';
}

class OR extends Operator {
  @override
  final String value = '||';

  @override
  String get sqlValue => 'OR';
}

enum ConditionalType { apptree, sqlite }

abstract class Conditional {
  Operator operator;
  List<Conditional> conditions = [];
  List<dynamic> sqlValues = [];
  ConditionalType type = ConditionalType.apptree;

  Conditional({required this.operator, required this.conditions});

  Conditional and(Conditional condition) {
    return Expression(operator: AND(), condition1: this, condition2: condition);
  }

  Conditional or(Conditional condition) {
    return Expression(operator: OR(), condition1: this, condition2: condition);
  }

  Conditional setType(ConditionalType type);

  List<dynamic> getValues();
}

class Or extends Conditional {
  Or(Conditional first, Conditional second, [List<Conditional>? additional])
    : super(operator: OR(), conditions: [first, second, ...?additional]);

  @override
  String toString() {
    if (type == ConditionalType.sqlite) {
      return '(${conditions.map((e) => e.toString()).join(' ${operator.sqlValue} ')})';
    }
    return '(${conditions.map((e) => e.toString()).join(' ${operator.value} ')})';
  }

  @override
  Conditional setType(ConditionalType type) {
    this.type = type;
    for (var condition in conditions) {
      condition.setType(type);
    }
    return this;
  }

  @override
  List<dynamic> getValues() {
    return conditions
        .map((e) => e.getValues())
        .toList()
        .expand((x) => x)
        .toList();
  }
}

class And extends Conditional {
  And(Conditional first, Conditional second, [List<Conditional>? additional])
    : super(operator: AND(), conditions: [first, second, ...?additional]);

  @override
  String toString() {
    if (type == ConditionalType.sqlite) {
      return '(${conditions.map((e) => e.toString()).join(' ${operator.sqlValue} ')})';
    }
    return '(${conditions.map((e) => e.toString()).join(' ${operator.value} ')})';
  }

  @override
  Conditional setType(ConditionalType type) {
    this.type = type;
    for (var condition in conditions) {
      condition.setType(type);
    }
    return this;
  }

  @override
  List<dynamic> getValues() {
    return conditions.map((e) => e.getValues()).toList();
  }
}

class Expression extends Conditional {
  final Conditional condition1;
  final Conditional condition2;

  Expression({
    required this.condition1,
    required this.condition2,
    required super.operator,
  }) : super(conditions: []);

  @override
  String toString() {
    if (type == ConditionalType.sqlite) {
      return '${condition1.toString()} ${operator.sqlValue} ${condition2.toString()}';
    }
    return '${condition1.toString()} ${operator.value} ${condition2.toString()}';
  }

  @override
  Conditional setType(ConditionalType type) {
    this.type = type;
    condition1.setType(type);
    condition2.setType(type);
    return this;
  }

  @override
  List<dynamic> getValues() {
    return condition1.getValues() + condition2.getValues();
  }
}

class Contains extends Conditional {
  final Field field1;
  final String value;

  Contains(this.field1, this.value)
    : super(operator: CONTAINS(), conditions: []);

  @override
  String toString() {
    if (type == ConditionalType.sqlite) {
      return '${field1.getSqlPath()} LIKE ?';
    }
    return '${field1.getFormPath()}.${operator.value}("$value")';
  }

  @override
  Conditional setType(ConditionalType type) {
    this.type = type;
    return this;
  }

  @override
  List<dynamic> getValues() {
    return [value];
  }
}

class StringEquals extends Conditional {
  final Field field1;
  final String value;

  StringEquals(this.field1, this.value)
    : super(operator: EQUALS(), conditions: []);

  @override
  String toString() {
    if (type == ConditionalType.sqlite) {
      return '${field1.getSqlPath()} ${operator.sqlValue} ?';
    }
    return '${field1.getFormPath()} ${operator.value} "$value"';
  }

  @override
  Conditional setType(ConditionalType type) {
    this.type = type;
    return this;
  }

  @override
  List<dynamic> getValues() {
    return [value];
  }
}

class IntEquals extends Conditional {
  final Field field1;
  final int value;

  IntEquals(this.field1, this.value)
    : super(operator: EQUALS(), conditions: []);

  @override
  String toString() {
    if (type == ConditionalType.sqlite) {
      return '${field1.getSqlPath()} ${operator.sqlValue} ?';
    }
    return '${field1.getFormPath()} ${operator.value} $value';
  }

  @override
  Conditional setType(ConditionalType type) {
    this.type = type;
    return this;
  }

  @override
  List<dynamic> getValues() {
    return [value];
  }
}

class BoolEquals extends Conditional {
  final Field field1;
  final bool value;

  BoolEquals(this.field1, this.value)
    : super(operator: EQUALS(), conditions: []);

  @override
  String toString() {
    if (type == ConditionalType.sqlite) {
      return '${field1.getSqlPath()} ${operator.sqlValue} ?';
    }
    return '${field1.getFormPath()} ${operator.value} $value';
  }

  @override
  Conditional setType(ConditionalType type) {
    this.type = type;
    return this;
  }

  @override
  List<dynamic> getValues() {
    return [value];
  }
}
