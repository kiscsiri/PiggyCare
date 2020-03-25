import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/chore/chore.action.dart';
import 'package:piggybanx/models/chore/chore.export.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/screens/child.chores.details.dart';
import 'package:piggybanx/screens/friend.requests.dart';
import 'package:piggybanx/services/chore.firebase.dart';
import 'package:piggybanx/services/notification.services.dart';
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
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    if (store.state.user.id == data['userId'] || data['userId'] == null) {
      switch (data['modalType']) {
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
        case "AproveTaskCompleted":
          bool ack = await showCompletedTask(context, data['userName']);
          if (ack ?? false) {
            await ChoreFirebaseServices.validateChildChore(
                data['senderId'], int.tryParse(data['taskId']));
            await NotificationServices.sendNotificationValidatedTask(
                data['senderId'], int.tryParse(data['taskId']));
          } else {
            await NotificationServices.sendNotificationRefusedTask(
                data['senderId'], int.tryParse(data['taskId']));
            await ChoreFirebaseServices.refuseChildChore(
                data['senderId'], int.tryParse(data['taskId']));
          }
          break;
        case "TaskValidated":
          await showValidatedTask(context, data['userName']);
          store.dispatch(
              AcceptChore(data['userId'], int.tryParse(data['taskId'])));
          break;
        case "FriendRequestAccepted":
          var user = await UserServices.getUserById(data['senderId']);
          if (store.state.user.userType == UserType.adult)
            store.dispatch(AddChild(user));

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
}
