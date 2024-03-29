import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggycare/models/piggy/piggy.export.dart';
import 'package:piggycare/models/post/user.post.dart';
import 'package:piggycare/models/user/user.export.dart';
import 'package:piggycare/services/user.social.post.service.dart';

class PiggyServices {
  static Future<void> createPiggyForUser(Piggy piggy, String userId) async {
    var value = await Firestore.instance
        .collection('users')
        .where("id", isEqualTo: userId)
        .getDocuments();
    var doc = value.documents.first;

    var user = UserData.fromFirebaseDocumentSnapshot(doc.data, doc.documentID);
    piggy.id = user.piggies.length + 1;
    user.piggies.add(piggy);

    // if (piggy.isApproved) {
    //   UserPostService.createUserPiggyPost(UserPost(
    //       likes: 0,
    //       text: user.name +
    //           " elkezdett gyűjteni az alábbi dologra: " +
    //           piggy.item,
    //       postedDate: DateTime.now(),
    //       user: doc.reference));
    // }

    Firestore.instance
        .collection('users')
        .document(doc.documentID)
        .updateData(user.toJson());
  }

  static Future<void> validatePiggy(int piggyId, String userId) async {
    var value = await Firestore.instance
        .collection('users')
        .where("id", isEqualTo: userId)
        .getDocuments();
    var doc = value.documents.first;

    var user = UserData.fromFirebaseDocumentSnapshot(doc.data, doc.documentID);

    var piggy = user.piggies.singleWhere((element) => element.id == piggyId);
    piggy.isApproved = true;

    // UserPostService.createUserPiggyPost(UserPost(
    //     likes: 0,
    //     text: user.name + " elkezdett gyűjteni erre: " + piggy.item,
    //     postedDate: DateTime.now(),
    //     user: doc.reference));

    Firestore.instance
        .collection('users')
        .document(doc.documentID)
        .updateData(user.toJson());
  }
}
