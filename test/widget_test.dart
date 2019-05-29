import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/screens/register/register.screen.dart';
import 'package:piggybanx/screens/startup.screen.dart';
import 'package:redux/redux.dart';
import 'package:piggybanx/models/store.reducer.dart';


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    var primaryColor = new Color(0xffe25979);
    var primaryDark = new Color(0xffb1264c);

    final store = new Store<AppState>(applicationReducer, middleware: []);

    await tester.pumpWidget(MaterialApp(
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
        }));

    // Verify that our counter starts at 0.
    // expect(find.byType(FlatButton), findsOneWidget);
    // await tester.tap(find.byType(FlatButton));
    // Future.delayed(const Duration(milliseconds: 500), () async {
    //   expect(find.byType(FlatButton), findsOneWidget);
    //   expect(find.byType(WebviewScaffold), findsOneWidget);
    //   expect(find.text("SEND"), findsOneWidget);

    //   await tester.tap(find.byType(FlatButton));

    //   expect(find.text("VERIFY"), findsOneWidget);
    // });
  });
}
