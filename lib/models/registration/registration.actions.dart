import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/SavingSchedule.dart';
import 'package:piggybanx/models/item/item.model.dart';

class RegistrationAction {}

class SetPrice extends RegistrationAction {
  final int price;

  SetPrice(this.price);
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

class AddItem extends RegistrationAction {
  final Item item;

  AddItem(this.item);
}

class SetSchedule extends RegistrationAction {
  final Schedule schedule;

  SetSchedule(this.schedule);
}

class ClearRegisterState extends RegistrationAction {}

class InitRegistration extends RegistrationAction {}
