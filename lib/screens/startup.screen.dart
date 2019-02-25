import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/models/user.redux.dart';
import 'package:redux/redux.dart';

class StartupPage extends StatefulWidget {
  StartupPage({Key key, this.title, this.store}) : super(key: key);
  final String title;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Store<UserData> store;

  @override
  _StartupPageState createState() => new _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  final Firestore firestore = new Firestore();
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    widget._auth.currentUser().then((user) {
      if (user != null) {
        firestore
            .collection('users')
            .where("phoneNumber", isEqualTo: user.phoneNumber)
            .getDocuments()
            .then((value) {
          if (value.documents.length > 2) {
            UserData u = UserData(
                money: value.documents.first['money'],
                period: Period.values[value.documents.first['period']],
                feedPerPeriod: value.documents.first['feedPerPeriod'],
                lastFeed: value.documents.first['lastFeed'],
                id: user.uid,
                created: value.documents.first['created'],
                phoneNumber: value.documents.first['phoneNumber'],
                saving: value.documents.first['saving']);
            widget.store.dispatch(InitUserData(u));
            Navigator.of(context).pushNamed("home");
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
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                          Navigator.of(context).pushNamed('');
                        },
                        child: new Text(
                          "Let's start!",
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
