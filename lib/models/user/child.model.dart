import 'package:piggybanx/models/chore/chore.model.dart';
import 'package:piggybanx/models/piggy/piggy.model.dart';

import 'user.model.dart';

class Child extends UserData {
  String parentId;
  List<Chore> chores;
  List<Piggy> piggies;

  Child.fromChild(Child another) {
    feedPerPeriod = another.feedPerPeriod;
    id = another.id;
    lastFeed = another.lastFeed;
    items = another.items;
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
    piggies = another.piggies;
  }
}
