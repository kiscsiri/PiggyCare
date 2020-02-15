import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.model.dart';

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
      isDemoOver: action.user.isDemoOver,
      phoneNumber: action.user.phoneNumber,
      saving: action.user.saving,
      children: action.user.children,
      created: action.user.created);
  return new AppState(
      user: newUserData, registrationData: state.registrationData);
}

AppState updateUser(AppState state, UpdateUserData action) {
  var newUserData = new UserData(
      feedPerPeriod: action.user.feedPerPeriod,
      id: state.user.id,
      lastFeed: state.user.lastFeed,
      piggies: state.user.piggies,
      money: state.user.money,
      currentFeedTime: state.user.currentFeedTime,
      piggyLevel: state.user.piggyLevel,
      period: action.user.period,
      name: state.user.name,
      email: state.user.email,
      pictureUrl: state.user.pictureUrl,
      userType: state.user.userType,
      phoneNumber: state.user.phoneNumber,
      saving: state.user.saving,
      isDemoOver: state.user.isDemoOver,
      created: state.user.created);
  return new AppState(
      user: newUserData, registrationData: state.registrationData);
}

feedPiggy(AppState state, FeedPiggy action) {
  state.user.currentFeedTime++;

  if (state.user.currentFeedTime >= 5 &&
      state.user.piggyLevel != PiggyLevel.Teen) {
    state.user.piggyLevel =
        PiggyLevel.values[levelMap(state.user.piggyLevel) + 1];
    state.user.currentFeedTime = 0;
  } else {
    state.user.piggyLevel = state.user.piggyLevel;
  }

  if (state.user.currentFeedTime >= 5 &&
      state.user.piggyLevel == PiggyLevel.Teen) {
    state.user.isDemoOver = true;
  }

  state.user.saving = state.user.saving + state.user.feedPerPeriod;
  state.user.money = state.user.money - state.user.feedPerPeriod;
  state.user.lastFeed = DateTime.now();

  var index = state.user.piggies.indexWhere((p) => p.id == action.piggyId);
  var piggy = state.user.piggies[index];

  state.user.piggies[index] = Piggy(
      currentSaving: (piggy.currentSaving + state.user.feedPerPeriod),
      item: piggy.item,
      isAproved: piggy.isAproved,
      piggyLevel: state.user.piggyLevel,
      currentFeedAmount: state.user.feedPerPeriod,
      doubleUp: piggy.doubleUp,
      money: piggy.money,
      userId: piggy.userId,
      isFeedAvailable: true,
      id: piggy.id,
      targetPrice: piggy.targetPrice);

  return new AppState.fromAppState(state);
}
