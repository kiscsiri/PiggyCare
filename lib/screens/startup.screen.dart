import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/services/authentication-service.dart';
import 'package:piggybanx/services/notification.handler.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupPage extends StatefulWidget {
  StartupPage({Key key, this.title, this.store}) : super(key: key);
  final String title;
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
              exit(0);
            },
          ),
        ],
      );
    },
  );
}

alertNoCon() {
  return AlertDialog(
    title: Text("asd"),
    content: Text("asd"),
    actions: <Widget>[
      FlatButton(
        child: Text('Ok'),
        onPressed: () {
          exit(0);
        },
      ),
    ],
  );
}

class _StartupPageState extends State<StartupPage>
    with TickerProviderStateMixin {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (!prefs.containsKey("animationCount")) {
        prefs.setInt("animationCount", 1);
      }
    });

    AuthenticationService.splashLogin(widget.store, context).then((success) {
      setState(() {
        _isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return Scaffold(
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
                          await exitStartAnimation(this, false, context);
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
