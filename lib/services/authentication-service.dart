import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/models/registration/registration.export.dart';
import 'package:piggycare/models/user/user.export.dart';
import 'package:piggycare/screens/startup.screen.dart';
import 'package:redux/redux.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/widgets/piggy.button.dart';

import 'notification.services.dart';

class AuthenticationService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    var loc = PiggyLocalizations.of(context);
    QuerySnapshot value = await Firestore.instance
        .collection('donators')
        .where("phoneNumber", isEqualTo: phoneNumber)
        .getDocuments();
    if (value.documents.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(loc.trans("no_account")),
                actions: <Widget>[
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.72,
                      child: PiggyButton(
                        text: "OK",
                        onClick: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
                content: Text(loc.trans("please_register")),
              ));
      return false;
    } else {
      return true;
    }
  }

  static Future<void> _loginUser(
      FirebaseUser user, Store<AppState> store) async {
    if (user != null) {
      var value = await Firestore.instance
          .collection('donators')
          .where("id", isEqualTo: user.uid)
          .getDocuments();
      if (value.documents.length > 0) {
        UserData u = new UserData.fromFirebaseDocumentSnapshot(
            value.documents.first.data, value.documents.first.documentID);
        user.reload();

        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        var val = await _firebaseMessaging.getToken();
        NotificationServices.updateToken(
            val, user.uid, Platform.isAndroid ? "android" : "ios");

        if (u.userType == UserType.business) {
          var children = await Firestore.instance
              .collection('donators')
              .where("parentId", isEqualTo: user.uid)
              .getDocuments();
          for (var childSnapshot in children.documents) {
            // u.children.add(UserData.fromFirebaseDocumentSnapshot(
            //     childSnapshot.data, childSnapshot.documentID));
          }
        }

        store.dispatch(InitUserData(u));
      }
    }
  }

  static Future<void> authenticate(
      FirebaseUser user, Store<AppState> store, BuildContext context) async {
    QuerySnapshot value = await Firestore.instance
        .collection('donators')
        .where("id", isEqualTo: user.uid)
        .getDocuments();
    if (value.documents.length == 0) {
      throw AuthException("", "No users found!");
    } else {
      await _loginUser(user, store);
      Navigator.of(context).pushReplacementNamed("home");
    }
  }

  static Future<void> splashLogin(BuildContext context) async {
    var store = StoreProvider.of<AppState>(context);
    var value = await Connectivity().checkConnectivity();
    if (value == ConnectivityResult.mobile ||
        value == ConnectivityResult.wifi) {
      var _auth = FirebaseAuth.instance;
      var user = await _auth.currentUser();
      if (user != null) {
        await _loginUser(user, store);
        Navigator.of(context).pushReplacementNamed("home");
      }
    } else if (value == ConnectivityResult.none) {
      alert(context);
    }
  }

  static Future<void> registerUser(Store<AppState> store) async {
    var user = store.state.registrationData;

    var value = await Firestore.instance
        .collection("donators")
        .where("id", isEqualTo: user.uid)
        .getDocuments();

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    var registrationData = store.state.registrationData;
    if (value.documents.length == 0) {
      UserData userData = new UserData.constructInitial(registrationData);
      var platfom = "";
      _firebaseMessaging.getToken().then((val) {
        var token = val;
        _firebaseMessaging.onTokenRefresh.listen((token) {
          NotificationServices.updateToken(
              token, user.uid, Platform.isAndroid ? "android" : "ios");
        });

        if (Platform.isAndroid) {
          platfom = "android";
        } else if (Platform.isIOS) {
          platfom = "ios";
        }
        NotificationServices.register(token, userData.documentId, platfom);
      });

      var userRef = await Firestore.instance
          .collection('donators')
          .add(userData.toJson());

      userData.documentId = userRef.documentID;

      await Firestore.instance
          .collection('donators')
          .document(userData.documentId)
          .updateData(userData.toJson());

      store.dispatch(ClearRegisterState());
      store.dispatch(InitUserData(userData));
    } else {
      var data = value.documents[0];
      UserData userData =
          new UserData.fromFirebaseDocumentSnapshot(data.data, data.documentID);
      store.dispatch(InitUserData(userData));
    }
  }

  static Future<FirebaseUser> signInWithGoogle(Store<AppState> store) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    try {
      return user;
    } catch (err) {
      throw Exception();
    }
  }
}
