import 'package:flutter/cupertino.dart';
import 'package:piggybanx/Enums/level.dart';
import 'package:piggybanx/helpers/constants.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/post/user.post.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/services/user.social.post.service.dart';

import '../models/user/user.export.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

Future feedPiggyDatabase(BuildContext context, FeedPiggy action) async {
  var loc = PiggyLocalizations.of(context);
  var value = await Firestore.instance
      .collection("users")
      .where("id", isEqualTo: action.id)
      .getDocuments();

  var doc = value.documents.first;
  var user = UserData.fromFirebaseDocumentSnapshot(doc.data, doc.documentID);
  var piggy =
      user.piggies.singleWhere((p) => p.id == action.piggyId, orElse: null);

  var isBefejezteMarAzEtetesElott = piggy.money >= piggy.targetPrice;

  piggy.money = piggy.money + user.feedPerPeriod;
  piggy.currentSaving = piggy.currentSaving + user.feedPerPeriod;

  user.saving = user.saving + user.feedPerPeriod;

  piggy.currentFeedTime += 1;
  user.isDemoOver = user.isDemoOver;

  var newPiggyLevel = 0;

  if (piggy.currentFeedTime >= piggyLevelUpConstraint) {
    piggy.piggyLevel = PiggyLevel.values[piggy.piggyLevel.index + 1];
    piggy.currentFeedTime = 0;
  } else {
    newPiggyLevel = piggy.piggyLevel.index;
    piggy.piggyLevel = PiggyLevel.values[newPiggyLevel];
  }

  if (newPiggyLevel > maxLevel) {
    newPiggyLevel = maxLevel;
    user.isDemoOver = true;
    await showAlert(context, "Demo over");
    piggy.piggyLevel = PiggyLevel.values[newPiggyLevel];
  }

  user.numberOfCoins -= 1;
  user.lastFeed = DateTime.now();

  if (!isBefejezteMarAzEtetesElott && piggy.money >= piggy.targetPrice) {
    await UserPostService.createUserPiggyPost(UserPost(
        likes: 0,
        postedDate: Timestamp.now(),
        user: doc.reference,
        text:
            '${user.name} ${loc.trans('collected_the_money')} "${piggy.item}" ${loc.trans('for_item')}! ${loc.trans('congrats_on_saving')} :)'));
  }
  await Firestore.instance
      .collection('users')
      .document(doc.documentID)
      .updateData(user.toJson());
}
