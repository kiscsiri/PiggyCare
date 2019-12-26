import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/screens/register/second.screen.dart';
import 'package:piggybanx/services/authentication-service.dart';
import 'package:piggybanx/widgets/facebook.button.dart';
import 'package:piggybanx/widgets/google.button.dart';
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

  _loginWithEmailAndPassword(BuildContext context) async {
    var loc = PiggyLocalizations.of(context);
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: _smsCodeController.text,
    );
    FirebaseUser user;
    try {
      AuthResult auth = await _auth.signInWithCredential(credential);
      user = auth?.user;
    } catch (e) {
      setState(() {
        _message = loc.trans("verification_failed");
      });
      return null;
    }
    if (user == null) throw Exception();

    try {
      await AuthenticationService.authenticate(user, widget.store);
    } catch (err) {}
  }

  Future<void> _signInWithGoogle() async {
    var user = await AuthenticationService.signInWithGoogle(widget.store);

    try {
      await AuthenticationService.authenticate(user, widget.store);

      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new MainPage(
                store: widget.store,
              )));
    } on AuthException {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new FirstRegisterPage(
                store: widget.store,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var telephoneBlock = new Form(
        key: _telephoneFormKey,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, top: 30.0),
                child: new Text(
                  loc.trans("login"),
                  style: Theme.of(context).textTheme.display3,
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: <Widget>[
                  PiggyInput(
                    inputIcon: FontAwesomeIcons.user,
                    hintText: loc.trans("user_name"),
                    textController: _phoneCodeController,
                    width: MediaQuery.of(context).size.width * 0.7,
                    onValidate: (value) {
                      if (value.isEmpty) {
                        return loc.trans("required_field");
                      }
                      return "";
                    },
                    onErrorMessage: (error) {
                      setState(() {});
                    },
                  ),
                  PiggyInput(
                    inputIcon: Icons.lock_outline,
                    hintText: loc.trans("password"),
                    textController: _phoneCodeController,
                    width: MediaQuery.of(context).size.width * 0.7,
                    onValidate: (value) {
                      if (value.isEmpty) {
                        return loc.trans("required_field");
                      }
                    },
                    onErrorMessage: (error) {
                      setState(() {});
                    },
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          child: Text(
                            loc.trans("pw_forgot"),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ]),
                  Text(
                    _message,
                    style: new TextStyle(color: Colors.redAccent),
                  ),
                  PiggyButton(
                      text: loc.trans("login"),
                      onClick: () {
                        if (_telephoneFormKey.currentState.validate()) {
                          setState(() {
                            _loginWithEmailAndPassword(context);
                          });
                        }
                      }),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.07),
                    child: Text(loc.trans('connect_using')),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 25.0, top: 5),
                        child: PiggyFacebookButton(
                          text: "Facebook",
                          onClick: () async => await _signInWithGoogle(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 25.0, top: 5),
                        child: PiggyGoogleButton(
                          text: "Google",
                          onClick: () async => await _signInWithGoogle(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(loc.trans('dont_have_user')),
                  GestureDetector(
                    onTap: () => {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new FirstRegisterPage(
                                store: widget.store,
                              )))
                    },
                    child: Text(
                      loc.trans('register'),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ]));

    return Scaffold(
      appBar: new AppBar(
        title: new Text("PiggyBanx"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Center(child: telephoneBlock),
      ),
    );
  }
}
