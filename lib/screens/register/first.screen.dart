import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/registration/registration.export.dart';
import 'package:piggybanx/screens/register/register.screen.dart';
import 'package:piggybanx/screens/register/second.screen.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:redux/redux.dart';

import '../../models/appState.dart';

class FirstRegisterPage extends StatefulWidget {
  FirstRegisterPage({Key key, this.store}) : super(key: key);

  final Store<AppState> store;
  @override
  _FirstRegisterPageState createState() => new _FirstRegisterPageState();
}

class _FirstRegisterPageState extends State<FirstRegisterPage> {
  _register(UserType type) {
    widget.store.dispatch(InitRegistration());

    var userTypeAction = SetUserType(type);
    widget.store.dispatch(userTypeAction);

    switch (type) {
      case UserType.individual:
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new SecondRegisterPage(
                      store: widget.store,
                    )));
        break;
      case UserType.adult:
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new LastPage(
                      store: widget.store,
                    )));
        break;
      case UserType.child:
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new LastPage(
                      store: widget.store,
                    )));
        break;
      default:
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new SecondRegisterPage(
                      store: widget.store,
                    )));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return new Scaffold(
      appBar: new AppBar(title: Text(loc.trans('registration'))),
      body: Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: coinBackground(context, UserType.child),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(bottom: 60.0, top: 30.0),
                        child: new Text(
                          loc.trans("you_are"),
                          style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        )),
                    PiggyButton(
                      text: loc.trans('individual'),
                      disabled: true,
                      onClick: () => _register(UserType.individual),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: coinBackground(context, UserType.child),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    PiggyButton(
                      text: loc.trans('adult'),
                      disabled: false,
                      onClick: () => _register(UserType.adult),
                    ),
                    PiggyButton(
                      text: loc.trans('child'),
                      disabled: false,
                      onClick: () => _register(UserType.child),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
