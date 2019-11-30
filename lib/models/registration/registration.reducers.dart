import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/item/item.model.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/models/registration/registration.model.dart';
import 'package:piggybanx/models/user/user.model.dart';

AppState initRegistrationState(AppState state, InitRegistration action) {
  var newRegistration = new RegistrationData(
      item: "", phoneNumber: "", targetPrice: 0, schedule: null);

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

AppState setUserType(AppState state, SetUserType action) {
  state.registrationData.userType = action.userType;
  var newAppState = AppState.fromAppState(state);
  return newAppState;
}

AppState addItem(AppState state, AddItem action) {
  var newItems = state.user.items;

  newItems.add(Item(
      currentSaving: 0,
      item: action.item.item,
      targetPrice: action.item.targetPrice));

  var newUser = UserData(
      created: state.user.created,
      currentFeedTime: state.user.currentFeedTime,
      feedPerPeriod: state.user.feedPerPeriod,
      id: state.user.id,
      items: state.user.items,
      lastFeed: state.user.lastFeed,
      money: state.user.money,
      period: state.user.period,
      phoneNumber: state.user.phoneNumber,
      piggyLevel: state.user.piggyLevel,
      saving: state.user.saving);

  return new AppState(user: newUser, registrationData: new RegistrationData());
}

AppState setStorePhoneNumber(AppState state, SetPhoneNumber action) {
  var newRegistration = new RegistrationData(
      item: state.registrationData.item,
      schedule: state.registrationData.schedule,
      phoneNumber: action.phoneNumber,
      targetPrice: state.registrationData.targetPrice);

  return new AppState(user: state.user, registrationData: newRegistration);
}

addItemDatabase(AddItem item, String uid) {
  Firestore.instance
      .collection('users')
      .where("uid", isEqualTo: uid)
      .getDocuments()
      .then((doc) {
    var user = doc.documents.first;

    Firestore.instance
        .collection('items')
        .add(item.item.toJson(user.documentID));
  });
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
      userType: state.registrationData.userType,
      item: state.registrationData.item,
      schedule: state.registrationData.schedule,
      phoneNumber: state.registrationData.phoneNumber,
      targetPrice: action.price);
  return new AppState(user: state.user, registrationData: newRegistration);
}

AppState clearRegistrationStore(AppState state, ClearRegisterState action) {
  return new AppState(user: state.user, registrationData: null);
}
