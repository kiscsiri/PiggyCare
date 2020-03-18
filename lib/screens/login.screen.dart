import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/services/authentication-service.dart';
import 'package:piggybanx/widgets/facebook.button.dart';
import 'package:piggybanx/widgets/google.button.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:video_player/video_player.dart';

import 'register/first.screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _message = '';

  String verificationId;

  final _telephoneFormKey = new GlobalKey<FormState>();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _pwController = TextEditingController();
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.asset('assets/animations/Baby-Feed1.mp4');

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _videoPlayerController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  _loginWithEmailAndPassword(BuildContext context) async {
    var store = StoreProvider.of<AppState>(context);
    var loc = PiggyLocalizations.of(context);
    final AuthCredential credential = EmailAuthProvider.getCredential(
        email: _emailController.text, password: _pwController.text);
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
      await AuthenticationService.authenticate(user, store, context);
    } catch (err) {}
  }

  Future<void> _signInWithGoogle() async {
    var store = StoreProvider.of<AppState>(context);
    var user = await AuthenticationService.signInWithGoogle(store);

    if (user == null) {
      return;
    }

    try {
      await AuthenticationService.authenticate(user, store, context);

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new MainPage()));
    } on AuthException {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new FirstRegisterPage()));
    }
  }

  Future _signInWithFacebook() async {
    var store = StoreProvider.of<AppState>(context);
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if (user == null) {
      return;
    }

    try {
      await AuthenticationService.authenticate(user, store, context);

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new MainPage()));
    } on AuthException {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new FirstRegisterPage()));
    }
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    return true;
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
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: <Widget>[
                  PiggyInput(
                    inputIcon: FontAwesomeIcons.user,
                    hintText: loc.trans("email"),
                    textController: _emailController,
                    width: MediaQuery.of(context).size.width * 0.7,
                    onValidate: (value) {
                      if (value.isEmpty) {
                        return loc.trans("required_field");
                      }
                      return null;
                    },
                    onErrorMessage: (error) {
                      setState(() {});
                    },
                  ),
                  PiggyInput(
                    inputIcon: Icons.lock_outline,
                    hintText: loc.trans("password"),
                    textController: _pwController,
                    obscureText: true,
                    width: MediaQuery.of(context).size.width * 0.7,
                    onValidate: (value) {
                      if (value.isEmpty) {
                        return loc.trans("required_field");
                      }
                      return null;
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
                          onClick: () async => await _signInWithFacebook(),
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
                          builder: (context) => new FirstRegisterPage()))
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
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration:
                      piggyBackgroundDecoration(context, UserType.adult),
                ),
              ],
            ),
            Container(child: Center(child: telephoneBlock)),
          ])),
    );
  }
}
