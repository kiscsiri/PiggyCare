import 'package:piggycare/enums/period.dart';
import 'package:piggycare/models/SavingSchedule.dart';
import 'dart:core';

class ScheduleGenerator {
  List<Schedule> generateSchedules(int price) {
    var schedules = new List<Schedule>();
    var schedule1;
    var schedule2;
    var schedule3;
    var schedule4;

    if (price > 700) {
      schedule1 = new Schedule(
          savingPerPeriod: 8,
          period: Period.daily,
          daysUntilDone: (price / 8).ceil());
      schedule2 = new Schedule(
          savingPerPeriod: 5,
          period: Period.daily,
          daysUntilDone: (price / 5).ceil());
      schedule3 = new Schedule(
          savingPerPeriod: 5,
          period: Period.weely,
          daysUntilDone: (price / 5).ceil() * 7);
      schedule4 = new Schedule(
          savingPerPeriod: 10,
          period: Period.weely,
          daysUntilDone: (price / 10).ceil() * 7);
    } else if (price > 300 && price < 700) {
      schedule1 = new Schedule(
          savingPerPeriod: 8,
          period: Period.daily,
          daysUntilDone: (price / 8).ceil());
      schedule2 = new Schedule(
          savingPerPeriod: 3,
          period: Period.daily,
          daysUntilDone: (price / 3).ceil());
      schedule3 = new Schedule(
          savingPerPeriod: 3,
          period: Period.weely,
          daysUntilDone: (price / 3).ceil() * 3);
      schedule4 = new Schedule(
          savingPerPeriod: 7,
          period: Period.weely,
          daysUntilDone: (price / 7).ceil() * 7);
    } else {
      schedule1 = new Schedule(
          savingPerPeriod: 7,
          period: Period.daily,
          daysUntilDone: (price / 7).ceil());
      schedule2 = new Schedule(
          savingPerPeriod: 2,
          period: Period.daily,
          daysUntilDone: (price / 2).ceil());
      schedule3 = new Schedule(
          savingPerPeriod: 5,
          period: Period.weely,
          daysUntilDone: (price / 5).ceil() * 7);
      schedule4 = new Schedule(
          savingPerPeriod: 10,
          period: Period.monthly,
          daysUntilDone: (price / 10).ceil() * 30);
    }

    List<Schedule> calculated = [schedule1, schedule2, schedule3, schedule4];
    schedules.addAll(calculated);
    return schedules;
  }
}
