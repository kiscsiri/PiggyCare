import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item.model.g.dart';

@JsonSerializable(nullable: false)
class Item {
  String item;
  int targetPrice;
  int currentSaving;
  String id;
  String userId;

  Item({this.item, this.targetPrice, this.currentSaving, this.userId, this.id});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);

  factory Item.fromSnapshot(DocumentSnapshot snapshot) {
    return Item(
        currentSaving: snapshot['currentSaving'],
        item: snapshot['item'],
        id: snapshot['id'],
        userId: snapshot['userId'],
        targetPrice: snapshot['targetPrice']);
  }

  Item.fromItem(Item another) {
    item = another.item;
    targetPrice = another.targetPrice;
    currentSaving = another.currentSaving;
    id = another.id;
    userId = another.userId;
  }

  List<Item> fromDocumentSnapshot(List<DocumentSnapshot> snapshots) {
    var result = List<Item>();
    for (final item in snapshots) {
      result.add(Item(
          currentSaving: item["currentSaving"],
          userId: item["userId"],
          id: item["id"],
          item: item["item"],
          targetPrice: item["targetPrice"]));
    }
    return result;
  }
}
