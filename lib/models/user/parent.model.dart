import 'package:piggycare/models/user/user.model.dart';

class Parent extends UserData {
  Parent.fromParent(Parent another) {
    feedPerPeriod = another.feedPerPeriod;
    id = another.id;
    lastFeed = another.lastFeed;
    money = another.money;
    currentFeedTime = another.currentFeedTime;
    piggyLevel = another.piggyLevel;
    period = another.period;
    saving = another.saving;
    created = another.created;
    piggies = another.piggies;
  }
}
