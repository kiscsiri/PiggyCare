import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/models/user/user.export.dart';
import 'package:piggycare/models/userRequest/user.request.dart';
import 'package:piggycare/services/notification.services.dart';

class UserServices {
  static Future<List<UserData>> getUsers(
      String searchString, UserType userType) async {
    var searchTypeParam =
        userType == UserType.business ? UserType.donator : UserType.business;

    var searchByName = await Firestore.instance
        .collection('donators')
        .where("userType", isEqualTo: userTypeDecode(searchTypeParam))
        .where("name", isEqualTo: searchString.trim().toLowerCase())
        .getDocuments();

    var searchByEmail = await Firestore.instance
        .collection('donators')
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
          .collection('donators')
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

    var result = await Firestore.instance
        .collection('userRequests')
        .where('fromId', isEqualTo: fromId)
        .where('toId', isEqualTo: toId)
        .getDocuments();

    var sender = await Firestore.instance
        .collection('donators')
        .where('id', isEqualTo: fromId)
        .getDocuments();

    if (result.documents.length == 0) {
      try {
        await Firestore.instance
            .collection('userRequests')
            .add(request.userRequestToJson());
      } catch (err) {
        throw Exception("Hiba történt!");
      }

      if (sender.documents.length != 0) {
        var user = UserData.fromFirebaseDocumentSnapshot(
            sender.documents.first.data, sender.documents.first.documentID);
        NotificationServices.newFriendRequest(toId, user.name);
      }
    } else {
      throw Exception("Már elküldted az ismerős kérelmet az adott embernek!");
    }
  }

  static Future<dynamic> acceptRequest(
      String fromId, String toId, UserType currentUserType) async {
    var result = await Firestore.instance
        .collection('userRequests')
        .where('fromId', isEqualTo: fromId)
        .where('toId', isEqualTo: toId)
        .where('isPending', isEqualTo: true)
        .getDocuments();

    if (result.documents.isEmpty) throw HttpException("Not found");

    try {
      await Firestore.instance
          .collection('userRequests')
          .document(result.documents.first.documentID)
          .updateData({'isPending': false});

      var data = await Firestore.instance
          .collection('donators')
          .where('id',
              isEqualTo: currentUserType == UserType.business ? fromId : toId)
          .getDocuments();

      Firestore.instance
          .collection('donators')
          .document(data.documents.first.documentID)
          .updateData({
        'parentId': currentUserType == UserType.business ? toId : fromId
      });

      return currentUserType == UserType.donator
          ? fromId
          : UserData.fromFirebaseDocumentSnapshot(
              data.documents.first.data, data.documents.first.documentID);
    } catch (err) {
      throw Exception("Hiba történt a felkérés elfogadása során");
    }
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

  static Future setChildSavingPerDay(String childId, int savingPerFeed) async {
    var user = await getUserById(childId);

    user.feedPerPeriod = savingPerFeed;

    await Firestore.instance
        .collection('donators')
        .document(user.documentId)
        .updateData(user.toJson());
  }

  static Future<UserData> getUserById(String id) async {
    var value;
    try {
      var res = await Firestore.instance
          .collection('donators')
          .where('id', isEqualTo: id)
          .getDocuments();

      if (res.documents.length != 0) {
        value = res.documents.first;
        return UserData.fromFirebaseDocumentSnapshot(
            value.data, value.documentID);
      } else {
        value =
            await Firestore.instance.collection('donators').document(id).get();

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

  static Future setDoubleInformationSeen(
      String documentId, bool seenInfo) async {
    var user = await getUserById(documentId);

    user.wantToSeeInfoAgain = seenInfo;

    await Firestore.instance
        .collection('donators')
        .document(documentId)
        .updateData(user.toJson());
  }

  static Future increaseCoinNumberForChild(String childDocumentId) async {
    var user = await getUserById(childDocumentId);

    user.numberOfCoins++;

    Firestore.instance
        .collection('donators')
        .document(childDocumentId)
        .updateData(user.toJson());
  }
}
