import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/chore/chore.export.dart';
import 'package:piggybanx/models/post/user.post.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/services/analytics.service.dart';
import 'package:piggybanx/services/notification.services.dart';
import 'package:piggybanx/services/user.services.dart';
import 'package:piggybanx/services/user.social.post.service.dart';
import 'package:redux/redux.dart';

class ChoreFirebaseServices extends ChangeNotifier {
  static Future<int> createChoreForUser(
      BuildContext context, Chore chore, Store<AppState> store) async {
    var loc = PiggyLocalizations.of(context);
    DocumentSnapshot userSnap;
    try {
      userSnap = (await Firestore.instance
              .collection('users')
              .where('id', isEqualTo: chore.childId)
              .getDocuments())
          .documents
          .first;
    } on StateError catch (err) {
      throw Exception("${loc.trans('no_account')}");
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
        postedDate: Timestamp.now(),
        user: userSnap.reference,
        text:
            '${store.state.user.name} ${loc.trans('gave_task')} ${user.name} ${loc.trans('for')}, ${loc.trans('namen_before')} "${chore.title}" ${loc.trans('namen_after')}!'));

    await Firestore.instance
        .collection('users')
        .document(user.documentId)
        .updateData(user.toJson());
    AnalyticsService.logTaszkCreated();
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

  static Future<void> validateChildChore(
      BuildContext context, String userId, int taskId) async {
    var loc = PiggyLocalizations.of(context);
    var result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .getDocuments();
    if (result.documents.length != 0) {
      var user = result.documents.first;
      var userData =
          UserData.fromFirebaseDocumentSnapshot(user.data, user.documentID);

      userData.numberOfCoins =
          userData.numberOfCoins == null ? 1 : userData.numberOfCoins + 1;
      var task = userData.chores
          .singleWhere((element) => element.id == taskId, orElse: null);

      task.isValidated = true;
      task.isDone = true;
      task.finishedDate = DateTime.now();

      await UserPostService.createUserPiggyPost(UserPost(
          likes: 0,
          postedDate: Timestamp.now(),
          user: user.reference,
          text:
              '${userData.name} ${loc.trans('finished')} "${task.title}" ${loc.trans('named_task')}!'));
      await Firestore.instance
          .collection('users')
          .document(user.documentID)
          .updateData(userData.toJson());
      AnalyticsService.logTaskCompleted();
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
