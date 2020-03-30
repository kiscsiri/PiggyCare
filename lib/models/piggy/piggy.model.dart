import 'package:json_annotation/json_annotation.dart';
import 'package:piggybanx/enums/level.dart';

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
  int targetPrice;
  int currentSaving;

  Piggy.fromPiggy(Piggy another) {
    userId = another.userId;
    isFeedAvailable = another.isFeedAvailable;
    money = another.money;
    isApproved = another.isApproved;
    doubleUp = another.doubleUp;
  }

  factory Piggy.fromJson(Map snapshot) => _$PiggyFromJson(snapshot);

  Map<String, dynamic> toJson() => _$PiggyToJson(this);

  Piggy(
      {this.id = 0,
      this.userId,
      this.doubleUp,
      this.isFeedAvailable,
      this.money,
      this.targetPrice,
      this.currentSaving,
      this.item,
      this.piggyLevel,
      this.isApproved});
}
