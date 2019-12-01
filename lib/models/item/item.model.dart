import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String item;
  int targetPrice;
  int currentSaving;
  String id;
  String userId;

  Item({this.item, this.targetPrice, this.currentSaving, this.userId, this.id});

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

  Item.fromMap(Map snapshot, String id)
      : item = snapshot['item'],
        targetPrice = snapshot['targetPrice'],
        id = snapshot['id'],
        userId = snapshot['userId'],
        currentSaving = snapshot['currentSaving'];

  Map<String, dynamic> toJson() {
    return new Map.from({
      "currentSaving": this.currentSaving,
      "item": this.item,
      "targetPrice": this.targetPrice,
      "id": this.id,
      "userId": this.userId,
      "createdDate": DateTime.now()
    });
  }
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

List<Item> toJson(List<DocumentSnapshot> snapshots) {
  var result = List<Item>();
  for (final item in snapshots) {
    result.add(Item(
        currentSaving: item["currentSaving"],
        userId: item["userId"],
        item: item["item"],
        targetPrice: item["targetPrice"]));
  }
  return result;
}
