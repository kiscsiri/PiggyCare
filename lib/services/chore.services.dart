import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/models/chore/chore.export.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/screens/child.chores.details.dart';

class ChoreServices {
  static Future<void> createChildChore(String childId, TaskDto task) async {
      var results = await Firestore.instance.collection('users')
        .where('id', isEqualTo: childId)
        .getDocuments();

      var user = UserData.fromFirebaseDocumentSnapshot(results.documents.first.data);

      user.chores.add(Chore(
        isDone: false,
        childId: childId,
        details: task.name,
        isValidated: false,
        reward: "2",
        title: task.name,
        id: user.chores.length++
      ));

      await Firestore.instance.collection('users')
      .add(user.toJson());
  }
}