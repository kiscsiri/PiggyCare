import 'package:piggybanx/Enums/level.dart';
import 'package:piggybanx/Enums/userType.dart';
import 'package:piggybanx/helpers/constants.dart';
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
      wantToSeeInfoAgain: action.user.wantToSeeInfoAgain,
      email: action.user.email,
      name: action.user.name,
      pictureUrl: action.user.pictureUrl,
      numberOfCoins: action.user.numberOfCoins,
      period: action.user.period,
      isAutoPostEnabled: action.user.isAutoPostEnabled,
      isPublicProfile: action.user.isPublicProfile,
      isDemoOver: action.user.isDemoOver,
      initAutoShareSeen: action.user.initAutoShareSeen,
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
  var index = state.user.piggies.indexWhere((p) => p.id == action.piggyId);
  var piggy = state.user.piggies[index];
  piggy.currentFeedTime++;
  if (piggy.currentFeedTime >= piggyLevelUpConstraint &&
      piggy.piggyLevel.index < maxPiggyLevel.index) {
    piggy.piggyLevel = PiggyLevel.values[levelMap(piggy.piggyLevel) + 1];
    piggy.currentFeedTime = 0;
  } else {
    piggy.piggyLevel = piggy.piggyLevel;
  }

  if (piggy.currentFeedTime >= piggyLevelUpConstraint &&
      piggy.piggyLevel == maxPiggyLevel) {
    if (piggy.piggyLevel == PiggyLevel.Adult &&
        piggy.currentFeedTime >= piggyLevelUpConstraint - 1) {
      piggy.currentFeedTime = 0;
      piggy.piggyLevel = PiggyLevel.values[0];
    }
    state.user.isDemoOver = true;
    piggy.currentFeedTime = 0;
  }

  state.user.saving = state.user.saving + state.user.feedPerPeriod;

  state.user.money = state.user.money - state.user.feedPerPeriod;
  state.user.lastFeed = DateTime.now();
  state.user.numberOfCoins -= 1;
  state.user.piggies[index] = Piggy(
      currentSaving: (piggy.currentSaving + state.user.feedPerPeriod),
      item: piggy.item,
      isApproved: piggy.isApproved,
      piggyLevel: piggy.piggyLevel,
      doubleUp: piggy.doubleUp,
      currentFeedTime: piggy.currentFeedTime,
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

AppState setinitAutoShareSet(AppState state, InitAutoShareSet action) {
  var user = state.user;

  user.initAutoShareSeen = true;
  user.isAutoPostEnabled = action.wantToSharePosts;

  var newUserData = user;
  return new AppState(user: newUserData);
}

AppState updateUserProfile(AppState state, UpdateUserProfile action) {
  var user = state.user;

  user.isAutoPostEnabled = action.user.isAutoPostEnabled;
  user.isPublicProfile = action.user.isPublicProfile;
  user.name = action.user.name;
  user.email = action.user.email;

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
  if (state.user.userType == UserType.adult) {
    if (!state.user.children.any((element) => element.id == action.user.id))
      state.user.children.add(action.user);
  } else if (state.user.userType == UserType.child) {
    state.user.parentId = action.user.id;
  }

  var newState = state.user;
  return new AppState(user: newState);
}

AppState validatePiggy(AppState state, ValidatePiggy action) {
  if (state.user.userType == UserType.adult) {
    var child = state.user.children
        .singleWhere((element) => element.id == action.childId, orElse: null);
    if (child == null) throw Exception("Nem található gyerek");

    var piggy = child.piggies
        .where((element) => !(element.isApproved ?? false))
        .firstWhere((element) => element.id == action.piggy.id,
            orElse: () => null);

    if (piggy == null) {
      child.piggies.add(action.piggy);
    } else {
      piggy.isApproved = true;
    }
  } else if (state.user.userType == UserType.child) {
    var piggy = state.user.piggies
        .firstWhere((element) => element.id == action.piggy.id, orElse: null);
    piggy.isApproved = true;
  }

  var newState = state.user;
  return new AppState(user: newState);
}
