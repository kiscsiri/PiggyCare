import 'package:piggycare/enums/period.dart';

class Schedule {
  Period period;
  int savingPerPeriod;
  int daysUntilDone;

  Schedule({this.period, this.savingPerPeriod, this.daysUntilDone});
}
