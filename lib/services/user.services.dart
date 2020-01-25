import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/models/userRequest/user.request.dart';

class UserServices {
  static Future<List<UserData>> getUsers(
      String searchString, UserType userType) async {
    var searchTypeParam =
        userType == UserType.adult ? UserType.child : UserType.adult;

    var searchByName = await Firestore.instance
        .collection('users')
        .where("userType", isEqualTo: userTypeDecode(searchTypeParam))
        .where("name", isEqualTo: searchString)
        .getDocuments();

    var searchByEmail = await Firestore.instance
        .collection('users')
        .where("userType", isEqualTo: userTypeDecode(searchTypeParam))
        .where("email", isEqualTo: searchString)
        .getDocuments();

    var result = List<DocumentSnapshot>();
    if (searchByName != null) {
      result.addAll(searchByName?.documents ?? List<DocumentSnapshot>());
    }

    if (searchByEmail != null) {
      result.addAll(searchByEmail?.documents ?? List<DocumentSnapshot>());
    }

    return result
        .map((u) => UserData.fromFirebaseDocumentSnapshot(u.data))
        .toList();
  }

  static Future<List<UserData>> getFriendRequests(String userId) async {
    var requests = await Firestore.instance
        .collection('users')
        .where("toId", isEqualTo: userId)
        .where("isPending", isEqualTo: true)
        .getDocuments();

    var result = List<DocumentSnapshot>();
    if (requests != null) {
      result.addAll(requests?.documents ?? List<DocumentSnapshot>());
    }

    return result
        .map((u) => UserData.fromFirebaseDocumentSnapshot(u.data))
        .toList();
  }

  static Future<void> sendRequest(String fromId, String toId) async {
    UserRequest request =
        UserRequest(fromId: fromId, isPending: true, toId: toId);

    await Firestore.instance
        .collection('userRequests')
        .add(request.userRequestToJson());

    //TODO - send notification
  }
}
