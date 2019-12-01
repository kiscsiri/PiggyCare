import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piggybanx/firebase/firebase.implementations.dart/implementations.export.dart';
import 'package:piggybanx/firebase/locator.dart';
import 'package:piggybanx/models/item/item.model.dart';

class ItemFirebaseServices extends ChangeNotifier {
  ItemsApi _api = locator<ItemsApi>();

  List<Item> chores;

  Future<List<Item>> fetchChores() async {
    var result = await _api.getDataCollection();
    chores = result.documents.map((doc) => Item.fromSnapshot(doc)).toList();
    return chores;
  }

  Stream<QuerySnapshot> fetchChoresAsStream() {
    return _api.streamDataCollection();
  }

  Future<Item> getChoreById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Item.fromMap(doc.data, doc.documentID);
  }

  Future removeChore(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateChore(Item data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future updateChoreProperty(String property, dynamic value, String id) async {
    await _api.updateDocumentProperty(property, value, id);
    return;
  }

  Future addChore(Item data) async {
    await _api.addDocument(data.toJson());
    return;
  }
}
