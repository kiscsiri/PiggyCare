import 'package:piggycare/Enums/userType.dart';
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

class SetFromRegistrationForm extends RegistrationAction {
  final String email;
  final String taxNumber;
  final String businessNumber;
  final String operationLocation;
  final String name;
  final String uid;
  final String pictureUrl;

  SetFromRegistrationForm(this.email, this.name, this.uid, this.pictureUrl,
      this.taxNumber, this.businessNumber, this.operationLocation);
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
