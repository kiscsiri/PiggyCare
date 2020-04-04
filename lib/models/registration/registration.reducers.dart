import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggycare/enums/level.dart';
import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/models/piggy/piggy.export.dart';
import 'package:piggycare/models/registration/registration.actions.dart';
import 'package:piggycare/models/registration/registration.model.dart';
import 'package:piggycare/models/user/user.model.dart';

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
      userType: UserType.donator);

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

    if (newUser.userType == UserType.business)
      isApproved = true;
    else
      isApproved = false;

    newItems.add(Piggy(
        currentSaving: 0,
        piggyLevel: PiggyLevel.Baby,
        doubleUp: false,
        id: state.user.piggies.length + 1,
        isFeedAvailable: true,
        money: 0,
        userId: state.user.id,
        item: action.piggy.item,
        isApproved: isApproved,
        targetPrice: action.piggy.targetPrice));

    newUser = UserData(
        created: state.user.created,
        currentFeedTime: state.user.currentFeedTime,
        feedPerPeriod: state.user.feedPerPeriod,
        userType: state.user.userType,
        id: state.user.id,
        piggies: state.user.piggies,
        lastFeed: state.user.lastFeed,
        money: state.user.money,
        documentId: state.user.documentId,
        email: state.user.email,
        name: state.user.name,
        pictureUrl: state.user.pictureUrl,
        period: state.user.period,
        piggyLevel: state.user.piggyLevel,
        saving: state.user.saving);
  } else {
    newUser = UserData(
        created: state.user.created,
        currentFeedTime: state.user.currentFeedTime,
        feedPerPeriod: state.user.feedPerPeriod,
        userType: state.user.userType,
        id: state.user.id,
        piggies: state.user.piggies,
        lastFeed: state.user.lastFeed,
        money: state.user.money,
        documentId: state.user.documentId,
        email: state.user.email,
        name: state.user.name,
        pictureUrl: state.user.pictureUrl,
        period: state.user.period,
        piggyLevel: state.user.piggyLevel,
        saving: state.user.saving);
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
      .collection('donators')
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
