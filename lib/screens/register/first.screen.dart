import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/registration/business.registration.dart';
import 'package:piggycare/models/registration/donator.registration.dart';
import 'package:piggycare/models/registration/registration.export.dart';
import 'package:piggycare/widgets/piggy.widgets.export.dart';
import 'package:redux/redux.dart';

import '../../models/appState.dart';

class FirstRegisterPage extends StatefulWidget {
  FirstRegisterPage({Key key}) : super(key: key);

  @override
  _FirstRegisterPageState createState() => new _FirstRegisterPageState();
}

class _FirstRegisterPageState extends State<FirstRegisterPage> {
  _register(UserType type, Store<AppState> store) {
    store.dispatch(InitRegistration());

    var userTypeAction = SetUserType(type);
    store.dispatch(userTypeAction);

    switch (type) {
      case UserType.business:
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new BusinessRegistrationScreen()));
        break;
      case UserType.donator:
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new DonatorRegistrationScreen()));
        break;
      default:
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new DonatorRegistrationScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
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
                decoration: coinBackground(context),
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
                      text: loc.trans('business'),
                      disabled: false,
                      onClick: () => _register(UserType.business, store),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: coinBackground(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    PiggyButton(
                      text: loc.trans('donator'),
                      disabled: false,
                      onClick: () => _register(UserType.donator, store),
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
