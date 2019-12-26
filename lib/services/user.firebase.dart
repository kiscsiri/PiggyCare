import 'package:flutter/foundation.dart';

import '../firebase/firebase.implementations.dart/implementations.export.dart';
import '../firebase/locator.dart';
import '../models/appState.dart';
import '../models/item/item.model.dart';
import '../models/user/user.export.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
    var newCurrentFeedTime = ++doc.data['currentFeedTime'];
    var newDemo = doc.data['isDemoOver'];

    var newPiggyLevel = 0;
    if (newCurrentFeedTime >= 5) {
      newPiggyLevel = ++doc.data['piggyLevel'];
      newCurrentFeedTime = 0;
    } else {
      newPiggyLevel = doc.data['piggyLevel'];
    }

    if (newPiggyLevel > 2) {
      newPiggyLevel = 2;
      newDemo = true;
    }

    var feedDate = DateTime.now();
    Firestore.instance.collection('users').document(doc.documentID).updateData({
      'money': newMoney,
      'saving': newSaving,
      'lastFeed': feedDate,
      'piggyLevel': newPiggyLevel,
      'currentFeedTime': newCurrentFeedTime,
      'isDemoOver': newDemo
    });

    Firestore.instance
        .collection('items')
        .where('userId', isEqualTo: doc.documentID)
        .orderBy('createdDate', descending: true)
        .getDocuments()
        .then((value) {
      var item = Item.fromSnapshot(value.documents.first);
      var newValue = item.currentSaving + doc.data['feedPerPeriod'];
      Firestore.instance
          .collection('items')
          .document(value.documents.first.documentID)
          .updateData({
        'currentSaving': newValue,
      });
    });
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
    var result = await _api.addDocument(data.toJson());

    return;
  }
}
