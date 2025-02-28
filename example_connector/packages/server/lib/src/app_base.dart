abstract class AppBase {
  AppBase();
  // Map to store dependencies with Type as key
  final Map<Type, dynamic> _dependencies = {};

  /// Registers a dependency of type T
  /// If a dependency of the same type already exists, it will be overridden
  void register<T>(T instance) {
    _dependencies[T] = instance;
  }

  /// Retrieves a dependency of type T
  /// Throws an exception if the dependency is not found
  T get<T>() {
    final instance = _dependencies[T];
    if (instance == null) {
      throw Exception('Dependency of type $T not found');
    }
    return instance as T;
  }
}
