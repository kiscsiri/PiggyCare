import 'package:piggycare/models/appState.dart';
import 'package:piggycare/models/piggy/piggy.action.dart';
import 'package:piggycare/models/user/user.export.dart';

AppState addPiggy(AppState state, AddNewPiggy action) {
  return AppState.fromAppState(state);
}

AppState removePiggy(AppState state, RemovePiggy action) {
  var user = state.user;
  return AppState.fromAppState(state);
}

AppState feedChildPiggy(AppState state, FeedChildPiggy action) {
  var user = state.user;

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

  var newUserData = user;
  return new AppState(user: newUserData);
}
