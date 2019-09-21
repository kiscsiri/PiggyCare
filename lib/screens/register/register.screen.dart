import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/services/authentication-service.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _message = '';

  String verificationId;
  bool _isCodeSent = false;

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

    var phoneState = SetPhoneNumber(_phoneCodeController.text);
    widget.store.dispatch(phoneState);

    FirebaseUser user;
    try {
      user = (await _auth.signInWithCredential(credential))?.user;
    } catch (Exception) {
      setState(() {
        _message = loc.trans("verification_failed");
      });
      return null;
    }
    if (user == null) throw Exception();

    await AuthenticationService.registerUser(
        context, widget.store, user, _phoneCodeController.text);
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
                padding: const EdgeInsets.only(bottom: 60.0, top: 30.0),
                child: new Text(
                  loc.trans("final_step"),
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
                    return loc.trans("long_code_error");
                  } else if (value.length < 6) {
                    return loc.trans("short_code_error");
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
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.pink,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
