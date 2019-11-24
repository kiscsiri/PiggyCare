import 'piggy.model.dart';

class ChildPiggyAction {}

class AddNewPiggy extends ChildPiggyAction {
  final Piggy piggy;

  AddNewPiggy(this.piggy);
}

class RemovePiggy extends ChildPiggyAction {
  final String piggyId;

  RemovePiggy(this.piggyId);
}

class GrowPiggy extends ChildPiggyAction {
  final String piggyId;

  GrowPiggy(this.piggyId);
}

class FeedChildPiggy extends ChildPiggyAction {
  final String piggyId;
  final int amount;
  final bool isDouble;

  FeedChildPiggy(this.piggyId, this.amount, this.isDouble);
}
