import 'package:piggybanx/models/SavingSchedule.dart';

class RegistrationData {
  String phoneNumber;
  String item;
  int targetPrice;
  Schedule schedule;

  RegistrationData({
    this.item,
    this.phoneNumber,
    this.targetPrice,
    this.schedule
  });
}