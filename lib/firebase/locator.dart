import 'package:get_it/get_it.dart';
import 'package:piggycare/services/chore.firebase.dart';

import 'firebase.implementations.dart/implementations.export.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ItemsApi('items'));
  locator.registerLazySingleton(() => UsersApi('users'));
  locator.registerLazySingleton(() => ChoreApi('chores'));
  locator.registerLazySingleton(() => PiggiesApi('piggies'));

  locator.registerLazySingleton(() => ChoreFirebaseServices());
}
