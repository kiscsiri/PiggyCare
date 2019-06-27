import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/Enums/level.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.model.dart';

AppState initUser(AppState state, InitUserData action) {
  var newUserData = new UserData(
      feedPerPeriod: action.user.feedPerPeriod,
      id: action.user.id,
      lastFeed: action.user.lastFeed,
      money: action.user.money,
      item: action.user.item,
      currentFeedTime: action.user.currentFeedTime,
      piggyLevel: action.user.piggyLevel,
      currentSaving: action.user.currentSaving,
      targetPrice: action.user.targetPrice,
      period: action.user.period,
      phoneNumber: action.user.phoneNumber,
      saving: action.user.saving,
      created: action.user.created);
  return new AppState(
      user: newUserData, registrationData: state.registrationData);
}

AppState updateUser(AppState state, UpdateUserData action) {
  var newUserData = new UserData(
      feedPerPeriod: action.user.feedPerPeriod,
      id: state.user.id,
      lastFeed: state.user.lastFeed,
      money: state.user.money,
      item: state.user.item,
      currentFeedTime: state.user.currentFeedTime,
      piggyLevel: state.user.piggyLevel,
      currentSaving: state.user.currentSaving,
      targetPrice: state.user.targetPrice,
      period: action.user.period,
      phoneNumber: state.user.phoneNumber,
      saving: state.user.saving,
      created: state.user.created);
  return new AppState(
      user: newUserData, registrationData: state.registrationData);
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
    var newCurrentSaving =
        doc.data['currentSaving'] + doc.data['feedPerPeriod'];
    var newCurrentFeedTime = ++doc.data['currentFeedTime'];
    var newPiggyLevel = 0;
    if (newCurrentFeedTime >= 5) {
      newPiggyLevel = ++doc.data['piggyLevel'];
      newCurrentFeedTime = 0;
    } else {
      newPiggyLevel = doc.data['piggyLevel'];
    }
    var feedDate = DateTime.now();
    Firestore.instance.collection('users').document(doc.documentID).updateData({
      'money': newMoney,
      'saving': newSaving,
      'lastFeed': feedDate,
      'piggyLevel': newPiggyLevel,
      'currentFeedTime': newCurrentFeedTime,
      'currentSaving': newCurrentSaving
    });
  });
}

feedPiggy(AppState state, FeedPiggy action) {
  var newCurrentFeedTime = state.user.currentFeedTime + 1;
  var newPiggyLevel = PiggyLevel.Baby;
  if (newCurrentFeedTime >= 5 && state.user.piggyLevel != PiggyLevel.Old) {
    newPiggyLevel = PiggyLevel.values[levelMap(state.user.piggyLevel) + 1];
    newCurrentFeedTime = 0;
  } else {
    newPiggyLevel = state.user.piggyLevel;
  }

  var newUserData = new UserData(
      id: state.user.id,
      feedPerPeriod: state.user.feedPerPeriod,
      lastFeed: DateTime.now(),
      money: (state.user.money - state.user.feedPerPeriod),
      item: state.user.item,
      targetPrice: state.user.targetPrice,
      piggyLevel: newPiggyLevel,
      currentSaving: (state.user.currentSaving + state.user.feedPerPeriod),
      currentFeedTime: newCurrentFeedTime,
      period: state.user.period,
      created: state.user.created,
      phoneNumber: state.user.phoneNumber,
      saving: (state.user.saving + state.user.feedPerPeriod));

  return new AppState(
      user: newUserData, registrationData: state.registrationData);
}
