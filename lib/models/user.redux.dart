import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggybanx/Enums/period.dart';

class SaveSettingsAction {
  final double savingPerPeriod;
  final Period period;

  SaveSettingsAction({this.savingPerPeriod, this.period});
}

class FeedPiggy {
  final String id;

  FeedPiggy(this.id);
}

class UpdateUserData {
  final UserData user;

  UpdateUserData(this.user);
}

class InitUserData {
  final UserData user;

  InitUserData(this.user);
}

UserData piggyReducer(UserData userState, dynamic action) {
  if (action is SaveSettingsAction) {
    return userState;
  } else if (action is FeedPiggy) {
    feedPiggyDatabase(action);
    return feedPiggy(userState, action);
  } else if (action is UpdateUserData) {
    updateUserDatabase(userState, action);
    return updateUser(userState, action);
  } else if (action is InitUserData) {
    return initUser(userState, action);
  } else {
    return null;
  }
}

UserData initUser(UserData state, InitUserData action) {
  return new UserData(
      feedPerPeriod: action.user.feedPerPeriod,
      id: action.user.id,
      lastFeed: action.user.lastFeed,
      money: action.user.money,
      period: action.user.period,
      phoneNumber: action.user.phoneNumber,
      saving: action.user.saving,
      created: action.user.created);
}

UserData updateUser(UserData state, UpdateUserData action) {
  return new UserData(
      feedPerPeriod: action.user.feedPerPeriod,
      id: state.id,
      lastFeed: state.lastFeed,
      money: state.money,
      period: action.user.period,
      phoneNumber: state.phoneNumber,
      saving: state.saving,
      created: state.created);
}

updateUserDatabase(UserData state, UpdateUserData action) {
  Firestore.instance
      .collection("users")
      .where("uid", isEqualTo: state.id)
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

UserData feedPiggy(UserData state, FeedPiggy action) {
  return new UserData(
      id: state.id,
      feedPerPeriod: state.feedPerPeriod,
      lastFeed: DateTime.now(),
      money: (state.money - state.feedPerPeriod),
      period: state.period,
      created: state.created,
      phoneNumber: state.phoneNumber,
      saving: (state.saving + state.feedPerPeriod));
}

class UserData {
  String id;
  double saving;
  Period period;
  int feedPerPeriod;
  String phoneNumber;
  DateTime lastFeed;
  DateTime created;
  double money;

  Duration get timeUntilNextFeed {
    if (this.lastFeed == null) {
      return Duration(days: -1);
    }
    switch (period) {
      case Period.daily:
        return DateTime.now().difference(lastFeed.add(Duration(days: 1)));
        break;
      case Period.monthly:
        return DateTime.now().difference(lastFeed.add(Duration(days: 30)));
        break;
      case Period.weely:
        return DateTime.now().difference(lastFeed.add(Duration(days: 7)));
        break;
      case Period.demo:
        return DateTime.now().difference(lastFeed.add(Duration(days: -7)));
        break;
      default:
        return Duration(seconds: 1);
        break;
    }
  }

  factory UserData.fromFirebaseUser(FirebaseUser user) {
    return UserData(id: user.uid);
  }

  Map<String, dynamic> toJson() {
    return new Map.from({
      "uid": this.id,
      "saving": this.saving,
      "feedPerPeriod": this.feedPerPeriod,
      "phoneNumber": this.phoneNumber,
      "money": this.money,
      "period": this.period.index,
      "lastFeed": this.lastFeed,
      "created": this.created
    });
  }

  UserData(
      {this.id,
      this.saving,
      this.feedPerPeriod,
      this.period,
      this.money,
      this.lastFeed,
      this.phoneNumber,
      this.created});
}
