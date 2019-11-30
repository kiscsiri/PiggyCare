import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/chore/chore.action.dart';
import 'package:piggybanx/models/user/child.model.dart';
import 'package:piggybanx/models/user/parent.model.dart';

AppState addChore(AppState state, AddChore action) {
  var user = state.user;
  if (user is Parent) {
    var child = user.children.singleWhere((d) => d.id == action.chore.childId);
    child.chores.add(action.chore);
  }

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
  if (user is Child) {
    var chore = user.chores.singleWhere((d) => d.id == action.childId);
    chore.isDone = true;
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState validateChore(AppState state, AcceptChore action) {
  var user = state.user;
  if (user is Parent) {
    var child = user.children.singleWhere((d) => d.id == action.childId);

    var chore = child.chores.singleWhere((ch) => ch.id == action.choreId);
    chore.isDone = true;
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}
