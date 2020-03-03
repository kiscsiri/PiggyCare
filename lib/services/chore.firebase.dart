import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piggybanx/models/chore/chore.export.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/services/notification.services.dart';
import 'package:piggybanx/services/user.services.dart';

class ChoreFirebaseServices extends ChangeNotifier {
  static Future<void> createChoreForUser(Chore chore) async {
    var user = await UserServices.getUserById(chore.childId);
    if (user.chores.length != 0)
      chore.id = (user.chores.last.id ?? 1) + 1;
    else
      chore.id = 1;
    user.chores.add(chore);

    Firestore.instance
        .collection('users')
        .document(user.documentId)
        .updateData(user.toJson());
  }

  static Future<void> finishChildChore(String id, int taskId, parentId) async {
    var result =
        await Firestore.instance.collection('users').document(id).get();

    var user =
        UserData.fromFirebaseDocumentSnapshot(result.data, result.documentID);

    var task = user.chores
        .singleWhere((element) => element.id == taskId, orElse: null);

    task.isDone = true;

    await Firestore.instance
        .collection('users')
        .document(id)
        .updateData(user.toJson());

    NotificationServices.sendNotificationFinishedTask(
        user.parentId, user.name, task.title, task.id, user.id);
  }

  static Future<void> validateChildChore(String userId, int taskId) async {
    var result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .getDocuments();
    if (result.documents.length != 0) {
      var user = result.documents.first;
      var userData =
          UserData.fromFirebaseDocumentSnapshot(user.data, user.documentID);

      var task = userData.chores
          .singleWhere((element) => element.id == taskId, orElse: null);

      task.isValidated = true;

      await Firestore.instance
          .collection('users')
          .document(user.documentID)
          .updateData(userData.toJson());
    }
  }

  static Future<void> refuseChildChore(String userId, int taskId) async {
    var result = await Firestore.instance
        .collection('users')
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
          .collection('users')
          .document(user.documentID)
          .updateData(userData.toJson());
    }
  }
}
