import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:piggycare/firebase/firebase.implementations.dart/implementations.export.dart';
import 'package:piggycare/firebase/locator.dart';
import 'package:piggycare/models/piggy/piggy.export.dart';

class PiggyFirebaseServices extends ChangeNotifier {
  PiggiesApi _api = locator<PiggiesApi>();

  List<Piggy> chores;

  Future<List<Piggy>> fetchPiggies() async {
    var result = await _api.getDataCollection();
    chores = result.documents.map((doc) => Piggy.fromJson(doc.data)).toList();
    return chores;
  }

  Stream<QuerySnapshot> fetchPiggiesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Piggy> getPiggyById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Piggy.fromJson(doc.data);
  }

  Future removePiggy(int id) async {
    await _api.removeDocument(id.toString());
    return;
  }

  Future updatePiggy(Piggy data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future updatePiggyProperty(String property, dynamic value, int id) async {
    await _api.updateDocumentProperty(property, value, id.toString());
    return;
  }

  Future addPiggy(Piggy data) async {
    await _api.addDocument(data.toJson());
    return;
  }
}
