import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/widgets/piggy.button.dart';

class SavingsPage extends StatefulWidget {
  SavingsPage({Key key, this.title, this.pageController}) : super(key: key);

  final String title;
  final PageController pageController;

  @override
  _SavingsPageState createState() => new _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  void _navigate() async {
    widget.pageController.animateToPage(0,
        curve: Curves.linear, duration: new Duration(milliseconds: 350));
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of(context);
    var loc = PiggyLocalizations.of(context);
    return new Scaffold(
        body: Container(
            child: new Center(
                child: new Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(loc.trans("how_much_i_earned"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.headline2)),
              Text(
                loc.trans("check_savings"),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        new Container(
          child: new Column(
            children: <Widget>[
              new Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).primaryColorDark,
                  ),
                  child: new Center(
                      child: new Text(
                    "${store.state.user.saving.toInt()} \$",
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).primaryColorDark,
                  ),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Text(
                          loc.trans("collecting_since"),
                          style: TextStyle(color: Colors.white),
                        ),
                        new Text(
                          "${store.state.user.created.year}.${store.state.user.created.month}.${store.state.user.created.day}",
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        loc.trans("congratulations"),
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    new Text(loc.trans("piggy_happy"))
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: PiggyButton(
                      text: loc.trans("feed_piggy"), onClick: _navigate))
            ],
          ),
        )
      ],
    ))));
  }
}
