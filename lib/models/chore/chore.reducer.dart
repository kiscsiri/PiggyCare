import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/chore/chore.action.dart';
import 'package:piggybanx/models/user/parent.model.dart';

AppState addChore(AppState state, AddChore action) {
  var user = state.user;
  if (user.userType == UserType.adult) {
    var child = user.children.singleWhere((d) => d.id == action.chore.childId);
    child.chores.add(action.chore);
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState addChoreChild(AppState state, AddChoreChild action) {
  var user = state.user;

  state.user.chores.add(action.chore);

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState removeChore(AppState state, RemoveChore action) {
  var user = state.user;
  if (user is Parent) {
    var child = user.children.singleWhere((d) => d.id == action.childId);
    child.chores.removeWhere((ch) => ch.id == action.choreId);
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState finishChore(AppState state, FinishChore action) {
  var user = state.user;
  if (user.userType == UserType.child) {
    var chore = user.chores.singleWhere((d) => d.id == action.choreId);
    chore.isDone = true;
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState validateChore(AppState state, AcceptChore action) {
  var user = state.user;
  if (user.userType == UserType.child) {
    var chore = user.chores.singleWhere((d) => d.id == action.choreId);

    user.numberOfCoins = user.numberOfCoins != null ? user.numberOfCoins++ : 1;
    chore.isDone = true;
    chore.isValidated = true;
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState refuseChore(AppState state, RefuseChore action) {
  var user = state.user;
  if (user.userType == UserType.child) {
    var chore = user.chores.singleWhere((d) => d.id == action.choreId);

    chore.isDone = false;
    chore.isValidated = false;
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState validateChildChore(AppState state, ValidateChoreParent action) {
  var user = state.user;
  if (user.userType == UserType.adult) {
    var chore = user.children
        .singleWhere((d) => d.id == action.childId, orElse: null)
        ?.chores
        ?.singleWhere((d) => d.id == action.choreId, orElse: null);

    chore.isDone = false;
    chore.isValidated = false;
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}
