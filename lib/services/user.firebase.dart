import 'package:piggybanx/enums/level.dart';

import '../models/user/user.export.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

feedPiggyDatabase(FeedPiggy action) {
  Firestore.instance
      .collection("users")
      .where("id", isEqualTo: action.id)
      .getDocuments()
      .then((QuerySnapshot value) {
    var doc = value.documents.first;
    var user = UserData.fromFirebaseDocumentSnapshot(doc.data, doc.documentID);
    var piggy =
        user.piggies.singleWhere((p) => p.id == action.piggyId, orElse: null);

    piggy.money = piggy.money + user.feedPerPeriod;
    piggy.currentSaving = piggy.currentSaving + user.feedPerPeriod;

    user.saving = user.saving + user.feedPerPeriod;

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
