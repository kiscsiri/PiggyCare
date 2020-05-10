import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/models/user/user.model.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/services/user.services.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, @required this.user, bool isSelfProfile})
      : isSelfProfile = isSelfProfile ?? true,
        super(key: key);

  final UserData user;
  final bool isSelfProfile;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _message = '';
  String verificationId;

  bool _isVisible;
  bool _isAutoPostEnabled;
  bool _isEmailUser = false;

  FileImage _actualImage;
  FirebaseUser firebaseUser;

  final _telephoneFormKey = new GlobalKey<FormState>();

  final focusEmail = FocusNode();
  final focusPassword = FocusNode();
  final focusFullName = FocusNode();

  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _fullNameController.text = widget.user.name;
    _emailController.text = widget.user.email;
    _isVisible = widget.user.isPublicProfile ?? false;
    _isAutoPostEnabled = widget.user.isAutoPostEnabled ?? false;

    FirebaseAuth.instance.currentUser().then((value) {
      var provider = value.providerData.singleWhere(
          (element) => element.providerId == "password",
          orElse: () => null);
      if (provider != null) {
        setState(() {
          _isEmailUser = true;
        });
        firebaseUser = value;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  _setUserVisibility(bool val) {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  _setUAutoShare(bool val) {
    setState(() {
      _isAutoPostEnabled = !_isAutoPostEnabled;
    });
  }

  _updateUser() async {
    var store = StoreProvider.of<AppState>(context);
    var user = UserData(
        email: _emailController.text,
        name: _fullNameController.text,
        isPublicProfile: _isVisible,
        documentId: store.state.user.documentId,
        isAutoPostEnabled: _isAutoPostEnabled);
    try {
      if (_isEmailUser) {
        try {
          firebaseUser.updateEmail(_emailController.text);
        } catch (err) {
          setState(() {
            _message = "Az email nem megfelelő";
          });
        }
        firebaseUser.reload();
        if (_passwordController.text.isNotEmpty) {
          try {
            firebaseUser.updatePassword(_passwordController.text);
          } catch (err) {
            setState(() {
              _message = "A jelszó nem megfelelő";
            });
          }
        }
        firebaseUser.reload();
      }
      await UserServices.updateUser(user);
      store.dispatch(UpdateUserProfile(user));
      await showAlert(context, "Sikeres felhasználó mentés!");
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var loc = PiggyLocalizations.of(context);
    var user = store.state.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(store.state.user.name),
      ),
      body: ScrollConfiguration(
        behavior: new ScrollBehavior(),
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.88,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Form(
                  key: _telephoneFormKey,
                  child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(children: [
                            Hero(
                              tag: "profilePic",
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.22,
                                height: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: _actualImage == null
                                            ? (user.pictureUrl == null
                                                ? AssetImage(
                                                    "assets/images/Child-Normal.png")
                                                : NetworkImage(user.pictureUrl))
                                            : _actualImage)),
                              ),
                            ),
                          ]),
                          widget.isSelfProfile
                              ? PiggyInput(
                                  inputIcon: FontAwesomeIcons.user,
                                  hintText: loc.trans("full_name"),
                                  focusNode: focusFullName,
                                  textController: _fullNameController,
                                  textInputAction: TextInputAction.go,
                                  onSubmit: (val) async {
                                    FocusScope.of(context)
                                        .requestFocus(focusEmail);
                                    return "";
                                  },
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                              : Text(user.name),
                          widget.isSelfProfile
                              ? PiggyInput(
                                  enabled: _isEmailUser,
                                  inputIcon: Icons.mail_outline,
                                  hintText: loc.trans("email"),
                                  focusNode: focusEmail,
                                  textInputAction: TextInputAction.go,
                                  textController: _emailController,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  onSubmit: (val) async {
                                    FocusScope.of(context)
                                        .requestFocus(focusPassword);
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
                              : Text(user.email),
                          widget.isSelfProfile
                              ? PiggyInput(
                                  enabled: _isEmailUser,
                                  inputIcon: Icons.lock_outline,
                                  hintText: loc.trans("password"),
                                  textController: _passwordController,
                                  focusNode: focusPassword,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  obscureText: true,
                                  onValidate: (value) {},
                                  onErrorMessage: (error) {
                                    setState(() {});
                                  },
                                )
                              : Container(),
                          widget.isSelfProfile
                              ? Column(children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: <Widget>[
                                          Switch.adaptive(
                                              value: _isVisible,
                                              activeColor: Colors.green,
                                              inactiveThumbColor: Colors.red,
                                              inactiveTrackColor:
                                                  Colors.red[100],
                                              onChanged: (val) =>
                                                  _setUserVisibility(val)),
                                          Text(loc.trans('public_ask')),
                                        ]),
                                        IconButton(
                                          onPressed: () => showAlert(context,
                                              loc.trans('public_profile_info')),
                                          icon:
                                              Icon(FontAwesomeIcons.infoCircle),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Switch.adaptive(
                                                  value: _isAutoPostEnabled,
                                                  activeColor: Colors.green,
                                                  inactiveThumbColor:
                                                      Colors.red,
                                                  inactiveTrackColor:
                                                      Colors.red[100],
                                                  onChanged: (val) =>
                                                      _setUAutoShare(val)),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: Flexible(
                                                    child: Text(loc.trans(
                                                        'autmatic_share_ask'))),
                                              ),
                                            ]),
                                        IconButton(
                                          onPressed: () => showAlert(
                                              context,
                                              loc.trans(
                                                  'automatic_share_info')),
                                          icon:
                                              Icon(FontAwesomeIcons.infoCircle),
                                        )
                                      ],
                                    ),
                                  ),
                                  Text(
                                    _message,
                                    style:
                                        new TextStyle(color: Colors.redAccent),
                                  ),
                                  PiggyButton(
                                      text: loc.trans("save"),
                                      onClick: () async {
                                        if (_telephoneFormKey.currentState
                                            .validate()) {
                                          await _updateUser();
                                        }
                                      }),
                                ])
                              : Column()
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
