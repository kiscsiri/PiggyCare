import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/models/user.redux.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/screens/register.screen.dart';
import 'package:piggybanx/screens/startup.screen.dart';
import 'package:piggybanx/services/notification-update.dart';
import 'package:redux/redux.dart';

var width = 0.0;
var height = 0.0;

void main() {
  var primaryColor = new Color(0xffe25979);
  var primaryDark = new Color(0xffb1264c);
  
  final store = new Store<UserData>(piggyReducer, initialState: new UserData());
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      MaterialApp(
          home: StoreProvider(
            store: store,
            child: StartupPage(store: store),
          ),
          theme: ThemeData(
            primaryColor: primaryColor,
            fontFamily: 'Montserrat',
            primaryColorDark: primaryDark,
            primaryTextTheme: TextTheme(
              display1: TextStyle(
                  color: primaryColor,
                  fontSize: 72.0,
                  fontWeight: FontWeight.bold),
              display2: TextStyle(
                  color: primaryColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              display3: TextStyle(
                  color: primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
              display4: TextStyle(
                  color: primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
            textTheme: TextTheme(
              display1: TextStyle(
                  color: primaryColor,
                  fontSize: 45.0,
                  fontWeight: FontWeight.bold),
              display2: TextStyle(
                  color: primaryColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              display3: TextStyle(
                  color: primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
              display4: TextStyle(
                  color: primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          routes: {
            '': (context) => new RegisterPage(store: store),
            'home': (context) => new MainPage(store: store)
          }),
    );
  });
}
