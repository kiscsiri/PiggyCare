import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/user/user.export.dart';

class PiggyServices {
  static Future<void> createPiggyForUser(Piggy piggy, String userId) async {
    var value = await Firestore.instance
        .collection("users")
        .where("id", isEqualTo: userId)
        .getDocuments();
    var doc = value.documents.first;

    var user = UserData.fromFirebaseDocumentSnapshot(doc.data, doc.documentID);
    piggy.id = user.piggies.length + 1;
    user.piggies.add(piggy);

    Firestore.instance
        .collection('users')
        .document(doc.documentID)
        .updateData(user.toJson());
  }
}
