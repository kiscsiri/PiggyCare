import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/models/user/user.model.dart';

class SaveSettingsAction {
  final double savingPerPeriod;
  final Period period;

  SaveSettingsAction({this.savingPerPeriod, this.period});
}

class FeedPiggy {
  final String id;

  FeedPiggy(this.id);
}

class UpdateUserData {
  final UserData user;

  UpdateUserData(this.user);
}

class InitUserData {
  final UserData user;

  InitUserData(this.user);
}
