import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          UserData u = UserData(
              money: value.documents.first['Money'],
              period: value.documents.first['Period'],
              feedPerPeriod: value.documents.first['SavingPeriod'],
              lastFeed: value.documents.first['LastFeedTime'],
              saving: value.documents.first['Saving']);
          widget.store.dispatch(InitUserData(u));
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset("lib/assets/images/piggy_nyito.png"),
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0, top: 15),
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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: new Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.075,
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
                        color: Theme.of(context).primaryColor, fontSize: 25),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
