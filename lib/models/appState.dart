import 'package:piggybanx/models/registration/registration.model.dart';
import 'package:piggybanx/models/user/user.model.dart';

import 'piggy/piggy.export.dart';

class AppState {
  UserData user;
  RegistrationData registrationData;
  Piggy tempPiggy;

  AppState({this.user, this.registrationData, this.tempPiggy});

  AppState.fromAppState(AppState another)
      : user = another.user,
        registrationData = another.registrationData,
        tempPiggy = another.tempPiggy;
}
