import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/localization/localizations.delegate.dart';
import 'package:piggybanx/models/registration/registration.model.dart';
import 'package:piggybanx/models/user/user.model.dart';
import 'package:piggybanx/screens/login.screen.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/screens/piggyTryOut.dart';
import 'package:piggybanx/screens/startup.screen.dart';
import 'package:redux/redux.dart';
import 'package:piggybanx/models/store.reducer.dart';

import 'firebase/locator.dart';
import 'models/appState.dart';
import 'models/user/user.export.dart';
import 'screens/register/first.screen.dart';

var width = 0.0;
var height = 0.0;

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
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

  FirebaseAnalytics analytics = FirebaseAnalytics();

  ///Themes colors
  final primaryColor = Color(0xffe25979);
  final primaryDark = Color(0xffb1264c);

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
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
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
            backgroundColor: Color(0xffd2576b),
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
            'tryOut': (context) => PiggyWelcomePage(),
            'home': (context) => MainPage(),
            'register': (context) => FirstRegisterPage(),
            'login': (context) => LoginPage()
          }),
    );
  }
}
