import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggycare/Enums/userType.dart';
import 'package:piggycare/models/user/user.export.dart';

class UserServices {
  static Future<List<UserData>> getBusinesses(
      String searchString, UserType userType) async {
    var searchTypeParam = UserType.business;

    var searchByName = await Firestore.instance
        .collection('users')
        .where("userType", isEqualTo: userTypeDecode(searchTypeParam))
        .where("name", isEqualTo: searchString.trim().toLowerCase())
        .getDocuments();

    var searchByEmail = await Firestore.instance
        .collection('users')
        .where("userType", isEqualTo: userTypeDecode(searchTypeParam))
        .where("email", isEqualTo: searchString.trim().toLowerCase())
        .getDocuments();

    var result = List<DocumentSnapshot>();
    if (searchByName != null) {
      result.addAll(searchByName?.documents ?? List<DocumentSnapshot>());
    }

    if (searchByEmail != null) {
      result.addAll(searchByEmail?.documents ?? List<DocumentSnapshot>());
    }

    return result
        .map((u) => UserData.fromFirebaseDocumentSnapshot(u.data, u.documentID))
        .toList();
  }

  static Future<UserData> getUserById(String id) async {
    var value;
    try {
      var res = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: id)
          .getDocuments();

      if (res.documents.length != 0) {
        value = res.documents.first;
        return UserData.fromFirebaseDocumentSnapshot(
            value.data, value.documentID);
      } else {
        value = await Firestore.instance.collection('users').document(id).get();

        if (value.data != null) {
          return UserData.fromFirebaseDocumentSnapshot(
              value.data, value.documentID);
        } else {
          throw Exception("Felhasználó nem található!");
        }
      }
    } catch (err) {
      throw err;
    }
  }
}
