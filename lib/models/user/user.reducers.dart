import 'package:piggycare/enums/level.dart';
import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/models/piggy/piggy.export.dart';
import 'package:piggycare/models/user/user.actions.dart';
import 'package:piggycare/models/user/user.model.dart';

import '../appState.dart';

AppState initUser(AppState state, InitUserData action) {
  var newUserData = new UserData(
      feedPerPeriod: action.user.feedPerPeriod,
      id: action.user.id,
      lastFeed: action.user.lastFeed,
      money: action.user.money,
      piggies: action.user.piggies,
      userType: action.user.userType,
      email: action.user.email,
      name: action.user.name,
      pictureUrl: action.user.pictureUrl,
      currentFeedTime: action.user.currentFeedTime,
      piggyLevel: action.user.piggyLevel,
      period: action.user.period,
      saving: action.user.saving,
      documentId: action.user.documentId,
      created: action.user.created);

  return AppState(user: newUserData, registrationData: state.registrationData);
}

AppState updateUser(AppState state, UpdateUserData action) {
  state.user.feedPerPeriod = action.user.feedPerPeriod;
  return AppState.fromAppState(state);
}

AppState feedPiggy(AppState state, FeedPiggy action) {
  state.user.currentFeedTime++;

  // if (state.user.currentFeedTime >= 5 &&
  //     state.user.piggyLevel != PiggyLevel.Teen) {
  //   state.user.piggyLevel =
  //       PiggyLevel.values[levelMap(state.user.piggyLevel) + 1];
  //   state.user.currentFeedTime = 0;
  // } else {
  //   state.user.piggyLevel = state.user.piggyLevel;
  // }

  // if (state.user.currentFeedTime >= 5 &&
  //     state.user.piggyLevel == PiggyLevel.Teen) {}

  // var index = state.user.piggies.indexWhere((p) => p.id == action.piggyId);
  // var piggy = state.user.piggies[index];

  // state.user.saving = state.user.saving + state.user.feedPerPeriod;

  // state.user.money = state.user.money - state.user.feedPerPeriod;
  // state.user.lastFeed = DateTime.now();

  // state.user.piggies[index] = Piggy(
  //     currentSaving: (piggy.currentSaving + state.user.feedPerPeriod),
  //     item: piggy.item,
  //     isApproved: piggy.isApproved,
  //     piggyLevel: state.user.piggyLevel,
  //     doubleUp: piggy.doubleUp,
  //     money: piggy.money,
  //     userId: piggy.userId,
  //     isFeedAvailable: true,
  //     id: piggy.id,
  //     targetPrice: piggy.targetPrice);

  return new AppState.fromAppState(state);
}

@deprecated
AppState setChildSavingPerFeed(AppState state, SetChildSavingPerFeed action) {
  var user = state.user;
  var newUserData = user;
  return new AppState(user: newUserData);
}

@deprecated
AppState setWantToSeeDoubleInfo(AppState state, SetSeenDoubleInfo action) {
  var user = state.user;

  var newUserData = user;
  return new AppState(user: newUserData);
}

@deprecated
AppState incrementCoins(AppState state, IncrementCoins action) {
  var user = state.user;

  var newUserData = user;
  return new AppState(user: newUserData);
}

@deprecated
AppState addChildToUser(AppState state, AddFamily action) {
  var newState = state.user;
  return new AppState(user: newState);
}

@deprecated
AppState validatePiggy(AppState state, ValidatePiggy action) {
  var newState = state.user;
  return new AppState(user: newState);
}
