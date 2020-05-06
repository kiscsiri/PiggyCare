import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piggybanx/helpers/error.constants.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/services/authentication-service.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/google.button.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LastPage extends StatefulWidget {
  LastPage({Key key, @required this.initUserName, @required this.initEmail})
      : super(key: key);

  final String initUserName;
  final String initEmail;
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<LastPage> {
  String _message = '';
  bool _privacyElfogadva = false;
  String verificationId;

  final _telephoneFormKey = new GlobalKey<FormState>();

  final focusEmail = FocusNode();
  final focusPassword = FocusNode();

  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _userNameController.text = widget.initUserName;
    _emailController.text = widget.initEmail;

    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _message = "";
    });
    var loc = PiggyLocalizations.of(context);
    var store = StoreProvider.of<AppState>(context);
    if (!_privacyElfogadva) {
      showAlert(context, loc.trans('privacy_validation_error'));
      return;
    }
    try {
      var res = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      store.dispatch(SetFromOauth(
          res.user.email,
          res.user.displayName ?? _userNameController.text,
          res.user.uid,
          res.user.photoUrl));

      await AuthenticationService.registerUser(store);

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new MainPage()));
    } on PlatformException catch (err) {
      if (err.code == ERROR_WEAK_PASSWORD) {
        await showAlert(context, "Kérem adjon meg egy erősebb jelszót!");
      } else if (err.code == ERROR_EMAIL_ALREADY_IN_USE)
        await showAlert(context, "Létezik már az adott e-mail cím");
    }
  }

  Future<void> signInAndRegisterGoogle(Store<AppState> store) async {
    setState(() {
      _message = "";
    });
    var loc = PiggyLocalizations.of(context);
    var store = StoreProvider.of<AppState>(context);
    if (!_privacyElfogadva) {
      showAlert(context, loc.trans('privacy_validation_error'));
      return;
    }
    var user = await AuthenticationService.signInWithGoogle(store);
    store.dispatch(
        SetFromOauth(user.email, user.displayName, user.uid, user.photoUrl));

    await AuthenticationService.registerUser(store);

    setState(() {
      _emailController.text = user.email;
      _userNameController.text = user.displayName;
    });

    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new MainPage()));
  }

  openPrivacy() async {
    var url =
        "https://piggybanx.com/wp-content/uploads/2019/11/Adatkezel%C3%A9si-t%C3%A1j%C3%A9koztat%C3%B3.pdf";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var store = StoreProvider.of<AppState>(context);
    var telephoneBlock = new Form(
        key: _telephoneFormKey,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0, top: 30.0),
                  child: new Text(
                    loc.trans("final_step"),
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ),
                PiggyInput(
                  inputIcon: FontAwesomeIcons.user,
                  hintText: loc.trans("user_name"),
                  textController: _userNameController,
                  textInputAction: TextInputAction.go,
                  onSubmit: (val) {
                    FocusScope.of(context).requestFocus(focusEmail);
                  },
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
                  inputIcon: Icons.mail_outline,
                  hintText: loc.trans("email"),
                  focusNode: focusEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.go,
                  textController: _emailController,
                  width: MediaQuery.of(context).size.width * 0.7,
                  onSubmit: (val) {
                    FocusScope.of(context).requestFocus(focusPassword);
                  },
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
                  textController: _passwordController,
                  focusNode: focusPassword,
                  width: MediaQuery.of(context).size.width * 0.7,
                  obscureText: true,
                  onSubmit: (value) async {
                    if (_telephoneFormKey.currentState.validate()) {
                      await _register();
                    }
                  },
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (val) {
                          setState(() {
                            _privacyElfogadva = val;
                          });
                        },
                        value: _privacyElfogadva,
                      ),
                      Flexible(
                        child: Text(
                          loc.trans('privacy_accept'),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () async => await openPrivacy(),
                    child: Text(
                      loc.trans('privacy_policy'),
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    )),
                Text(
                  _message,
                  style: new TextStyle(color: Colors.redAccent),
                ),
                PiggyButton(
                    text: loc.trans("register"),
                    onClick: () async {
                      if (_telephoneFormKey.currentState.validate()) {
                        await _register();
                      }
                    }),
                Text(loc.trans('or_register_somehow')),
                PiggyGoogleButton(
                  text: "Google",
                  onClick: () async => signInAndRegisterGoogle(store),
                ),
              ]),
        ));
    return new Scaffold(
        appBar: new AppBar(
          title: Text(loc.trans('registration')),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView(children: <Widget>[
          Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: piggyBackgroundDecoration(context),
                ),
              ],
            ),
            Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: telephoneBlock,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
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
            ),
          ]),
        ]));
  }
}
