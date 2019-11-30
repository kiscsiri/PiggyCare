class Piggy {
  String id;
  String childId;
  bool isFeedAvailable;
  int currentFeedAmount;
  int money;
  bool doubleUp;

  Piggy.fromPiggy(Piggy another) {
    childId = another.childId;
    isFeedAvailable = another.isFeedAvailable;
    currentFeedAmount = another.currentFeedAmount;
    money = another.money;
    doubleUp = another.doubleUp;
  }

  Piggy.fromMap(Map snapshot, String id)
      : childId = snapshot['childId'],
        id = snapshot['id'],
        isFeedAvailable = snapshot['isFeedAvailable'],
        currentFeedAmount = snapshot['currentFeedAmount'],
        money = snapshot['money'],
        doubleUp = snapshot['doubleUp'];

  toJson() {
    return {
      'id': id,
      'isFeedAvailable': isFeedAvailable,
      'childId': childId,
      'currentFeedAmount': currentFeedAmount,
      'isFeedAvailable': isFeedAvailable,
      'money': money,
      'doubleUp': doubleUp,
    };
  }
}
