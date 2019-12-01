import 'package:get_it/get_it.dart';
import 'package:piggybanx/models/chore/chore.export.dart';
import 'package:piggybanx/models/item/item.firebase.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/user/user.export.dart';

import 'firebase.implementations.dart/implementations.export.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ItemsApi('items'));
  locator.registerLazySingleton(() => UsersApi('users'));
  locator.registerLazySingleton(() => ChoreApi('chores'));
  locator.registerLazySingleton(() => PiggiesApi('piggies'));

  locator.registerLazySingleton(() => ChoreFirebaseServices());
  locator.registerLazySingleton(() => PiggyFirebaseServices());
  locator.registerLazySingleton(() => UserFirebaseServices());
  locator.registerLazySingleton(() => ItemFirebaseServices());
}
