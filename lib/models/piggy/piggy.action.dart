import 'piggy.model.dart';

class ChildPiggyAction {}

class AddNewPiggy extends ChildPiggyAction {
  final Piggy piggy;

  AddNewPiggy(this.piggy);
}

class RemovePiggy extends ChildPiggyAction {
  final int piggyId;

  RemovePiggy(this.piggyId);
}

class GrowPiggy extends ChildPiggyAction {
  final String piggyId;

  GrowPiggy(this.piggyId);
}

class FeedChildPiggy extends ChildPiggyAction {
  final int piggyId;
  final int amount;
  final bool isDouble;

  FeedChildPiggy(this.piggyId, this.amount, this.isDouble);
}

class CreateTempPiggy extends ChildPiggyAction {
  final Piggy piggy;

  CreateTempPiggy({this.piggy});
}

class ClearTempPiggy extends ChildPiggyAction {
  ClearTempPiggy();
}

class ValidatePiggy extends ChildPiggyAction {
  final int piggyId;
  final bool isValidated;
  final String childId;

  ValidatePiggy({this.piggyId, this.isValidated, this.childId});
}
