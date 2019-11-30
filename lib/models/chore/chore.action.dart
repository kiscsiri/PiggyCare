import 'chore.model.dart';

class ChoreAction {}

class AddChore extends ChoreAction {
  final Chore chore;

  AddChore(this.chore);
}

class LoadChores extends ChoreAction {
  final List<Chore> chores;

  LoadChores(this.chores);
}

class RemoveChore extends ChoreAction {
  final String choreId;
  final String childId;

  RemoveChore(this.childId, this.choreId);
}

class FinishChore extends ChoreAction {
  final String choreId;
  final String childId;

  FinishChore(this.childId, this.choreId);
}

class AcceptChore extends ChoreAction {
  final String choreId;
  final String childId;

  AcceptChore(this.childId, this.choreId);
}
