import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/screens/startup.screen.dart';
import 'package:redux/redux.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/item/item.model.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.model.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/widgets/piggy.button.dart';

import 'notification.services.dart';

class AuthenticationService {
  static Future<bool> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    var loc = PiggyLocalizations.of(context);
    var isExist = await Firestore.instance
        .collection("users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .getDocuments()
        .then((QuerySnapshot value) {
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
    });

    if (!isExist) return false;
  }

  static Future<void> authenticate(
      FirebaseUser user, BuildContext context, Store<AppState> store) async {
    await Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: user.uid)
        .getDocuments()
        .then((QuerySnapshot value) async {
      if (value.documents.length == 0) {
      } else {
        var data = value.documents[0];
        UserData userData = UserData.fromFirebaseDocumentSnapshot(data);
        userData.id = user.uid;
        await Firestore.instance
            .collection("items")
            .where("userId", isEqualTo: value.documents[0].documentID)
            .orderBy('createdDate', descending: true)
            .getDocuments()
            .then((value) {
          userData.items = fromDocumentSnapshot(value.documents);
        });
        store.dispatch(InitUserData(userData));
      }
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new MainPage(
                store: store,
              )));
    });
  }

  static Future<void> splashLogin(
      Store<AppState> store, BuildContext context) async {
    (Connectivity().checkConnectivity()).then((value) {
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        var _auth = FirebaseAuth.instance;
        _auth.currentUser().then((user) {
          if (user != null) {
            Firestore.instance
                .collection('users')
                .where("uid", isEqualTo: user.uid)
                .getDocuments()
                .then((value) async {
              if (value.documents.length > 0) {
                UserData u = new UserData.fromFirebaseDocumentSnapshot(
                    value.documents.first);
                user.reload();

                await Firestore.instance
                    .collection("items")
                    .where("userId", isEqualTo: value.documents[0].documentID)
                    .getDocuments()
                    .then((value) {
                  u.items = fromDocumentSnapshot(value.documents);
                });

                final FirebaseMessaging _firebaseMessaging =
                    FirebaseMessaging();
                _firebaseMessaging.getToken().then((val) {
                  var token = val;
                  NotificationServices.updateToken(token, user.uid);
                });

                store.dispatch(InitUserData(u));
                Navigator.of(context).pushReplacementNamed("home");
              }
            });
          }
        });
      } else if (value == ConnectivityResult.none) {
        alert(context);
      }
    });
  }

  static Future<void> registerUser(BuildContext context, Store<AppState> store,
      FirebaseUser user, String phoneNumber) async {
    await Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: user.uid)
        .getDocuments()
        .then((QuerySnapshot value) async {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

      var registrationData = store.state.registrationData;
      if (value.documents.length == 0) {
        UserData userData = new UserData.constructInitial(
            user.uid, phoneNumber, registrationData);
        var platfom = "";
        _firebaseMessaging.getToken().then((val) {
          var token = val;
          _firebaseMessaging.onTokenRefresh.listen((token) {
            NotificationServices.updateToken(token, user.uid);
          });

          if (Platform.isAndroid) {
            platfom = "android";
          } else if (Platform.isIOS) {
            platfom = "ios";
          }
          NotificationServices.register(token, user.uid, platfom);
        });

        var newDoc =
            await Firestore.instance.collection('users').add(userData.toJson());

        Firestore.instance.collection('items').add(Item(
                currentSaving: 0,
                item: store.state.registrationData.item,
                targetPrice: store.state.registrationData.targetPrice)
            .toJson(newDoc.documentID));
        store.dispatch(ClearRegisterState());
        store.dispatch(InitUserData(userData));
      } else {
        var data = value.documents[0];
        UserData userData = new UserData.fromFirebaseDocumentSnapshot(data);
        store.dispatch(InitUserData(userData));
      }
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new MainPage(
                store: store,
              )));
    });
  }
}
