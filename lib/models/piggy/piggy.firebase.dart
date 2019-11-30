import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piggybanx/firebase/firebase.api.dart';
import 'package:piggybanx/firebase/locator.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';

class PiggyFirebaseServices extends ChangeNotifier {
  Api _api = locator<Api>();

  List<Piggy> chores;

  Future<List<Piggy>> fetchPiggies() async {
    var result = await _api.getDataCollection();
    chores = result.documents
        .map((doc) => Piggy.fromMap(doc.data, doc.documentID))
        .toList();
    return chores;
  }

  Stream<QuerySnapshot> fetchPiggiesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Piggy> getPiggyById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Piggy.fromMap(doc.data, doc.documentID);
  }

  Future removePiggy(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updatePiggy(Piggy data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future updatePiggyProperty(String property, dynamic value, String id) async {
    await _api.updateDocumentProperty(property, value, id);
    return;
  }

  Future addPiggy(Piggy data) async {
    await _api.addDocument(data.toJson());
    return;
  }
}
