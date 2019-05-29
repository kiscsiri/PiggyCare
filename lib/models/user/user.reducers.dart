import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.model.dart';

AppState initUser(AppState state, InitUserData action) {
  var newUserData =  new UserData(
      feedPerPeriod: action.user.feedPerPeriod,
      id: action.user.id,
      lastFeed: action.user.lastFeed,
      money: action.user.money,
      period: action.user.period,
      phoneNumber: action.user.phoneNumber,
      saving: action.user.saving,
      created: action.user.created);
  return new AppState(user: newUserData, registrationData: state.registrationData);
}

AppState updateUser(AppState state, UpdateUserData action) {
  var newUserData = new UserData(
      feedPerPeriod: action.user.feedPerPeriod,
      id: state.user.id,
      lastFeed: state.user.lastFeed,
      money: state.user.money,
      period: action.user.period,
      phoneNumber: state.user.phoneNumber,
      saving: state.user.saving,
      created: state.user.created);
  return new AppState(user: newUserData, registrationData: state.registrationData);
}

updateUserDatabase(AppState state, UpdateUserData action) {
  Firestore.instance
      .collection("users")
      .where("uid", isEqualTo: state.user.id)
      .getDocuments()
      .then((QuerySnapshot value) {
    var doc = value.documents.first;
    var newPeriod = action.user.period;
    var newFeedPerPeriod = action.user.feedPerPeriod;
    Firestore.instance.collection('users').document(doc.documentID).updateData(
        {'period': newPeriod.index, 'feedPerPeriod': newFeedPerPeriod.toInt()});
  });
}

feedPiggyDatabase(FeedPiggy action) {
  Firestore.instance
      .collection("users")
      .where("uid", isEqualTo: action.id)
      .getDocuments()
      .then((QuerySnapshot value) {
    var doc = value.documents.first;
    var newMoney = doc.data['money'] - doc.data['feedPerPeriod'];
    var newSaving = doc.data['saving'] + doc.data['feedPerPeriod'];
    var feedDate = DateTime.now();
    Firestore.instance.collection('users').document(doc.documentID).updateData(
        {'money': newMoney, 'saving': newSaving, 'lastFeed': feedDate});
  });
}

 feedPiggy(AppState state, FeedPiggy action) {
  var newUserData = new UserData(
      id: state.user.id,
      feedPerPeriod: state.user.feedPerPeriod,
      lastFeed: DateTime.now(),
      money: (state.user.money - state.user.feedPerPeriod),
      period: state.user.period,
      created: state.user.created,
      phoneNumber: state.user.phoneNumber,
      saving: (state.user.saving + state.user.feedPerPeriod));

  return new AppState(user: newUserData, registrationData: state.registrationData);
}

