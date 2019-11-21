import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/SavingSchedule.dart';
import 'package:piggybanx/models/item/item.model.dart';

class RegistrationAction {}

class SetPrice extends RegistrationAction {
  final int price;

  SetPrice(this.price);
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

class InitRegistration extends RegistrationAction {
  final String item;
  final UserType userType;
  final String phoneNumber;
  final String price;
  final Schedule schedule;

  InitRegistration(
      this.item, this.phoneNumber, this.price, this.schedule, this.userType);
}
