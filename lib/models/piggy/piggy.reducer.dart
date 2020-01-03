import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.action.dart';
import 'package:piggybanx/models/user/user.export.dart';

AppState addPiggy(AppState state, AddNewPiggy action) {
  return AppState.fromAppState(state);
}

AppState removePiggy(AppState state, RemovePiggy action) {
  var user = state.user;
  if (user is Child) {
    user.piggies.removeWhere((ch) => ch.id == action.piggyId);
  }
  return AppState.fromAppState(state);
}

AppState feedChildPiggy(AppState state, FeedChildPiggy action) {
  var user = state.user;
  if (user is Child) {
    var chore = user.piggies.singleWhere((d) => d.id == action.piggyId);
    chore.money = action.isDouble ? action.amount * 2 : action.amount;
  }

  return AppState.fromAppState(state);
}

AppState createPiggyTemp(AppState state, CreateTempPiggy action) {
  state.tempPiggy = action.piggy;
  return AppState.fromAppState(state);
}

AppState clearTempPiggy(AppState state, ClearTempPiggy action) {
  state.tempPiggy = null;
  return AppState.fromAppState(state);
}

AppState growPiggy(AppState state, action) {
  var user = state.user;
  if (user is Parent) {
    var child = user.children.singleWhere((d) => d.id == action.childId);

    var chore = child.chores.singleWhere((ch) => ch.id == action.choreId);
    chore.isDone = true;
  }

  var newUserData = user;
  return new AppState(user: newUserData);
}
