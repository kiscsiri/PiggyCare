class Piggy {
  String childId;
  bool isFeedAvailable;
  int currentFeedAmount;
  int money;

  Piggy.fromPiggy(Piggy another) {
    childId = another.childId;
    isFeedAvailable = another.isFeedAvailable;
    currentFeedAmount = another.currentFeedAmount;
    money = another.money;
  }
}
