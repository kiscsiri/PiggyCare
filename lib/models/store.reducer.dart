import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/models/registration/registration.reducers.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.reducers.dart';

AppState applicationReducer(AppState appState, dynamic action) {
  if (action is SetItem) {
    return setStoreItem(appState, action);
  } else if (action is SetPhoneNumber) {
    return setStorePhoneNumber(appState, action);
  } else if (action is InitRegistration) {
    return initRegistrationState(appState, action);
  } else if (action is SaveSettingsAction) {
    return appState;
  } else if (action is ClearRegisterState) {
    return clearRegistrationStore(appState, action);
  } else if (action is FeedPiggy) {
    feedPiggyDatabase(action);
    return feedPiggy(appState, action);
  } else if (action is UpdateUserData) {
    updateUserDatabase(appState, action);
    return updateUser(appState, action);
  } else if (action is InitUserData) {
    return initUser(appState, action);
  } else if (action is SetPrice) {
    return setStoreTargetPrice(appState, action);
  } else if (action is SetSchedule) {
    return setStoreSchedule(appState, action);
  } else {
    return null;
  }
}
