import 'package:piggycare/models/chore/choreType.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chore.model.g.dart';

@JsonSerializable(nullable: false)
class Chore {
  int id;
  String childId;
  ChoreType choreType;
  String title;
  String details;
  String reward;
  bool isDone;
  bool isValidated;
  DateTime finishedDate;

  Chore(
      {this.choreType,
      this.details,
      this.isDone,
      this.reward,
      this.title,
      this.isValidated,
      this.childId,
      this.finishedDate,
      this.id});

  factory Chore.fromMap(Map snapshot) => _$ChoreFromJson(snapshot);

  Map<String, dynamic> toJson() => _$ChoreToJson(this);

  Chore.fromChore(Chore another) {
    childId = another.childId;
    choreType = another.choreType;
    details = another.details;
    isDone = another.isDone;
    isValidated = another.isValidated;
    reward = another.reward;
    title = another.title;
    finishedDate = another.finishedDate;
    id = another.id;
  }
}
