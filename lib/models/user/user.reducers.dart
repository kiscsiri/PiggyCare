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
      wantToSeeInfoAgain: action.user.wantToSeeInfoAgain,
      email: action.user.email,
      name: action.user.name,
      pictureUrl: action.user.pictureUrl,
      currentFeedTime: action.user.currentFeedTime,
      piggyLevel: action.user.piggyLevel,
      period: action.user.period,
      isDemoOver: action.user.isDemoOver,
      parentId: action.user.parentId,
      phoneNumber: action.user.phoneNumber,
      saving: action.user.saving,
      chores: action.user.chores,
      documentId: action.user.documentId,
      children: action.user.children,
      created: action.user.created);

  return AppState(user: newUserData, registrationData: state.registrationData);
}

AppState updateUser(AppState state, UpdateUserData action) {
  state.user.feedPerPeriod = action.user.feedPerPeriod;
  return AppState.fromAppState(state);
}

AppState feedPiggy(AppState state, FeedPiggy action) {
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

  var index = state.user.piggies.indexWhere((p) => p.id == action.piggyId);
  var piggy = state.user.piggies[index];

  state.user.saving = state.user.saving + state.user.feedPerPeriod;

  state.user.money = state.user.money - state.user.feedPerPeriod;
  state.user.lastFeed = DateTime.now();

  state.user.piggies[index] = Piggy(
      currentSaving: (piggy.currentSaving + state.user.feedPerPeriod),
      item: piggy.item,
      isApproved: piggy.isApproved,
      piggyLevel: state.user.piggyLevel,
      doubleUp: piggy.doubleUp,
      money: piggy.money,
      userId: piggy.userId,
      isFeedAvailable: true,
      id: piggy.id,
      targetPrice: piggy.targetPrice);

  return new AppState.fromAppState(state);
}

AppState setChildSavingPerFeed(AppState state, SetChildSavingPerFeed action) {
  var user = state.user;
  var child = user.children
      .singleWhere((d) => d.documentId == action.childId, orElse: null);

  if (child == null) throw Exception("Gyerek nem található");

  child.feedPerPeriod = action.savingPerFeed;

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState setWantToSeeDoubleInfo(AppState state, SetSeenDoubleInfo action) {
  var user = state.user;

  user.wantToSeeInfoAgain = action.wantToSeeDoubleInfo;

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState incrementCoins(AppState state, IncrementCoins action) {
  var user = state.user;

  user.numberOfCoins = user.numberOfCoins != null ? ++user.numberOfCoins : 1;

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState addChildToUser(AppState state, AddFamily action) {
  if (state.user.userType == UserType.business) {
    if (!state.user.children.any((element) => element.id == action.user.id))
      state.user.children.add(action.user);
  } else if (state.user.userType == UserType.donator) {
    state.user.parentId = action.user.id;
  }

  var newState = state.user;
  return new AppState(user: newState);
}

AppState validatePiggy(AppState state, ValidatePiggy action) {
  if (state.user.userType == UserType.business) {
    var child = state.user.children
        .singleWhere((element) => element.id == action.childId, orElse: null);
    if (child == null) throw Exception("Nem található gyerek");

    var piggy = child.piggies
        .where((element) => !element.isApproved)
        .singleWhere((element) => element.id == action.piggyId, orElse: null);

    if (piggy == null) throw Exception("Nem található persely");
    piggy.isApproved = true;
  } else if (state.user.userType == UserType.donator) {
    var piggy = state.user.piggies
        .singleWhere((element) => element.id == action.piggyId);
    piggy.isApproved = true;
  }

  var newState = state.user;
  return new AppState(user: newState);
}
