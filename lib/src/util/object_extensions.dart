import 'dart:mirrors';

Map<String, dynamic> asMap(dynamic instance) {
  var mirror = reflect(instance);
  var classMirror = mirror.type;

  return Map.fromEntries(
    classMirror.declarations.entries
        .where((entry) => entry.value is VariableMirror)
        .map((entry) {
          var key = MirrorSystem.getName(entry.key);
          var value = mirror.getField(entry.key).reflectee;
          return MapEntry(key, value);
        }),
  );
}
