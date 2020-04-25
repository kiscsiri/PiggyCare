import 'package:json_annotation/json_annotation.dart';
import 'package:piggybanx/Enums/level.dart';

part 'piggy.model.g.dart';

@JsonSerializable(nullable: false)
class Piggy {
  int id;
  String userId;
  bool isFeedAvailable;
  bool isApproved;
  PiggyLevel piggyLevel;
  int money;
  bool doubleUp;
  String item;
  int currentFeedTime;
  int targetPrice;
  int currentSaving;

  factory Piggy.fromJson(Map snapshot) => _$PiggyFromJson(snapshot);

  Map<String, dynamic> toJson() => _$PiggyToJson(this);

  Piggy(
      {this.id = 0,
      this.userId,
      this.doubleUp,
      this.isFeedAvailable,
      int currentFeedTime,
      this.money,
      this.targetPrice,
      this.currentSaving,
      this.item,
      PiggyLevel piggyLevel,
      this.isApproved})
      : currentFeedTime = currentFeedTime ?? 0,
        piggyLevel = piggyLevel ?? PiggyLevel.Baby;
}
