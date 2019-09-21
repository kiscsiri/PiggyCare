import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/SavingSchedule.dart';

class RegistrationData {
  String phoneNumber;
  String item;
  UserType userType;
  int targetPrice;
  Schedule schedule;

  RegistrationData(
      {this.item,
      this.phoneNumber,
      this.targetPrice,
      this.schedule,
      this.userType});
}
