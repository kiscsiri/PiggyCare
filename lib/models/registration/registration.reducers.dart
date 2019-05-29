import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/models/registration/registration.model.dart';
import 'package:piggybanx/models/store.dart';

AppState initRegistrationState(AppState state, InitRegistration action) {
  var newRegistration = new RegistrationData(
    item: "",
    phoneNumber: "",
    targetPrice: 0
  );

  return new AppState(user: state.user, registrationData: newRegistration);
}

AppState setStoreItem(AppState state, SetItem action) {
  var newRegistration = new RegistrationData(
      item: action.item,
      phoneNumber: state.registrationData.phoneNumber,
      targetPrice: state.registrationData.targetPrice);

   return new AppState(user: state.user, registrationData: newRegistration);
}

AppState setStorePhoneNumber(
    AppState state, SetPhoneNumber action) {
  var newRegistration = new RegistrationData(
      item: state.registrationData.item,
      phoneNumber: action.phoneNumber,
      targetPrice: state.registrationData.targetPrice);

   return new AppState(user: state.user, registrationData: newRegistration);
}

AppState setStoreTargetPrice(AppState state, SetPrice action) {
  var newRegistration = new RegistrationData(
      item: state.registrationData.item,
      phoneNumber: state.registrationData.phoneNumber,
      targetPrice: action.price);
         return new AppState(user: state.user, registrationData: newRegistration);
}
