import 'package:piggybanx/models/chore/chore.action.dart';
import 'package:piggybanx/models/piggy/piggy.action.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/models/registration/registration.reducers.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.reducers.dart';

import 'appState.dart';
import 'chore/chore.export.dart';
import 'user/user.firebase.dart';

AppState applicationReducer(AppState appState, dynamic action) {
  if (action is RegistrationAction) {
    return handleRegistrationActions(appState, action);
  } else if (action is UserAction) {
    return handleUserActions(appState, action);
  } else if (action is ChoreAction) {
    return handleChoresActions(appState, action);
  } else if (action is ChildPiggyAction) {
    return handlePiggyActions(appState, action);
  } else {
    return null;
  }
}

AppState handleUserActions(AppState appState, UserAction action) {
  if (action is UpdateUserData) {
    updateUserDatabase(appState, action);
    return updateUser(appState, action);
  } else if (action is InitUserData) {
    return initUser(appState, action);
  } else if (action is UpdateUserData) {
    updateUserDatabase(appState, action);
    return updateUser(appState, action);
  } else if (action is InitUserData) {
    return initUser(appState, action);
  } else if (action is FeedPiggy) {
    feedPiggyDatabase(action);
    return feedPiggy(appState, action);
  } else if (action is SaveSettingsAction) {
    return appState;
  } else {
    return null;
  }
}

AppState handleRegistrationActions(
    AppState appState, RegistrationAction action) {
  if (action is SetItem) {
    return setStoreItem(appState, action);
  } else if (action is SetPhoneNumber) {
    return setStorePhoneNumber(appState, action);
  } else if (action is InitRegistration) {
    return initRegistrationState(appState, action);
  } else if (action is SetPrice) {
    return setStoreTargetPrice(appState, action);
  } else if (action is AddItem) {
    addItemDatabase(action, appState.user.id);
    return addItem(appState, action);
  } else if (action is SetSchedule) {
    return setStoreSchedule(appState, action);
  } else if (action is ClearRegisterState) {
    return clearRegistrationStore(appState, action);
  } else {
    return null;
  }
}

AppState handlePiggyActions(AppState appState, ChildPiggyAction action) {
  // TODO - Ide beépíteni a piggy reducereket
  return null;
}

AppState handleChoresActions(AppState appState, ChoreAction action) {
  if (action is AddChore) {
    return addChore(appState, action);
  } else if (action is RemoveChore) {
    return removeChore(appState, action);
  } else if (action is FinishChore) {
    return finishChore(appState, action);
  } else if (action is AcceptChore) {
    return validateChore(appState, action);
  }
  return null;
}
