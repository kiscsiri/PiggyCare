import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/models/item/item.model.dart';
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

class AddNewItem {
  final Item item;

  AddNewItem(this.item);
}

class InitUserData {
  final UserData user;

  InitUserData(this.user);
}
