import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/post/user.post.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/services/user.social.post.service.dart';

class PiggyServices {
  static Future<void> createPiggyForUser(
      BuildContext context, Piggy piggy, String userId) async {
    var loc = PiggyLocalizations.of(context);

    var value = await Firestore.instance
        .collection("users")
        .where("id", isEqualTo: userId)
        .getDocuments();
    var doc = value.documents.first;

    var user = UserData.fromFirebaseDocumentSnapshot(doc.data, doc.documentID);
    piggy.id = user.piggies.length + 1;
    user.piggies.add(piggy);

    if (piggy.isApproved) {
      UserPostService.createUserPiggyPost(UserPost(
          likes: 0,
          text: user.name +
              " ${loc.trans('started_collection_for')} " +
              piggy.item,
          postedDate: Timestamp.now(),
          user: doc.reference));
    }

    Firestore.instance
        .collection('users')
        .document(doc.documentID)
        .updateData(user.toJson());
  }

  static Future<Piggy> validatePiggy(
      BuildContext context, int piggyId, String userId) async {
    var loc = PiggyLocalizations.of(context);
    var value = await Firestore.instance
        .collection("users")
        .where("id", isEqualTo: userId)
        .getDocuments();
    var doc = value.documents.first;

    var user = UserData.fromFirebaseDocumentSnapshot(doc.data, doc.documentID);

    var piggy = user.piggies.singleWhere((element) => element.id == piggyId);
    piggy.isApproved = true;

    await UserPostService.createUserPiggyPost(UserPost(
        likes: 0,
        text:
            user.name + " ${loc.trans('started_collection_for')} " + piggy.item,
        postedDate: Timestamp.now(),
        user: doc.reference));

    await Firestore.instance
        .collection('users')
        .document(doc.documentID)
        .updateData(user.toJson());

    return piggy;
  }
}
