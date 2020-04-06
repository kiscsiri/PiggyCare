import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class BusinessRegistrationScreen extends StatefulWidget {
  BusinessRegistrationScreen({Key key}) : super(key: key);

  @override
  _BusinessRegistrationScreenState createState() =>
      _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState
    extends State<BusinessRegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _useGatheredBusinessPlace = true;
  bool _businessFound = false;
  String _message = '';
  var _businessData;

  final _registrationFormKey = new GlobalKey<FormState>();

  final focusTaxNumber = FocusNode();
  final focusBusinessNumber = FocusNode();
  final focusPassword = FocusNode();
  final focusBusinessName = FocusNode();
  final focusLocationPlace = FocusNode();
  final focusEmail = FocusNode();

  TextEditingController _businessNameController = new TextEditingController();
  TextEditingController _taxNumberController = TextEditingController();
  TextEditingController _businessNumberController = TextEditingController();
  TextEditingController _operationPlaceController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _taxNumberController.dispose();
    _businessNumberController.dispose();
    super.dispose();
  }

  Future searchBusiness() async {
    setState(() {
      _businessFound = true;
    });
    return;

    var business;

    // TODO - Api meghívás a cég lekérdezésre, a businessData pedig majd a visszatérő adatokat tárolja
    if (business == null) {
      await showAlert(context, "Nem található a megadott cég!");
      return;
    }
    setState(() {
      _businessFound = true;
    });
  }

  Future<void> _register(BuildContext context, Store<AppState> store) async {
    try {
      var businessData;
      var res = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      store.dispatch(SetFromRegistrationForm(
          res.user.email,
          res.user.displayName ?? _businessNameController.text,
          res.user.uid,
          res.user.photoUrl,
          _taxNumberController.text,
          _businessNumberController.text,
          _useGatheredBusinessPlace
              ? (businessData?.place ?? "")
              : _operationPlaceController.text));

      await AuthenticationService.registerUser(store);

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new MainPage()));
    } on PlatformException catch (err) {
      if (err.code == "ERROR_INVALID_EMAIL")
        await showAlert(
            context, "Az e-mail cím nem megfelelően formátumban van");
      if (err.code == "ERROR_EMAIL_ALREADY_IN_USE")
        await showAlert(context, "Létezik már az adott e-mail cím");
      if (err.code == "ERROR_WEAK_PASSWORD")
        await showAlert(context, "Kérem adjon meg erősebb jelszót!");
    }
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var store = StoreProvider.of<AppState>(context);
    var registrationBlock = new Form(
        key: _registrationFormKey,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0, top: 15.0),
                child: new Text(
                  loc.trans("final_step"),
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              ),
              PiggyInput(
                inputIcon: FontAwesomeIcons.building,
                hintText: loc.trans("business_name"),
                textController: _businessNameController,
                textInputAction: TextInputAction.go,
                focusNode: focusBusinessName,
                onSubmit: (val) async {
                  FocusScope.of(context).requestFocus(focusTaxNumber);
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
                inputIcon: Icons.receipt,
                hintText: loc.trans("tax_number"),
                focusNode: focusTaxNumber,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.number,
                textController: _businessNumberController,
                width: MediaQuery.of(context).size.width * 0.7,
                onSubmit: (val) async {
                  FocusScope.of(context).requestFocus(focusBusinessNumber);
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
                inputIcon: FontAwesomeIcons.briefcase,
                hintText: loc.trans("business_number"),
                textInputAction: TextInputAction.go,
                textController: _taxNumberController,
                keyboardType: TextInputType.number,
                focusNode: focusBusinessNumber,
                width: MediaQuery.of(context).size.width * 0.7,
                onSubmit: (value) async {
                  if (_registrationFormKey.currentState.validate()) {
                    FocusScope.of(context).requestFocus(focusEmail);
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
              PiggyInput(
                inputIcon: Icons.mail,
                hintText: loc.trans("email"),
                textController: _emailController,
                textInputAction: TextInputAction.go,
                focusNode: focusEmail,
                width: MediaQuery.of(context).size.width * 0.7,
                onSubmit: (value) async {
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
                textInputAction: _useGatheredBusinessPlace
                    ? TextInputAction.done
                    : TextInputAction.go,
                focusNode: focusPassword,
                width: MediaQuery.of(context).size.width * 0.7,
                obscureText: true,
                onSubmit: (value) async {
                  if (!_useGatheredBusinessPlace) {
                    FocusScope.of(context).requestFocus(focusLocationPlace);
                  }
                  if (_registrationFormKey.currentState.validate()) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    onChanged: (val) {
                      setState(() {
                        _useGatheredBusinessPlace = val;
                      });
                    },
                    value: _useGatheredBusinessPlace,
                  ),
                  Text(loc.trans("use_headquarters_address"))
                ],
              ),
              !_useGatheredBusinessPlace
                  ? PiggyInput(
                      inputIcon: FontAwesomeIcons.mapSigns,
                      hintText: loc.trans("business_operation_place"),
                      textController: _operationPlaceController,
                      width: MediaQuery.of(context).size.width * 0.7,
                      focusNode: focusLocationPlace,
                      onSubmit: (value) async {
                        if (_registrationFormKey.currentState.validate()) {
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
                    )
                  : Container(),
              Text(
                _message,
                style: new TextStyle(color: Colors.redAccent),
              ),
              PiggyButton(
                  text: _businessFound
                      ? loc.trans("register")
                      : loc.trans("search_businesses"),
                  onClick: () async {
                    if (_registrationFormKey.currentState.validate()) {
                      _businessFound
                          ? await _register(context, store)
                          : await searchBusiness();
                    }
                  }),
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
