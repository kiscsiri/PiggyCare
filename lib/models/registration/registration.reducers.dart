import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/models/registration/registration.model.dart';
import 'package:piggybanx/models/store.dart';

AppState initRegistrationState(AppState state, InitRegistration action) {
  var newRegistration =
      new RegistrationData(item: "", phoneNumber: "", targetPrice: 0, schedule: null);

  return new AppState(user: state.user, registrationData: newRegistration);
}

AppState setStoreItem(AppState state, SetItem action) {
  var newRegistration = new RegistrationData(
      item: action.item,
      schedule: state.registrationData.schedule,
      phoneNumber: state.registrationData.phoneNumber,
      targetPrice: state.registrationData.targetPrice);

  return new AppState(user: state.user, registrationData: newRegistration);
}

AppState setStorePhoneNumber(AppState state, SetPhoneNumber action) {
  var newRegistration = new RegistrationData(
      item: state.registrationData.item,
      schedule: state.registrationData.schedule,
      phoneNumber: action.phoneNumber,
      targetPrice: state.registrationData.targetPrice);

  return new AppState(user: state.user, registrationData: newRegistration);
}

AppState setStoreSchedule(AppState state, SetSchedule action) {
  var newRegistration = new RegistrationData(
      item: state.registrationData.item,
      phoneNumber: state.registrationData.phoneNumber,
      schedule: action.schedule,
      targetPrice: state.registrationData.targetPrice);

  return new AppState(user: state.user, registrationData: newRegistration);
}

AppState setStoreTargetPrice(AppState state, SetPrice action) {
  var newRegistration = new RegistrationData(
      item: state.registrationData.item,
      schedule: state.registrationData.schedule,
      phoneNumber: state.registrationData.phoneNumber,
      targetPrice: action.price);
  return new AppState(user: state.user, registrationData: newRegistration);
}

AppState clearRegistrationStore(AppState state, ClearRegisterState action) {
  return new AppState(user: state.user, registrationData: null);
}
