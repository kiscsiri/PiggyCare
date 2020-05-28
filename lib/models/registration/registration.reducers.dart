import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/Enums/level.dart';
import 'package:piggybanx/Enums/userType.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
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

AppState addItem(AppState state, AddPiggy action) {
  var newUser = state.user;

  if (action.piggy.userId == state.user.id) {
    var newItems = state.user.piggies;
    var isApproved = false;

    if (newUser.userType == UserType.child)
      isApproved = false;
    else
      isApproved = true;

    newItems.add(Piggy(
        currentSaving: 0,
        piggyLevel: PiggyLevel.Baby,
        doubleUp: false,
        id: action.piggy.id,
        currentFeedTime: 0,
        isFeedAvailable: true,
        money: 0,
        userId: state.user.id,
        item: action.piggy.item,
        isApproved: isApproved,
        targetPrice: action.piggy.targetPrice));

    newUser = UserData.fromUserData(state.user);
  } else {
    var child = state.user.children
        .singleWhere((element) => element.id == action.piggy.userId);

    child.piggies.add(Piggy(
        currentSaving: 0,
        piggyLevel: PiggyLevel.Baby,
        doubleUp: false,
        id: state.user.piggies.length + 1,
        isFeedAvailable: true,
        money: 0,
        userId: state.user.id,
        item: action.piggy.item,
        isApproved: true,
        targetPrice: action.piggy.targetPrice));

    newUser = UserData.fromUserData(state.user);
  }

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

addItemDatabase(AddPiggy item, String uid) {
  Firestore.instance
      .collection('users')
      .where("uid", isEqualTo: uid)
      .getDocuments()
      .then((doc) {
    item.piggy.userId = uid;
    Firestore.instance.collection('items').add(item.piggy.toJson());
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
