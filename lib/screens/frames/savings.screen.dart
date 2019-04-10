import 'package:flutter/material.dart';
import 'package:piggybanx/models/user.redux.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:redux/redux.dart';

class SavingsPage extends StatefulWidget {
  SavingsPage({Key key, this.title, this.store, this.pageController})
      : super(key: key);

  final String title;
  final Store<UserData> store;
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
                  padding:
                      const EdgeInsets.only(bottom: 8.0),
                  child: new Text("HOW MUCH MONEY I ALREADY EARNED",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.display3)),
              new Text(
                "On this page, you can check out your savings!",
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
                    "${widget.store.state.saving.toInt()} \$",
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
                          "You have been collecting since: ",
                          style: TextStyle(color: Colors.white),
                        ),
                        new Text(
                          "${widget.store.state.created.year}.${widget.store.state.created.month}.${widget.store.state.created.day}",
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
                        "Congratulations!",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    new Text("Piggy is so happy to have you!")
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: PiggyButton(text: "FEED PIGGY!", onClick: _navigate))
            ],
          ),
        )
      ],
    ))));
  }
}
