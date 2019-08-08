import 'package:flutter/material.dart';
import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.model.dart';
import 'package:piggybanx/services/notification-update.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:redux/redux.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title, this.store}) : super(key: key);

  final String title;

  final Store<AppState> store;

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Period _period;
  int _feedPerPeriod;

  _saveUserSettings(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var updatedUser =
        new UserData(feedPerPeriod: _feedPerPeriod, period: _period);

    NotificationUpdate.updateSettings(_period, widget.store.state.user.id);
    widget.store.dispatch(UpdateUserData(updatedUser));
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(loc.trans("settings_saved_snackbar")),
        ],
      ));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _period = widget.store.state.user.period;
    _feedPerPeriod = widget.store.state.user.feedPerPeriod;
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    final boxHeight = MediaQuery.of(context).size.height * 0.2;
    return new Scaffold(
      body: new Container(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Container(
            height: boxHeight,
            child: Center(
                child: new Text(loc.trans("feeding_settings"),
                    style: Theme.of(context).textTheme.display2)),
          ),
          new ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: double.infinity, maxHeight: double.infinity),
            child: Column(
              children: <Widget>[
                new Container(
                  height: boxHeight,
                  color: Color(0xfff3f3f3),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 3, horizontal: 10.0),
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
                                    loc.trans("feed_piggy_with_this_amount"),
                                    style: 
                                    new TextStyle(
                                      fontSize: 12
                                    ),
                                  ),
                                  new Text(
                                    " $_feedPerPeriod \$",
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
                              min: 1,
                              max: 10,
                              activeColor: Theme.of(context).primaryColor,
                              value: _feedPerPeriod.toDouble(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text('1 \$',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .display4),
                                  new Text("10 \$",
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
            height: boxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(loc.trans("piggy_feed_period")),
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
                            child: new Text(loc.trans("demo")),
                          ),
                          value: Period.demo,
                        ),
                        new DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 20),
                            child: new Text(loc.trans("daily")),
                          ),
                          value: Period.daily,
                        ),
                        new DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 20),
                            child: new Text(loc.trans("weekly")),
                          ),
                          value: Period.weely,
                        ),
                        new DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 20),
                            child: new Text(loc.trans("monthly")),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: new PiggyButton(
              text: loc.trans("save_settings"),
              onClick: () async {
                _saveUserSettings(context);
              },
            ),
          )
        ],
      )),
    );
  }
}
