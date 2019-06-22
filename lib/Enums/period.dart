import 'package:piggybanx/localization/Localizations.dart';

enum Period { demo, daily, weely, monthly }

getStringValue(Period period, context) {
  var loc = PiggyLocalizations.of(context);
  switch (period) {
    case Period.daily:
      return loc.trans("daily");
    case Period.monthly:
      return loc.trans("monthly");
    case Period.weely:
      return loc.trans("weekly");
    default:
      return "";
  }
}

getStringValueRegister(Period period, context) {
  var loc = PiggyLocalizations.of(context);
  switch (period) {
    case Period.daily:
      return loc.trans("register_daily");
    case Period.monthly:
      return loc.trans("register_monthly");
    case Period.weely:
      return loc.trans("register_weekly");
    default:
      return "";
  }
}
