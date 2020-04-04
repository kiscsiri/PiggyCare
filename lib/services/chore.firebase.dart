import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/models/chore/chore.export.dart';
import 'package:piggycare/models/post/user.post.dart';
import 'package:piggycare/models/user/user.export.dart';
import 'package:piggycare/services/notification.services.dart';
import 'package:piggycare/services/user.services.dart';
import 'package:piggycare/services/user.social.post.service.dart';
import 'package:redux/redux.dart';

@deprecated
class ChoreFirebaseServices extends ChangeNotifier {
  static Future<int> createChoreForUser(
      Chore chore, Store<AppState> store) async {
    DocumentSnapshot userSnap;
    try {
      userSnap = (await Firestore.instance
              .collection('donators')
              .where('id', isEqualTo: chore.childId)
              .getDocuments())
          .documents
          .first;
    } on StateError {
      throw Exception("Felhasználó nem található");
    }

    var user = UserData.fromFirebaseDocumentSnapshot(
        userSnap.data, userSnap.documentID);

    await UserPostService.createUserPiggyPost(UserPost(
        likes: 0,
        postedDate: DateTime.now(),
        user: userSnap.reference,
        text:
            '${store.state.user.name} feladatot adott ${user.name} számára, "${chore.title}" néven!'));

    Firestore.instance
        .collection('donators')
        .document(user.documentId)
        .updateData(user.toJson());

    return chore.id;
  }

  static Future<Chore> getChoreForChild(int choreId, String childId) async {
    var user = await UserServices.getUserById(childId);
  }

  static Future<void> finishChildChore(String id, int taskId, parentId) async {
    var result =
        await Firestore.instance.collection('donators').document(id).get();

    var user =
        UserData.fromFirebaseDocumentSnapshot(result.data, result.documentID);

    await Firestore.instance
        .collection('donators')
        .document(id)
        .updateData(user.toJson());
  }

  static Future<void> validateChildChore(String userId, int taskId) async {
    var result = await Firestore.instance
        .collection('donators')
        .where('id', isEqualTo: userId)
        .getDocuments();
    if (result.documents.length != 0) {
      var user = result.documents.first;
      var userData =
          UserData.fromFirebaseDocumentSnapshot(user.data, user.documentID);

      await Firestore.instance
          .collection('donators')
          .document(user.documentID)
          .updateData(userData.toJson());
    }
  }

  static Future<void> refuseChildChore(String userId, int taskId) async {
    var result = await Firestore.instance
        .collection('donators')
        .where('id', isEqualTo: userId)
        .getDocuments();
    if (result.documents.length != 0) {
      var user = result.documents.first;
      var userData =
          UserData.fromFirebaseDocumentSnapshot(user.data, user.documentID);

      await Firestore.instance
          .collection('donators')
          .document(user.documentID)
          .updateData(userData.toJson());
    }
  }
}
