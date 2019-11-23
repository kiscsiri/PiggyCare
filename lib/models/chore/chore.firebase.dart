import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piggybanx/firebase/firebase.api.dart';
import 'package:piggybanx/firebase/locator.dart';

import 'chore.model.dart';

class ChoreFirebaseServices extends ChangeNotifier {
  Api _api = locator<Api>();

  List<Chore> chores;

  Future<List<Chore>> fetchChores() async {
    var result = await _api.getDataCollection();
    chores = result.documents
        .map((doc) => Chore.fromMap(doc.data, doc.documentID))
        .toList();
    return chores;
  }

  Stream<QuerySnapshot> fetchChoresAsStream() {
    return _api.streamDataCollection();
  }

  Future<Chore> getChoreById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Chore.fromMap(doc.data, doc.documentID);
  }

  Future removeChore(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateChore(Chore data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future addChore(Chore data) async {
    var result = await _api.addDocument(data.toJson());

    return;
  }
}
