import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/models/user.redux.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title, this.firestore, this.store})
      : super(key: key);

  final Firestore firestore;
  final Store<UserData> store;
  final String title;

  final youtube = new FlutterYoutube();

  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future<String> _message = Future<String>.value('');

  String verificationId;
  bool _isCodeSent = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _telephoneFormKey = new GlobalKey<FormState>();
  final _codeFormKey = new GlobalKey<FormState>();

  TextEditingController _phoneCodeController =
      new TextEditingController(text: "+1 650-555-6969");
  TextEditingController _smsCodeController =
      TextEditingController(text: "555555");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneCodeController.dispose();
    _smsCodeController.dispose();
  }

  Future<void> _testVerifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      setState(() {
        _message =
            Future<String>.value('signInWithPhoneNumber auto succeeded: $user');
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message = Future<String>.value(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
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

    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneCodeController.text,
        timeout: const Duration(seconds: 0),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<String> _testSignInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: _smsCodeController.text,
    );

    var user = await _auth.signInWithCredential(credential);

    await Firestore.instance
        .collection("users")
        .where("uid", isEqualTo: user.uid)
        .getDocuments()
        .then((QuerySnapshot value) {
      if (value.documents.length == 0) {
        UserData userData = new UserData(
            id: user.uid,
            phoneNumber: _phoneCodeController.text,
            feedPerPeriod: 200,
            lastFeed: null,
            money: 100000,
            saving: 0,
            period: Period.daily);
        Firestore.instance.collection('users').add(userData.toJson());
        widget.store.dispatch(InitUserData(userData));
      } else {
        var data = value.documents[0];
        UserData userData = new UserData(
            id: user.uid,
            phoneNumber: data['phoneNumber'],
            feedPerPeriod: data['feedPerPeriod'],
            lastFeed: data['lastFeed'],
            money: data['money'],
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
                padding: const EdgeInsets.only(bottom: 80.0, top: 60.0),
                child: new Text(
                  "ADD PHONE NUMBER",
                  style: Theme.of(context).textTheme.display3,
                  textAlign: TextAlign.center,
                ),
              ),
              PiggyInput(
                hintText: "+123456789101",
                textController: _phoneCodeController,
                onValidate: (value) {
                  if (value.isEmpty) {
                    return "This field is required";
                  } else if (value.length > 12) {
                    return "The number is too long";
                  } else if (value.length < 10) {
                    return "The number is too short";
                  }
                },
              ),
              PiggyButton(
                  text: "SEND",
                  onClick: () {
                    if (_telephoneFormKey.currentState.validate()) {
                      setState(() {
                        _message = _testVerifyPhoneNumber();
                      });
                    }
                  })
            ]));

    var codeBlock = new Form(
        key: _codeFormKey,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0, top: 60.0),
            child: new Text(
              "ENTER YOUR SMS CODE",
              style: Theme.of(context).textTheme.display3,
              textAlign: TextAlign.center,
            ),
          ),
          PiggyInput(
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
          ),
          PiggyButton(
              text: "VERIFY",
              onClick: () {
                if (_codeFormKey.currentState.validate()) {
                  setState(() {
                    _message = _testSignInWithPhoneNumber();
                  });
                }
              })
        ]));

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("PiggyBanx"),
      ),
      body: new Center(
          child: Padding(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0, top: 25),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                (_isCodeSent) ? codeBlock : telephoneBlock,
                new Padding(
                  padding: new EdgeInsets.only(bottom: 25),
                ),
                Container(
                    decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
                    margin: EdgeInsets.only(bottom: 0),
                    child: Center(
                      child: new Text(
                        "Watch this video, to learn, how to do it!",
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    )),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: new WebviewScaffold(
                    url: "https://www.youtube.com/embed/y6120QOlsfU",
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
