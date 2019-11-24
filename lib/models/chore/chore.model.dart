import 'package:piggybanx/models/chore/choreType.enum.dart';

class Chore {
  String id;
  String childId;
  ChoreType choreType;
  String title;
  String details;
  String reward;
  bool isDone;
  bool isValidated;

  Chore(
      {this.choreType,
      this.details,
      this.isDone,
      this.reward,
      this.title,
      this.isValidated,
      this.childId,
      this.id});

  Chore.fromMap(Map snapshot, String id)
      : choreType = snapshot['choreType'],
        details = snapshot['details'],
        id = snapshot['id'],
        isDone = snapshot['isDone'],
        isValidated = snapshot['isValidated'],
        reward = snapshot['reward'],
        childId = snapshot['childId'],
        title = snapshot['title'];

  Chore.fromChore(Chore another) {
    childId = another.childId;
    choreType = another.choreType;
    details = another.details;
    isDone = another.isDone;
    isValidated = another.isValidated;
    reward = another.reward;
    title = another.title;
    id = another.id;
  }

  toJson() {
    return {
      'choreType': choreType,
      'title': title,
      'details': details,
      'isDone': isDone,
      'isValidated': isValidated,
      'id': id,
      'reward': reward,
      'childId': childId,
    };
  }
}
