import 'package:piggycare/enums/level.dart';
import 'package:piggycare/models/post/user.post.dart';
import 'package:piggycare/services/user.social.post.service.dart';

import '../models/user/user.export.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

Future feedPiggyDatabase(FeedPiggy action) async {
  var value = await Firestore.instance
      .collection('users')
      .where("id", isEqualTo: action.id)
      .getDocuments();

  var doc = value.documents.first;
  var user = UserData.fromFirebaseDocumentSnapshot(doc.data, doc.documentID);
  // var piggy =
  //     user.piggies.singleWhere((p) => p.id == action.piggyId, orElse: null);

  // var isBefejezteMarAzEtetesElott = piggy.money >= piggy.targetPrice;

  // piggy.money = piggy.money + user.feedPerPeriod;
  // piggy.currentSaving = piggy.currentSaving + user.feedPerPeriod;

  user.saving = user.saving + user.feedPerPeriod;

  user.currentFeedTime = ++doc.data['currentFeedTime'];
  var newPiggyLevel = 0;

  // if (user.currentFeedTime >= 5) {
  //   user.piggyLevel = PiggyLevel.values[user.piggyLevel.index + 1];
  //   piggy.piggyLevel = PiggyLevel.values[newPiggyLevel + 1];
  //   user.currentFeedTime = 0;
  // } else {
  //   newPiggyLevel = user.piggyLevel.index;
  //   user.piggyLevel = PiggyLevel.values[newPiggyLevel];
  //   piggy.piggyLevel = PiggyLevel.values[newPiggyLevel];
  // }

  // if (newPiggyLevel > 2) {
  //   newPiggyLevel = 2;
  //   user.piggyLevel = PiggyLevel.values[newPiggyLevel];
  //   piggy.piggyLevel = PiggyLevel.values[newPiggyLevel];
  // }

  user.lastFeed = DateTime.now();

  // if (!isBefejezteMarAzEtetesElott && piggy.money >= piggy.targetPrice) {
  //   await UserPostService.createUserPiggyPost(UserPost(
  //       likes: 0,
  //       postedDate: DateTime.now(),
  //       user: doc.reference,
  //       text:
  //           '${user.name} összegyűjtötte a pénzt egy "${piggy.item}" nevű tárgyra! Gratuláció a megtakarításhoz! :)'));
  // }
  Firestore.instance
      .collection('users')
      .document(doc.documentID)
      .updateData(user.toJson());
}
