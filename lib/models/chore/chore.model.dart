import 'package:piggybanx/models/chore/choreType.enum.dart';

class Chore {
  String id;
  String childId;
  ChoreType choreType;
  String title;
  String details;
  String reward;
  bool isDone;

  Chore({this.choreType, this.details, this.isDone, this.reward, this.title});

  Chore.fromMap(Map snapshot, String id)
      : choreType = snapshot['choreType'],
        details = snapshot['details'],
        id = snapshot['id'],
        isDone = snapshot['isDone'],
        reward = snapshot['reward'],
        childId = snapshot['childId'],
        title = snapshot['title'];

  toJson() {
    return {
      'choreType': choreType,
      'title': title,
      'details': details,
      'isDone': isDone,
      'id': id,
      'reward': reward,
      'childId': childId,
    };
  }
}
