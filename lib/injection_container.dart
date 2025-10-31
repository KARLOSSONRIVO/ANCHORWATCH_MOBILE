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
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.init();
}
final sl = getIt; // Keep existing sl reference
class DI {
  static T get<T extends Object>() => sl<T>();
  static T call<T extends Object>() => sl.call<T>();
  static bool isRegistered<T extends Object>() => sl.isRegistered<T>();
  static Future<void> reset() => sl.reset();
}
