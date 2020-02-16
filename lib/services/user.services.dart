import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/models/userRequest/user.request.dart';
import 'package:piggybanx/services/notification.services.dart';

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
        .map((u) => UserData.fromFirebaseDocumentSnapshot(u.data, u.documentID))
        .toList();
  }

  static Future<List<UserData>> getFriendRequests(String userId) async {
    var requests = await Firestore.instance
        .collection('userRequests')
        .where("toId", isEqualTo: userId)
        .where("isPending", isEqualTo: true)
        .getDocuments();

    var result = requests.documents
        .map((u) => UserRequest().userRequestFromJson(u.data, u.documentID))
        .toList();

    var users = List<DocumentSnapshot>();
    for (final d in result) {
      var user = await Firestore.instance
          .collection('users')
          .where("id", isEqualTo: d.fromId)
          .getDocuments();
      users.add(user.documents.first);
    }
    return users
        .map((u) => UserData.fromFirebaseDocumentSnapshot(u.data, u.documentID))
        .toList();
  }

  static Future<void> sendRequest(String fromId, String toId) async {
    UserRequest request =
        UserRequest(fromId: fromId, isPending: true, toId: toId);

    await Firestore.instance
        .collection('userRequests')
        .add(request.userRequestToJson());

    NotificationServices.newFriendRequest(toId);
  }

  static Future<void> acceptRequest(
      String fromId, String toId, UserType currentUserType) async {
    var result = await Firestore.instance
        .collection('userRequests')
        .where('fromId', isEqualTo: fromId)
        .where('toId', isEqualTo: toId)
        .where('isPending', isEqualTo: true)
        .getDocuments();

    if (result.documents.isEmpty) throw HttpException("Not found");

    await Firestore.instance
        .collection('userRequests')
        .document(result.documents.first.documentID)
        .updateData({'isPending': false});

    var data = await Firestore.instance
        .collection('users')
        .where('id',
            isEqualTo: currentUserType == UserType.adult ? fromId : toId)
        .getDocuments();

    Firestore.instance
        .collection('users')
        .document(data.documents.first.documentID)
        .updateData(
            {'parentId': currentUserType == UserType.adult ? toId : fromId});

    //TODO - send notification
  }

  static Future<void> declineRequest(String fromId, String toId) async {
    var result = await Firestore.instance
        .collection('userRequests')
        .where('fromId', isEqualTo: fromId)
        .where('toId', isEqualTo: toId)
        .where('isPending', isEqualTo: true)
        .getDocuments();

    if (result.documents.isEmpty) throw HttpException("Not found");

    var userReq = UserRequest().userRequestFromJson(
        result.documents.first.data, result.documents.first.documentID);

    await Firestore.instance
        .collection('userRequests')
        .document(userReq.id)
        .delete();
  }

  static Future<UserData> getUserById(String id) async {
    var value = await Firestore.instance.collection('users').document(id).get();
    if (value.data != null) {
      return UserData.fromFirebaseDocumentSnapshot(
          value.data, value.documentID);
    } else {
      throw Exception("User not found!");
    }
  }
}
