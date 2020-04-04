import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggycare/localization/localizations.delegate.dart';
import 'package:piggycare/models/registration/registration.model.dart';
import 'package:piggycare/models/user/user.model.dart';
import 'package:piggycare/screens/after.startup.dart';
import 'package:piggycare/screens/login.screen.dart';
import 'package:piggycare/screens/main.screen.dart';
import 'package:piggycare/screens/startup.screen.dart';
import 'package:redux/redux.dart';
import 'package:piggycare/models/store.reducer.dart';

import 'enums/period.dart';
import 'firebase/locator.dart';
import 'models/appState.dart';
import 'models/user/user.export.dart';
import 'screens/register/first.screen.dart';

var width = 0.0;
var height = 0.0;

void main() {
  setupLocator();
  runApp(PiggyApp());
}

class PiggyApp extends StatelessWidget {
  final supportedLangs = [const Locale('hu', 'HU'), const Locale('en', 'US')];

  final List<LocalizationsDelegate> localizationDelegates = [
    const PiggyLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ];

  final localisationResultCallback =
      (Locale locale, Iterable<Locale> supportedLocales) {
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode ||
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  };

  ///Themes colors
  final primaryColor = Color(0xff099ECC);
  final primaryDark = Color(0xff099ECC);

  ///Redux states init
  static final registrationState =
      RegistrationData(item: "", phoneNumber: "", targetPrice: 0);
  static final userState = UserData(
      created: DateTime.now(),
      feedPerPeriod: 0,
      id: "",
      lastFeed: DateTime.now(),
      money: 0,
      period: Period.demo,
      phoneNumber: "",
      saving: 0);

  final store = Store<AppState>(applicationReducer,
      initialState:
          AppState(registrationData: registrationState, user: userState));
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
          supportedLocales: supportedLangs,
          localizationsDelegates: localizationDelegates,
          localeResolutionCallback: localisationResultCallback,
          home: StartupPage(),
          theme: ThemeData(
            primaryColor: primaryColor,
            fontFamily: 'Montserrat',
            primaryColorDark: primaryDark,
            primaryTextTheme: TextTheme(
              headline4: TextStyle(
                  color: primaryColor,
                  fontSize: 72.0,
                  fontWeight: FontWeight.bold),
              headline3: TextStyle(
                  color: primaryColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              headline2: TextStyle(
                  color: primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
              headline1: TextStyle(
                  color: primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: primaryColor,
            textTheme: TextTheme(
              headline4: TextStyle(
                  color: primaryColor,
                  fontSize: 45.0,
                  fontWeight: FontWeight.bold),
              headline3: TextStyle(
                  color: primaryColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              headline2: TextStyle(
                  color: primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
              headline1: TextStyle(
                  color: primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
              headline6: TextStyle(
                  color: primaryDark,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          routes: {
            'tryOut': (context) => PiggyAfterStartupScreen(),
            'home': (context) => MainPage(),
            'register': (context) => FirstRegisterPage(),
            'login': (context) => LoginPage()
          }),
    );
  }
}
