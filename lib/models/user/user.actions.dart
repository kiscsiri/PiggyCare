import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/models/user/user.model.dart';

class UserAction {}

class SaveSettingsAction extends UserAction {
  final double savingPerPeriod;
  final Period period;

  SaveSettingsAction({this.savingPerPeriod, this.period});
}

class FeedPiggy extends UserAction {
  final String id;
  final int piggyId;

  FeedPiggy(this.id, this.piggyId);
}

class UpdateUserData extends UserAction {
  final UserData user;

  UpdateUserData(this.user);
}

class UpdateUserProfile extends UserAction {
  final UserData user;

  UpdateUserProfile(this.user);
}

class InitUserData extends UserAction {
  final UserData user;

  InitUserData(this.user);
}

class AddFamily extends UserAction {
  final UserData user;

  AddFamily(this.user);
}

class SetChildSavingPerFeed extends UserAction {
  final String childId;
  final int savingPerFeed;

  SetChildSavingPerFeed(this.childId, this.savingPerFeed);
}

class SetSeenDoubleInfo extends UserAction {
  final bool wantToSeeDoubleInfo;

  SetSeenDoubleInfo(this.wantToSeeDoubleInfo);
}

class InitAutoShareSet extends UserAction {
  final bool initAutoShareSet;
  final bool wantToSharePosts;

  InitAutoShareSet(this.initAutoShareSet, this.wantToSharePosts);
}

class IncrementCoins extends UserAction {}
