import 'dart:mirrors';
import 'package:apptree_dart_sdk/apptree.dart';

I instantiateRecord<I extends Record>() {
  // Verify this is an instance of Record
  if (!reflectClass(I).isSubclassOf(reflectClass(Record))) {
    throw ArgumentError('${I.toString()} is not a subclass of Record');
  }
  // Verify the record has a zero-argument constructor

  return (reflectClass(I).newInstance(Symbol(''), []).reflectee as I)
    ..register();
}

Map<String, dynamic> describeRequest<I extends Request>() {
  //Find each attribute of the request and put the field name with it's type in a Map. Any fields thare are lists or objects should be described recursively.
  // {
  //   "owner": "string",
  //   "filter": "string",
  //    "asset" : {
  //      "name": "string",
  //      "id": "int",
  //    },
  //   "cards": [
  //     {
  //       "owner": "string",
  //       "filter": "string",
  //       "value": "double"
  //     },
  //   ],
  // }
  final instanceMirror = reflectClass(I);
  final instanceName = MirrorSystem.getName(instanceMirror.simpleName);
  final Map<String, dynamic> dataDict = {};

  dynamic describeType(TypeMirror typeMirror, [Set<TypeMirror>? visited]) {
    visited ??= <TypeMirror>{};
    if (visited.contains(typeMirror)) {
      return MirrorSystem.getName(typeMirror.simpleName);
    }
    visited.add(typeMirror);

    // Handle primitive types
    if (typeMirror.reflectedType == int ||
        typeMirror.reflectedType == double ||
        typeMirror.reflectedType == String ||
        typeMirror.reflectedType == bool) {
      return MirrorSystem.getName(typeMirror.simpleName).toLowerCase();
    }

    // Handle List types: return a one-item list with the element type description
    if (typeMirror.isSubtypeOf(reflectType(List))) {
      if (typeMirror is ClassMirror && typeMirror.typeArguments.isNotEmpty) {
        return [describeType(typeMirror.typeArguments.first, visited)];
      }
      return ["list"];
    }

    // Handle Map types: return a map with key and value type descriptions
    if (typeMirror.isSubtypeOf(reflectType(Map))) {
      if (typeMirror is ClassMirror && typeMirror.typeArguments.length == 2) {
        return {
          'map': [
            describeType(typeMirror.typeArguments[0], visited),
            describeType(typeMirror.typeArguments[1], visited),
          ],
        };
      }
      return "map";
    }

    // For complex objects, recursively describe their fields
    if (typeMirror is ClassMirror) {
      final Map<String, dynamic> nestedDescription = {};
      typeMirror.declarations.forEach((Symbol s, DeclarationMirror decl) {
        if (decl is VariableMirror && !decl.isStatic) {
          final fieldName = MirrorSystem.getName(s);
          nestedDescription[fieldName] = describeType(decl.type, visited);
        }
      });
      return nestedDescription.isEmpty
          ? MirrorSystem.getName(typeMirror.simpleName).toLowerCase()
          : nestedDescription;
    }

    // Fallback: return the type's simple name as lowercase
    return MirrorSystem.getName(typeMirror.simpleName).toLowerCase();
  }

  instanceMirror.declarations.forEach((Symbol s, DeclarationMirror decl) {
    if (decl is VariableMirror && !decl.isStatic) {
      final fieldName = MirrorSystem.getName(s);
      dataDict[fieldName] = describeType(decl.type);
    }
  });

  return {instanceName: dataDict};
}

String getRequestName<I extends Request>() {
  return MirrorSystem.getName(reflectClass(I).simpleName);
}
