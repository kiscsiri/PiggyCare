import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/item/item.model.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.model.dart';
import 'package:piggybanx/widgets/PiggyScaffold.dart';
import 'package:redux/redux.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupPage extends StatefulWidget {
  StartupPage({Key key, this.title, this.store}) : super(key: key);
  final String title;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Store<AppState> store;

  @override
  _StartupPageState createState() => new _StartupPageState();
}

alert(BuildContext context) {
  var loc = PiggyLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(loc.trans("no_internet")),
        content: Text(loc.trans("check_internet")),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
        ],
      );
    },
  );
}

class _StartupPageState extends State<StartupPage> {
  final Firestore firestore = new Firestore();
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      if (!prefs.containsKey("animationCount")) {
        prefs.setInt("animationCount", 1);
      }
    });

    (Connectivity().checkConnectivity()).then((value) {
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        widget._auth.currentUser().then((user) {
          if (user != null) {
            firestore
                .collection('users')
                .where("uid", isEqualTo: user.uid)
                .getDocuments()
                .then((value) async {
              if (value.documents.length > 0) {
                UserData u = new UserData.fromFirebaseDocumentSnapshot(
                    value.documents.first);
                user.reload();

                await Firestore.instance
                    .collection("items")
                    .where("userId", isEqualTo: value.documents[0].documentID)
                    .getDocuments()
                    .then((value) {
                  u.items = fromDocumentSnapshot(value.documents);
                });

                widget.store.dispatch(InitUserData(u));
                Navigator.of(context).pushReplacementNamed("home");
              } else {
                setState(() {
                  _isLoaded = true;
                });
              }
            });
          } else {
            setState(() {
              _isLoaded = true;
            });
          }
        });
      } else if (value == ConnectivityResult.none) {
        alert(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return PiggyScaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Image.asset("lib/assets/images/piggy_nyito.png"),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Piggy",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      new Text("Banx",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w200,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            (_isLoaded)
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: new Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.085,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(70.0)),
                      child: new FlatButton(
                        onPressed: () async {
                          Navigator.of(context).pushReplacementNamed('tryOut');
                        },
                        child: new Text(
                          loc.trans("lets_start"),
                          style: new TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25),
                        ),
                      ),
                    ),
                  )
                : new Container()
          ],
        ),
      ),
    );
  }
}
