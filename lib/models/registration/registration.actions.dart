import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/SavingSchedule.dart';
import 'package:piggybanx/models/item/item.model.dart';

class SetPrice {
  final int price;

  SetPrice(this.price);
}

class SetPhoneNumber {
  final String phoneNumber;

  SetPhoneNumber(this.phoneNumber);
}

class SetItem {
  final String item;

  SetItem(this.item);
}

class SetUserType {
  final UserType userType;

  SetUserType(this.userType);
}

class AddItem {
  final Item item;

  AddItem(this.item);
}

class SetSchedule {
  final Schedule schedule;

  SetSchedule(this.schedule);
}

class ClearRegisterState {}

class InitRegistration {
  final String item;
  final UserType userType;
  final String phoneNumber;
  final String price;
  final Schedule schedule;

  InitRegistration(
      this.item, this.phoneNumber, this.price, this.schedule, this.userType);
}
