import '../services/notification.services.dart';
import '../services/services.export.dart';
import 'appState.dart';
import 'chore/chore.export.dart';
import 'piggy/piggy.export.dart';
import 'registration/registration.export.dart';
import 'user/user.export.dart';

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
  } else if (action is AddPiggy) {
    return addItem(appState, action);
  } else if (action is SetSchedule) {
    return setStoreSchedule(appState, action);
  } else if (action is ClearRegisterState) {
    return clearRegistrationStore(appState, action);
  } else if (action is SetUserType) {
    return setUserType(appState, action);
  } else if (action is SetFromOauth) {
    return setOauthAccount(appState, action);
  } else {
    return null;
  }
}

AppState handlePiggyActions(AppState appState, ChildPiggyAction action) {
  if (action is AddNewPiggy) {
    NotificationServices.sendNotificationNewPiggy(action.piggy.userId);
    PiggyFirebaseServices().addPiggy(action.piggy);
    return addPiggy(appState, action);
  } else if (action is FeedChildPiggy) {
    PiggyFirebaseServices().updatePiggyProperty('amount',
        action.isDouble ? action.amount * 2 : action.amount, action.piggyId);
    return feedChildPiggy(appState, action);
  } else if (action is RemovePiggy) {
    PiggyFirebaseServices().removePiggy(action.piggyId);
    return removePiggy(appState, action);
  } else if (action is CreateTempPiggy) {
    return createPiggyTemp(appState, action);
  } else if (action is ClearTempPiggy) {}
  return null;
}

AppState handleChoresActions(AppState appState, ChoreAction action) {
  if (action is AddChore) {
    ChoreFirebaseServices.createChoreForUser(action.chore);
    return addChore(appState, action);
  } else if (action is RemoveChore) {
    return removeChore(appState, action);
  } else if (action is FinishChore) {
    return finishChore(appState, action);
  } else if (action is AcceptChore) {
    return validateChore(appState, action);
  } else if (action is RefuseChore) {
    return refuseChore(appState, action);
  }
  return null;
}
