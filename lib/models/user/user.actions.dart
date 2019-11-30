import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/models/item/item.model.dart';
import 'package:piggybanx/models/user/user.model.dart';

class UserAction {}

class SaveSettingsAction extends UserAction {
  final double savingPerPeriod;
  final Period period;

  SaveSettingsAction({this.savingPerPeriod, this.period});
}

class FeedPiggy extends UserAction {
  final String id;

  FeedPiggy(this.id);
}

class UpdateUserData extends UserAction {
  final UserData user;

  UpdateUserData(this.user);
}

class AddNewItem extends UserAction {
  final Item item;

  AddNewItem(this.item);
}

class InitUserData extends UserAction {
  final UserData user;

  InitUserData(this.user);
}

class AddChild extends UserAction {
  final String id;

  AddChild(this.id);
}
