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

    if (user.chores.length != 0)
      chore.id = (user.chores.last.id ?? 1) + 1;
    else
      chore.id = 1;
    user.chores.add(chore);

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
    var chore = user.chores
        .singleWhere((element) => element.id == choreId, orElse: null);

    return chore;
  }

  static Future<void> finishChildChore(String id, int taskId, parentId) async {
    var result =
        await Firestore.instance.collection('donators').document(id).get();

    var user =
        UserData.fromFirebaseDocumentSnapshot(result.data, result.documentID);

    var task = user.chores
        .singleWhere((element) => element.id == taskId, orElse: null);

    task.isDone = true;

    await Firestore.instance
        .collection('donators')
        .document(id)
        .updateData(user.toJson());

    NotificationServices.sendNotificationFinishedTask(
        user.parentId, user.name, task.title, task.id, user.id);
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

      userData.numberOfCoins = userData.numberOfCoins ?? 1;
      var task = userData.chores
          .singleWhere((element) => element.id == taskId, orElse: null);

      task.isValidated = true;
      task.isDone = true;
      task.finishedDate = DateTime.now();

      await UserPostService.createUserPiggyPost(UserPost(
          likes: 0,
          postedDate: DateTime.now(),
          user: user.reference,
          text:
              '${userData.name} épp befejezte a "${task.title}" nevű feladatát!'));
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

      var task = userData.chores
          .singleWhere((element) => element.id == taskId, orElse: null);

      task.isDone = false;
      task.isValidated = false;

      await Firestore.instance
          .collection('donators')
          .document(user.documentID)
          .updateData(userData.toJson());
    }
  }
}
