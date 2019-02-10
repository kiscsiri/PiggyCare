import 'package:flutter/material.dart';
import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/models/user.redux.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:redux/redux.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title, this.store}) : super(key: key);

  final String title;

  final Store<UserData> store;

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Period _period;
  int _feedPerPeriod;

  _saveUserSettings() {
    var updatedUser = new UserData(
      feedPerPeriod: _feedPerPeriod,
      period: _period
    );
    widget.store.dispatch(UpdateUserData(updatedUser));
  }

  @override
  void initState() {
    super.initState();
    _period = widget.store.state.period;
    _feedPerPeriod = widget.store.state.feedPerPeriod;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Container(
            child: Center(
                child: new Text("FEEDING SETTINGS",
                    style: Theme.of(context).textTheme.display2)),
          ),
          new ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: double.infinity, maxHeight: double.infinity),
            child: Column(
              children: <Widget>[
                new Container(
                  color: Color(0xfff3f3f3),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 60, horizontal: 10.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                  ),
                                  new Text(
                                    "I want to feed Piggy with this amount: ",
                                    style: Theme.of(context).textTheme.display4,
                                  ),
                                  new Text(
                                    "$_feedPerPeriod \$",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .display3,
                                  )
                                ],
                              ),
                            ),
                            new Slider(
                              onChanged: (value) {
                                setState(() {
                                  _feedPerPeriod = value.toInt();
                                });
                              },
                              min: 0,
                              max: 10000,
                              value: _feedPerPeriod.toDouble(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text('0 \$',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .display4),
                                  new Text("10 000 \$",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .display4)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          new Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text("I want to feed Piggy in this period:"),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: new BoxDecoration(
                      border: Border.all(width: 1.0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(3.0)),
                  child: new DropdownButtonHideUnderline(
                    child: new DropdownButton(
                      onChanged: (value) {
                        setState(() {
                         _period = value; 
                        });
                      },
                      value: _period,
                      items: [
                        new DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 20),
                            child: new Text("Daily"),
                          ),
                          value: Period.daily,
                        ),
                        new DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 20),
                            child: new Text("Weekly"),
                          ),
                          value: Period.weely,
                        ),
                        new DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 20),
                            child: new Text("Monthly"),
                          ),
                          value: Period.monthly,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          new PiggyButton(
            text: "SAVE SETTINGS",
            onClick: () async {_saveUserSettings();},
          )
        ],
      )),
    );
  }
}
