import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/item/item.model.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.model.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _message = '';

  String verificationId;
  bool _isCodeSent = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _telephoneFormKey = new GlobalKey<FormState>();
  final _codeFormKey = new GlobalKey<FormState>();

  TextEditingController _phoneCodeController = new TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();

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

  Future<void> _testVerifyPhoneNumber(BuildContext context) async {
    var loc = PiggyLocalizations.of(context);
    var isExist = await Firestore.instance
        .collection("users")
        .where("phoneNumber", isEqualTo: _phoneCodeController.text)
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

    if (!isExist) return;
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credentials) {
      setState(() {
        _message = 'signInWithPhoneNumber auto succeeded';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message = loc.trans("verification_failed");
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
        _message = loc.trans("verification_failed");
      });
    }
  }

  _testSignInWithPhoneNumber(BuildContext context) async {
    var loc = PiggyLocalizations.of(context);
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: _smsCodeController.text,
    );
    FirebaseUser user;
    try {
      user = await _auth.signInWithCredential(credential);
    } catch (Exception) {
      setState(() {
        _message = loc.trans("verification_failed");
      });
      return null;
    }
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
    var loc = PiggyLocalizations.of(context);
    var telephoneBlock = new Form(
        key: _telephoneFormKey,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, top: 30.0),
                child: new Text(
                  loc.trans("enter_phone_number"),
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
                    return loc.trans("required_field");
                  } else if (value.length < 9) {
                    return loc.trans("short_number_validation");
                  } else if (value.length > 15) {
                    return loc.trans("long_number_validation");
                  }
                },
                onErrorMessage: (error) {
                  setState(() {});
                },
              ),
              Text(
                _message,
                style: new TextStyle(color: Colors.redAccent),
              ),
              PiggyButton(
                  text: loc.trans("send"),
                  onClick: () {
                    if (_telephoneFormKey.currentState.validate()) {
                      setState(() {
                        _testVerifyPhoneNumber(context);
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
              loc.trans("enter_sms"),
              style: Theme.of(context).textTheme.display3,
              textAlign: TextAlign.center,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(
                tooltip: loc.trans("go_back_phone_number_tooltip"),
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isCodeSent = !_isCodeSent;
                  });
                },
              ),
              PiggyInput(
                width: MediaQuery.of(context).size.width * 0.49,
                hintText: loc.trans("sms_code_hint"),
                textController: _smsCodeController,
                onValidate: (value) {
                  if (value.length > 6) {
                    return loc.trans("long_number_validation");
                  } else if (value.length < 6) {
                    return loc.trans("short_number_validation");
                  } else if (value.isEmpty) {
                    return loc.trans("required_field");
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
              text: loc.trans("verify"),
              onClick: () {
                if (_codeFormKey.currentState.validate()) {
                  setState(() {
                    _testSignInWithPhoneNumber(context);
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
                          child: new Text(
                            " ",
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
