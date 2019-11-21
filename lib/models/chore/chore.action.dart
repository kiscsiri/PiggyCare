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
  final String id;

  RemoveChore(this.id);
}

class FinishChore extends ChoreAction {
  final String id;

  FinishChore(this.id);
}

class AcceptChore extends ChoreAction {
  final String id;

  AcceptChore(this.id);
}
