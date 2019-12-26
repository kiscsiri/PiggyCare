import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/item/item.model.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/models/registration/registration.model.dart';
import 'package:piggybanx/models/user/user.model.dart';

AppState initRegistrationState(AppState state, InitRegistration action) {
  var newRegistration = new RegistrationData(
      item: "",
      phoneNumber: "",
      targetPrice: 0,
      email: "",
      pictureUrl: "",
      uid: "",
      username: "",
      schedule: null,
      userType: UserType.individual);

  return new AppState(user: state.user, registrationData: newRegistration);
}

AppState setStoreItem(AppState state, SetItem action) {
  state.registrationData.item = action.item;
  return new AppState.fromAppState(state);
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
      userType: state.registrationData.userType,
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
  state.registrationData.phoneNumber = action.phoneNumber;

  return AppState.fromAppState(state);
}

AppState setOauthAccount(AppState state, SetFromOauth action) {
  state.registrationData.email = action.email;
  state.registrationData.username = action.username;
  state.registrationData.uid = action.uid;
  state.registrationData.pictureUrl = action.pictureUrl;

  return AppState.fromAppState(state);
}

addItemDatabase(AddItem item, String uid) {
  Firestore.instance
      .collection('users')
      .where("uid", isEqualTo: uid)
      .getDocuments()
      .then((doc) {
    item.item.userId = uid;
    Firestore.instance.collection('items').add(item.item.toJson());
  });
}

AppState setStoreSchedule(AppState state, SetSchedule action) {
  state.registrationData.schedule = action.schedule;

  return new AppState.fromAppState(state);
}

AppState setStoreTargetPrice(AppState state, SetPrice action) {
  state.registrationData.targetPrice = action.price;
  return new AppState.fromAppState(state);
}

AppState clearRegistrationStore(AppState state, ClearRegisterState action) {
  return new AppState(user: state.user, registrationData: RegistrationData());
}
