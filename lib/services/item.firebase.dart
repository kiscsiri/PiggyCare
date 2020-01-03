import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piggybanx/firebase/firebase.implementations.dart/implementations.export.dart';
import 'package:piggybanx/firebase/locator.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';

class ItemFirebaseServices extends ChangeNotifier {
  ItemsApi _api = locator<ItemsApi>();

  List<Piggy> chores;

  Future<List<Piggy>> fetchChores() async {
    var result = await _api.getDataCollection();
    chores = result.documents.map((doc) => Piggy.fromJson(doc.data)).toList();
    return chores;
  }

  Stream<QuerySnapshot> fetchChoresAsStream() {
    return _api.streamDataCollection();
  }

  Future<Piggy> getChoreById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Piggy.fromJson(doc.data);
  }

  Future removeChore(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateChore(Piggy data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future updateChoreProperty(String property, dynamic value, String id) async {
    await _api.updateDocumentProperty(property, value, id);
    return;
  }

  Future addChore(Piggy data) async {
    await _api.addDocument(data.toJson());
    return;
  }
}
