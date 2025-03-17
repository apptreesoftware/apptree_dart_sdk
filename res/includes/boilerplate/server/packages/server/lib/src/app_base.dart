import "package:dotenv/dotenv.dart";
import 'package:apptree_mobile/apptree_mobile.dart';


abstract class AppBase {
  final String projectName;
  final String username;

  AppBase({required this.projectName, required this.username});
  // Map to store dependencies with Type as key
  final Map<Type, dynamic> _dependencies = {};

  String getServiceSecret() {
    // Try to get the secret from the environment variable
    // If it's not set, throw an error
    final env = DotEnv(includePlatformEnvironment: true)..load();
    var secret = env['APPTREE_SERVICE_SECRET'];
    if (secret == null) {
      throw Exception("APPTREE_SERVICE_SECRET is not set");
    }
    return secret;
  }

  Service get service => Service(project: projectName, secret: getServiceSecret());

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
