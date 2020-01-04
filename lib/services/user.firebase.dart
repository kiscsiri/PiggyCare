import 'package:flutter/foundation.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';

import '../firebase/firebase.implementations.dart/implementations.export.dart';
import '../firebase/locator.dart';
import '../models/appState.dart';
import '../models/user/user.export.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

updateUserDatabase(AppState state, UpdateUserData action) {
  Firestore.instance
      .collection("users")
      .where("id", isEqualTo: state.user.id)
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
      .where("id", isEqualTo: action.id)
      .getDocuments()
      .then((QuerySnapshot value) {
    var doc = value.documents.first;
    var user = UserData.fromFirebaseDocumentSnapshot(doc.data);
    var piggy =
        user.piggies.singleWhere((p) => p.id == action.piggyId, orElse: null);

    piggy.money = piggy.money + piggy.currentFeedAmount;
    piggy.currentSaving = piggy.currentSaving + piggy.currentFeedAmount;

    user.saving = user.saving + piggy.currentFeedAmount;

    user.currentFeedTime = ++doc.data['currentFeedTime'];
    user.isDemoOver = doc.data['isDemoOver'];

    var newPiggyLevel = 0;

    if (user.currentFeedTime >= 5) {
      user.piggyLevel = PiggyLevel.values[user.piggyLevel.index + 1];
      piggy.piggyLevel = PiggyLevel.values[newPiggyLevel + 1];
      user.currentFeedTime = 0;
    } else {
      newPiggyLevel = user.piggyLevel.index;
      user.piggyLevel = PiggyLevel.values[newPiggyLevel];
      piggy.piggyLevel = PiggyLevel.values[newPiggyLevel];
    }

    if (newPiggyLevel > 2) {
      newPiggyLevel = 2;
      user.isDemoOver = true;
      user.piggyLevel = PiggyLevel.values[newPiggyLevel];
      piggy.piggyLevel = PiggyLevel.values[newPiggyLevel];
    }

    user.lastFeed = DateTime.now();

    Firestore.instance
        .collection('users')
        .document(doc.documentID)
        .updateData(user.toJson());
  });
}

class UserFirebaseServices extends ChangeNotifier {
  UsersApi _api = locator<UsersApi>();

  List<UserData> users;

  Future<List<UserData>> fetchChores() async {
    var result = await _api.getDataCollection();
    users = result.documents.map((doc) => UserData.fromMap(doc.data)).toList();
    return users;
  }

  Stream<QuerySnapshot> fetchChoresAsStream() {
    return _api.streamDataCollection();
  }

  Future<UserData> getChoreById(String id) async {
    var doc = await _api.getDocumentById(id);
    return UserData.fromMap(doc.data);
  }

  Future removeChore(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateChore(UserData data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future addChore(UserData data) async {
    await _api.addDocument(data.toJson());
    return;
  }
}
