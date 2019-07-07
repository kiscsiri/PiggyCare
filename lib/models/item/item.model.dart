import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String item;
  int targetPrice;
  int currentSaving;

  Item({this.item, this.targetPrice, this.currentSaving});

  factory Item.fromSnapshot(DocumentSnapshot snapshot) {
    return Item(
        currentSaving: snapshot['currentSaving'],
        item: snapshot['item'],
        targetPrice: snapshot['targetPrice']);
  }

  Map<String, dynamic> toJson(String uid) {
    return new Map.from({
      "currentSaving": this.currentSaving,
      "item": this.item,
      "targetPrice": this.targetPrice,
      "userId": uid,
      "createdDate": DateTime.now()
    });
  }
}

List<Item> fromDocumentSnapshot(List<DocumentSnapshot> snapshots) {
  var result = List<Item>();
  for (final item in snapshots) {
    result.add(Item(
        currentSaving: item["currentSaving"],
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
        item: item["item"],
        targetPrice: item["targetPrice"]));
  }
  return result;
}
