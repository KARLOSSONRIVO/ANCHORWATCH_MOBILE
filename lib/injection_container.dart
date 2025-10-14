import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  // Register external dependencies manually
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // Initialize Injectable auto-generated dependencies
  getIt.init();
}

// Backward compatibility
final sl = getIt; // Keep existing sl reference

/// Helper methods for easy access
class DI {
  /// Get a dependency from the service locator
  static T get<T extends Object>() => sl<T>();

  /// Get a new instance of a factory-registered dependency
  static T call<T extends Object>() => sl.call<T>();

  /// Check if a dependency is registered
  static bool isRegistered<T extends Object>() => sl.isRegistered<T>();

  /// Reset all dependencies (useful for testing)
  static Future<void> reset() => sl.reset();
}