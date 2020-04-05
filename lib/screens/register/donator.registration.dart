import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/models/registration/registration.export.dart';
import 'package:piggycare/screens/main.screen.dart';
import 'package:piggycare/services/authentication-service.dart';
import 'package:piggycare/services/piggy.page.services.dart';
import 'package:piggycare/widgets/piggy.widgets.export.dart';
import 'package:redux/redux.dart';

class DonatorRegistrationScreen extends StatefulWidget {
  DonatorRegistrationScreen({Key key}) : super(key: key);

  @override
  _DonatorRegistrationScreenState createState() =>
      _DonatorRegistrationScreenState();
}

class _DonatorRegistrationScreenState extends State<DonatorRegistrationScreen> {
  String _message = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId;

  final _telephoneFormKey = new GlobalKey<FormState>();

  final focusEmail = FocusNode();
  final focusPassword = FocusNode();
  final focusUserName = FocusNode();

  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _register(BuildContext context, Store<AppState> store) async {
    try {
      var res = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      store.dispatch(SetFromRegistrationForm(
          res.user.email,
          res.user.displayName ?? _userNameController.text,
          res.user.uid,
          res.user.photoUrl,
          null,
          null,
          null));

      await AuthenticationService.registerUser(store);

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new MainPage()));
    } on Exception {
      await showAlert(context, "Létezik már az adott e-mail cím");
    }
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var store = StoreProvider.of<AppState>(context);
    var registrationBlock = new Form(
        key: _telephoneFormKey,
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
                hintText: loc.trans("full_name"),
                textController: _userNameController,
                textInputAction: TextInputAction.go,
                onSubmit: (val) async {
                  FocusScope.of(context).requestFocus(focusUserName);
                  return "";
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
                inputIcon: FontAwesomeIcons.user,
                hintText: loc.trans("user_name"),
                textController: _userNameController,
                textInputAction: TextInputAction.go,
                focusNode: focusUserName,
                onSubmit: (val) async {
                  FocusScope.of(context).requestFocus(focusEmail);
                  return "";
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
                textInputAction: TextInputAction.go,
                textController: _emailController,
                width: MediaQuery.of(context).size.width * 0.7,
                onSubmit: (val) async {
                  FocusScope.of(context).requestFocus(focusPassword);
                  return "";
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
                    await _register(context, store);
                  }
                  return "";
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
              Text(
                _message,
                style: new TextStyle(color: Colors.redAccent),
              ),
              PiggyButton(
                  text: loc.trans("register"),
                  onClick: () async {
                    if (_telephoneFormKey.currentState.validate()) {
                      await _register(context, store);
                    }
                  }),
              Text(loc.trans('or_register_somehow')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PiggyFacebookButton(
                    text: "Facebook",
                    disabled: true,
                    onClick: null,
                  ),
                  PiggyGoogleButton(
                    text: "Google",
                    disabled: true,
                    onClick: null,
                  ),
                ],
              )
            ]));
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
                        child: registrationBlock,
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
