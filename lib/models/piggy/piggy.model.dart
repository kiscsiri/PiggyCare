import 'package:json_annotation/json_annotation.dart';

part 'piggy.model.g.dart';

@JsonSerializable(nullable: false)
class Piggy {
  String id;
  String childId;
  bool isFeedAvailable;
  int currentFeedAmount;
  int money;
  bool doubleUp;

  Piggy.fromPiggy(Piggy another) {
    childId = another.childId;
    isFeedAvailable = another.isFeedAvailable;
    currentFeedAmount = another.currentFeedAmount;
    money = another.money;
    doubleUp = another.doubleUp;
  }

  factory Piggy.fromMap(Map snapshot, String id) => _$PiggyFromJson(snapshot);

  Map<String, dynamic> toJson() => _$PiggyToJson(this);

  Piggy(
      {this.id,
      this.childId,
      this.currentFeedAmount,
      this.doubleUp,
      this.isFeedAvailable,
      this.money});
}
