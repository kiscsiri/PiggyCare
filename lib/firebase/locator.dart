import 'package:get_it/get_it.dart';

import 'firebase.api.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Api('items'));
  locator.registerLazySingleton(() => Api('users'));
  locator.registerLazySingleton(() => Api('chores'));
  locator.registerLazySingleton(() => Api('piggies'));
}
