import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/models/user.redux.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/screens/piggyTryOut.dart';
import 'package:piggybanx/services/notification-update.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';
import 'package:webview_flutter/webview_flutter.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title, this.firestore, this.store})
      : super(key: key);

  final Firestore firestore;
  final Store<UserData> store;
  final String title;

  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _message = '';

  String verificationId;
  bool _isCodeSent = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _telephoneFormKey = new GlobalKey<FormState>();
  final _codeFormKey = new GlobalKey<FormState>();

  TextEditingController _phoneCodeController = new TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();

  final Completer<WebViewController> _youtubeController =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneCodeController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }

  Future<void> _testVerifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      setState(() {
        _message = 'signInWithPhoneNumber auto succeeded: $user';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message = 'Phone number verification failed. Please try again!';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
    };

    setState(() {
      _isCodeSent = true;
    });

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneCodeController.text,
          timeout: const Duration(seconds: 0),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (Exception) {
      setState(() {
        _message = 'Phone number verification failed. Please try again!';
      });
    }
  }

  Future<String> _testSignInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: _smsCodeController.text,
    );
    FirebaseUser user;
    try {
      user = await _auth.signInWithCredential(credential);
    } catch (Exception) {
      setState(() {
        _message = 'Phone number verification failed. Please try again!';
      });
      return null;
    }
    await Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: user.uid)
        .getDocuments()
        .then((QuerySnapshot value) {
      if (value.documents.length == 0) {
        UserData userData = new UserData(
            id: user.uid,
            phoneNumber: user.phoneNumber,
            feedPerPeriod: 5,
            lastFeed: DateTime(1995),
            money: 100000,
            created: DateTime.now(),
            saving: 0,
            period: Period.daily);

        var token = "";
        var platfom = "";
        _firebaseMessaging.getToken().then((val) {
          token = val;
          _firebaseMessaging.onTokenRefresh.listen((token) {
            NotificationUpdate.updateToken(token, user.uid);
          });

          if (Platform.isAndroid) {
            platfom = "android";
          } else if (Platform.isIOS) {
            platfom = "ios";
          }
          NotificationUpdate.register(token, user.uid, platfom);
        });

        Firestore.instance.collection('users').add(userData.toJson());
        widget.store.dispatch(InitUserData(userData));
      } else {
        var data = value.documents[0];
        UserData userData = new UserData(
            id: user.uid,
            phoneNumber: data['phoneNumber'],
            feedPerPeriod: data['feedPerPeriod'],
            lastFeed: data['lastFeed'].toDate(),
            money: data['money'],
            created: data['created'].toDate(),
            saving: data['saving'],
            period: Period.values[data['period']]);
        widget.store.dispatch(InitUserData(userData));
      }
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new MainPage(
                store: widget.store,
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    var telephoneBlock = new Form(
        key: _telephoneFormKey,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, top: 30.0),
                child: new Text(
                  "ADD PHONE NUMBER",
                  style: Theme.of(context).textTheme.display3,
                  textAlign: TextAlign.center,
                ),
              ),
              PiggyInput(
                hintText: "+123456789101",
                textController: _phoneCodeController,
                width: MediaQuery.of(context).size.width * 0.7,
                onValidate: (value) {
                  if (value.isEmpty) {
                    return "This field is required";
                  } else if (value.length < 9) {
                    return "The number is too short";
                  } else if (value.length > 12) {
                    return "The number is too long";
                  }
                },
                onErrorMessage: (error) {
                  setState(() {
                  });
                },
              ),
              Text(
                _message,
                style: new TextStyle(color: Colors.redAccent),
              ),
              PiggyButton(
                  text: "SEND",
                  onClick: () {
                    if (_telephoneFormKey.currentState.validate()) {
                      setState(() {
                        _testVerifyPhoneNumber();
                      });
                    }
                  })
            ]));

    var codeBlock = new Form(
        key: _codeFormKey,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0, top: 30.0),
            child: new Text(
              "ENTER YOUR SMS CODE",
              style: Theme.of(context).textTheme.display3,
              textAlign: TextAlign.center,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(
                tooltip: "Go back to type in another phone number",
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isCodeSent = !_isCodeSent;
                  });
                },
              ),
              PiggyInput(
                width: MediaQuery.of(context).size.width * 0.49,
                hintText: "Your SMS code",
                textController: _smsCodeController,
                onValidate: (value) {
                  if (value.length > 6) {
                    return "The validation code is too long";
                  } else if (value.length < 6) {
                    return "The validation code is too short";
                  } else if (value.isEmpty) {
                    return "This field is required";
                  }
                },
                onErrorMessage: (error) {
                  _message = error;
                },
              ),
            ],
          ),
          Text(
            _message,
            style: new TextStyle(color: Colors.redAccent),
          ),
          PiggyButton(
              text: "VERIFY",
              onClick: () {
                if (_codeFormKey.currentState.validate()) {
                  setState(() {
                    _testSignInWithPhoneNumber();
                  });
                }
              })
        ]));

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("PiggyBanx"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: (_isCodeSent) ? codeBlock : telephoneBlock,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        margin: EdgeInsets.only(bottom: 0),
                        child: Center(
                          child: new Text(" ",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Colors.white, fontSize: 17),
                          ),
                        ))
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
