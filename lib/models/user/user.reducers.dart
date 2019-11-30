import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/models/item/item.model.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.model.dart';

import '../appState.dart';

AppState initUser(AppState state, InitUserData action) {
  var newUserData = new UserData(
      feedPerPeriod: action.user.feedPerPeriod,
      id: action.user.id,
      lastFeed: action.user.lastFeed,
      money: action.user.money,
      items: action.user.items,
      currentFeedTime: action.user.currentFeedTime,
      piggyLevel: action.user.piggyLevel,
      period: action.user.period,
      isDemoOver: action.user.isDemoOver,
      phoneNumber: action.user.phoneNumber,
      saving: action.user.saving,
      created: action.user.created);
  return new AppState(
      user: newUserData, registrationData: state.registrationData);
}

AppState updateUser(AppState state, UpdateUserData action) {
  var newUserData = new UserData(
      feedPerPeriod: action.user.feedPerPeriod,
      id: state.user.id,
      lastFeed: state.user.lastFeed,
      items: state.user.items,
      money: state.user.money,
      currentFeedTime: state.user.currentFeedTime,
      piggyLevel: state.user.piggyLevel,
      period: action.user.period,
      phoneNumber: state.user.phoneNumber,
      saving: state.user.saving,
      isDemoOver: state.user.isDemoOver,
      created: state.user.created);
  return new AppState(
      user: newUserData, registrationData: state.registrationData);
}

AppState addNewITem(AppState state, AddNewItem action) {
  var newUserData = new UserData(
      feedPerPeriod: state.user.feedPerPeriod,
      id: state.user.id,
      lastFeed: state.user.lastFeed,
      items: state.user.items,
      money: state.user.money,
      currentFeedTime: state.user.currentFeedTime,
      piggyLevel: state.user.piggyLevel,
      period: state.user.period,
      phoneNumber: state.user.phoneNumber,
      saving: state.user.saving,
      created: state.user.created);
  return new AppState(
      user: newUserData, registrationData: state.registrationData);
}

feedPiggy(AppState state, FeedPiggy action) {
  var newCurrentFeedTime = state.user.currentFeedTime + 1;
  var newPiggyLevel = PiggyLevel.Baby;
  var newDemo = state.user.isDemoOver;

  if (newCurrentFeedTime >= 5 && state.user.piggyLevel != PiggyLevel.Teen) {
    newPiggyLevel = PiggyLevel.values[levelMap(state.user.piggyLevel) + 1];
    newCurrentFeedTime = 0;
  } else {
    newPiggyLevel = state.user.piggyLevel;
  }

  if (newCurrentFeedTime >= 5 && state.user.piggyLevel == PiggyLevel.Teen) {
    newDemo = true;
  }

  var activeItem = state.user.items.last;

  var newUserData = new UserData(
      id: state.user.id,
      feedPerPeriod: state.user.feedPerPeriod,
      lastFeed: DateTime.now(),
      items: state.user.items,
      money: (state.user.money - state.user.feedPerPeriod),
      piggyLevel: newPiggyLevel,
      isDemoOver: newDemo,
      currentFeedTime: newCurrentFeedTime,
      period: state.user.period,
      created: state.user.created,
      phoneNumber: state.user.phoneNumber,
      saving: (state.user.saving + state.user.feedPerPeriod));

  newUserData.items.last = Item(
      currentSaving: (activeItem.currentSaving + state.user.feedPerPeriod),
      item: activeItem.item,
      targetPrice: activeItem.targetPrice);

  return new AppState(
      user: newUserData, registrationData: state.registrationData);
}
