import 'package:piggybanx/models/registration/registration.model.dart';
import 'package:piggybanx/models/user/user.model.dart';

class AppState {
  UserData user;
  RegistrationData registrationData;

  AppState({this.user, this.registrationData});

  AppState.fromAppState(AppState another)
      : user = another.user,
        registrationData = another.registrationData;
}
