import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piggybanx/models/chore/chore.export.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/screens/child.chores.details.dart';
import 'package:piggybanx/services/user.services.dart';

class ChoreFirebaseServices extends ChangeNotifier {
  static Future<void> createChoreForUser(Chore chore) async {
    try {
      var user = await UserServices.getUserById(chore.childId);

      user.chores.add(chore);

      Firestore.instance
          .collection('users')
          .document(user.documentId)
          .updateData(user.toJson());
    } catch (err) {
      throw Exception("Felhasználó nem található!");
    }
  }

  static Future<void> createChildChore(String childId, TaskDto task) async {
    var result =
        await Firestore.instance.collection('users').document(childId).get();

    var user =
        UserData.fromFirebaseDocumentSnapshot(result.data, result.documentID);

    user.chores.add(Chore(
        isDone: false,
        childId: childId,
        details: task.name,
        isValidated: false,
        reward: "2",
        title: task.name,
        id: user.chores.length++));

    await Firestore.instance.collection('users').add(user.toJson());
  }
}
