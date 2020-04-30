import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/models/chore/chore.action.dart';
import 'package:piggybanx/models/chore/chore.export.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/screens/child.chores.details.dart';
import 'package:piggybanx/screens/friend.requests.dart';
import 'package:piggybanx/services/chore.firebase.dart';
import 'package:piggybanx/services/notification.services.dart';
import 'package:piggybanx/services/piggy.firebase.services.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/services/notification.modals.dart';
import 'package:piggybanx/services/user.services.dart';

_navigate(int index, PageController _pageController) {
  _pageController.animateToPage(index,
      curve: Curves.linear, duration: new Duration(milliseconds: 350));
}

Future<dynamic> onResumeNotificationHandler(Map<String, dynamic> message,
    BuildContext context, PageController _pageController) async {
  var store = StoreProvider.of<AppState>(context);
  var user = store.state.user;
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    switch (data['modalType']) {
      case "FeedPerCoinSet":
        store.dispatch(UpdateUserData(
            UserData(feedPerPeriod: int.tryParse(data['feedPerCoin']))));
        break;
      case "ParentNewTask":
        var res = await showAskedForNewTask(
            context, data['userName'], data['userId']);
        if (res ?? false) {
          _navigate(2, _pageController);
          await showCreateTask(context, store,
              ChildDto(id: data['senderId'], name: data['userName']));
        } else {
          Navigator.of(context).pop();
        }
        break;
      case "ChildrenNewTask":
        await showChildrenNewTask(context, data['userName']);
        break;
      case "CreatePiggyParentAlert":
        Map<String, dynamic> piggy = json.decode(data['piggyData']);
        var validated = await showChildrenNewPiggy(context, data['userName'],
            piggy['targetName'], piggy['targetPrice']);
        if (validated ?? false) {
          var validatedPiggy = await PiggyServices.validatePiggy(
              context, piggy['id'], data['senderId']);
          store.dispatch(ValidatePiggy(
              piggy: validatedPiggy,
              childId: data['senderId'],
              isValidated: validated));
          await NotificationServices.sendPiggyApproved(
              store.state.user.name, data['senderId'], piggy['id']);
        } else {}
        break;
      case "ValidatedPiggy":
        dynamic piggy = json.decode(data['piggyData']);
        store.dispatch(ValidatePiggy(piggy: Piggy(id: piggy['id'])));
        await showChildrenAcceptedPiggy(context, piggy['id']);
        break;
      case "AproveTaskCompleted":
        int taskId = int.tryParse(data['taskId']);
        store.dispatch(FinishChoreParent(data['senderId'], taskId));
        bool ack = await showCompletedTask(context, data['userName']);
        if (ack ?? false) {
          store.dispatch(ValidateChoreParent(data['senderId'], taskId, true));
          await ChoreFirebaseServices.validateChildChore(
              context, data['senderId'], taskId);
          await NotificationServices.sendNotificationValidatedTask(
              data['senderId'], taskId);
        } else {
          store.dispatch(ValidateChoreParent(data['senderId'], taskId, false));
          await NotificationServices.sendNotificationRefusedTask(
              data['senderId'], taskId);
          await ChoreFirebaseServices.refuseChildChore(
              data['senderId'], taskId);
        }
        break;
      case "TaskValidated":
        await showValidatedTask(context, data['userName']);
        store.dispatch(
            AcceptChore(data['userId'], int.tryParse(data['taskId'])));
        break;
      case "FriendRequestAccepted":
        var user = await UserServices.getUserById(data['senderId']);
        store.dispatch(AddFamily(user));
        await showFriendRequestAccepted(context, user.name);
        break;
      case "TaskRefused":
        await showRefusedTask(context, data['userName']);
        store.dispatch(
            RefuseChore(data['userId'], int.tryParse(data['taskId'])));
        break;
      case "NewTask":
        await showChildrenNewTask(context, data['userName']);
        var chore = await ChoreFirebaseServices.getChoreForChild(
            int.tryParse(data['taskId']), data['userId']);

        store.dispatch(AddChoreChild(chore));
        _navigate(2, _pageController);
        break;
      case "FriendRequest":
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new FirendRequestsScreen(
                  currentUserId: store.state.user.id,
                )));
        break;
      default:
        break;
    }
  }
}

Future<dynamic> onStartNotificationHandler(Map<String, dynamic> message,
    BuildContext context, PageController _pageController) async {
  var store = StoreProvider.of<AppState>(context);
  var user = store.state.user;
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    switch (data['modalType']) {
      case "FeedPerCoinSet":
        store.dispatch(UpdateUserData(
            UserData(feedPerPeriod: int.tryParse(data['feedPerCoin']))));
        break;
      case "ParentNewTask":
        var res = await showAskedForNewTask(
            context, data['userName'], data['userId']);
        if (res ?? false) {
          _navigate(2, _pageController);
          await showCreateTask(context, store,
              ChildDto(id: data['senderId'], name: data['userName']));
        } else {
          Navigator.of(context).pop();
        }
        break;
      case "ChildrenNewTask":
        await showChildrenNewTask(context, data['userName']);
        break;
      case "CreatePiggyParentAlert":
        Map<String, dynamic> piggy = json.decode(data['piggyData']);
        var validated = await showChildrenNewPiggy(context, data['userName'],
            piggy['targetName'], piggy['targetPrice']);
        if (validated ?? false) {
          var validatedPiggy = await PiggyServices.validatePiggy(
              context, piggy['id'], data['senderId']);
          store.dispatch(ValidatePiggy(
              piggy: validatedPiggy,
              childId: data['senderId'],
              isValidated: validated));
          await NotificationServices.sendPiggyApproved(
              store.state.user.name, data['senderId'], piggy['id']);
        } else {}
        break;
      case "ValidatedPiggy":
        dynamic piggy = json.decode(data['piggyData']);
        store.dispatch(ValidatePiggy(piggy: Piggy(id: piggy['id'])));
        await showChildrenAcceptedPiggy(context, piggy['id']);
        break;
      case "AproveTaskCompleted":
        int taskId = int.tryParse(data['taskId']);
        store.dispatch(FinishChoreParent(data['senderId'], taskId));
        bool ack = await showCompletedTask(context, data['userName']);
        if (ack ?? false) {
          store.dispatch(ValidateChoreParent(data['senderId'], taskId, true));
          await ChoreFirebaseServices.validateChildChore(
              context, data['senderId'], taskId);
          await NotificationServices.sendNotificationValidatedTask(
              data['senderId'], taskId);
        } else {
          store.dispatch(ValidateChoreParent(data['senderId'], taskId, false));
          await NotificationServices.sendNotificationRefusedTask(
              data['senderId'], taskId);
          await ChoreFirebaseServices.refuseChildChore(
              data['senderId'], taskId);
        }
        break;
      case "TaskValidated":
        await showValidatedTask(context, data['userName']);
        store.dispatch(
            AcceptChore(data['userId'], int.tryParse(data['taskId'])));
        break;
      case "FriendRequestAccepted":
        var user = await UserServices.getUserById(data['senderId']);
        store.dispatch(AddFamily(user));
        await showFriendRequestAccepted(context, user.name);
        break;
      case "TaskRefused":
        await showRefusedTask(context, data['userName']);
        store.dispatch(
            RefuseChore(data['userId'], int.tryParse(data['taskId'])));
        break;
      case "NewTask":
        await showChildrenNewTask(context, data['userName']);
        _navigate(2, _pageController);
        break;
      case "FriendRequest":
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new FirendRequestsScreen(
                  currentUserId: store.state.user.id,
                )));
        break;
      default:
        break;
    }
  }
}
