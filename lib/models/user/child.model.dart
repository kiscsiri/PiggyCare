import 'package:piggycare/models/chore/chore.model.dart';

import 'user.model.dart';

class Child extends UserData {
  String parentId;
  List<Chore> chores;

  Child.fromChild(Child another) {
    feedPerPeriod = another.feedPerPeriod;
    id = another.id;
    lastFeed = another.lastFeed;
    piggies = another.piggies;
    money = another.money;
    currentFeedTime = another.currentFeedTime;
    piggyLevel = another.piggyLevel;
    period = another.period;
    phoneNumber = another.phoneNumber;
    saving = another.saving;
    isDemoOver = another.isDemoOver;
    created = another.created;
    chores = another.chores;
    parentId = another.parentId;
  }
}
