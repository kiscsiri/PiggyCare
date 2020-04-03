import 'chore.model.dart';

abstract class ChoreAction {}

class AddChore extends ChoreAction {
  final Chore chore;

  AddChore(this.chore);
}

class AddChoreChild extends ChoreAction {
  final Chore chore;

  AddChoreChild(this.chore);
}

class LoadChores extends ChoreAction {
  final List<Chore> chores;

  LoadChores(this.chores);
}

class RemoveChore extends ChoreAction {
  final int choreId;
  final String childId;

  RemoveChore(this.childId, this.choreId);
}

class FinishChore extends ChoreAction {
  final int choreId;
  final String childId;

  FinishChore(this.childId, this.choreId);
}

class AcceptChore extends ChoreAction {
  final int choreId;
  final String childId;

  AcceptChore(this.childId, this.choreId);
}

class RefuseChore extends ChoreAction {
  final int choreId;
  final String childId;

  RefuseChore(this.childId, this.choreId);
}

class ValidateChoreParent extends ChoreAction {
  final int choreId;
  final String childId;
  final bool isValid;

  ValidateChoreParent(this.childId, this.choreId, this.isValid);
}

class FinishChoreParent extends ChoreAction {
  final int choreId;
  final String childId;

  FinishChoreParent(this.childId, this.choreId);
}
