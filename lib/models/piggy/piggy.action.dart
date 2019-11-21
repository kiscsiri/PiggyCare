import 'piggy.model.dart';

class ChildPiggyAction {}

class AddNewPiggy extends ChildPiggyAction {
  final Piggy piggy;

  AddNewPiggy(this.piggy);
}

class RemovePiggy extends ChildPiggyAction {
  final String id;

  RemovePiggy(this.id);
}

class ChildFeedPiggy extends ChildPiggyAction {
  final String id;
  final int amount;

  ChildFeedPiggy(this.id, this.amount);
}

class DoublePiggyFeed extends ChildPiggyAction {
  final String id;

  DoublePiggyFeed(this.id);
}
