import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/models/SavingSchedule.dart';
import 'package:piggycare/models/piggy/piggy.export.dart';

class RegistrationAction {}

class SetPrice extends RegistrationAction {
  final int price;

  SetPrice(this.price);
}

class AddPiggy extends RegistrationAction {
  final Piggy piggy;

  AddPiggy(this.piggy);
}

class SetFromOauth extends RegistrationAction {
  final String email;
  final String username;
  final String uid;
  final String pictureUrl;

  SetFromOauth(this.email, this.username, this.uid, this.pictureUrl);
}

class SetPhoneNumber extends RegistrationAction {
  final String phoneNumber;

  SetPhoneNumber(this.phoneNumber);
}

class SetItem extends RegistrationAction {
  final String item;

  SetItem(this.item);
}

class SetUserType extends RegistrationAction {
  final UserType userType;

  SetUserType(this.userType);
}

class SetSchedule extends RegistrationAction {
  final Schedule schedule;

  SetSchedule(this.schedule);
}

class ClearRegisterState extends RegistrationAction {}

class InitRegistration extends RegistrationAction {}
