import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/models/chore/chore.action.dart';
import 'package:piggycare/models/user/parent.model.dart';

AppState addChore(AppState state, AddChore action) {
  var user = state.user;
  if (user.userType == UserType.business) {
    // var child = user.children.singleWhere((d) => d.id == action.chore.childId);
    // child.chores.add(action.chore);
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState addChoreChild(AppState state, AddChoreChild action) {
  var user = state.user;

  // state.user.chores.add(action.chore);

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState removeChore(AppState state, RemoveChore action) {
  var user = state.user;
  if (user is Parent) {
    // var child = user.children.singleWhere((d) => d.id == action.childId);
    // child.chores.removeWhere((ch) => ch.id == action.choreId);
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState finishChore(AppState state, FinishChore action) {
  var user = state.user;
  if (user.userType == UserType.donator) {
    // var chore = user.chores.singleWhere((d) => d.id == action.choreId);
    // chore.isDone = true;
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState validateChore(AppState state, AcceptChore action) {
  var user = state.user;
  if (user.userType == UserType.donator) {
    // var chore = user.chores.singleWhere((d) => d.id == action.choreId);

    // user.numberOfCoins = user.numberOfCoins != null ? user.numberOfCoins++ : 1;
    // chore.isDone = true;
    // chore.isValidated = true;
    // chore.finishedDate = DateTime.now();
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState refuseChore(AppState state, RefuseChore action) {
  var user = state.user;
  if (user.userType == UserType.donator) {
    // var chore = user.chores.singleWhere((d) => d.id == action.choreId);

    // chore.isDone = false;
    // chore.isValidated = false;
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState validateChildChore(AppState state, ValidateChoreParent action) {
  var user = state.user;

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState finishChildChore(AppState state, FinishChoreParent action) {
  var user = state.user;
  if (user.userType == UserType.business) {}

  var newUserData = user;
  return new AppState(user: newUserData);
}
