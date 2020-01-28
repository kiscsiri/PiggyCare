import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/child.savings.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.slider.dart';

import 'package:redux/redux.dart';

class ChildSavingScreen extends StatefulWidget {
  const ChildSavingScreen({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  _ChildSavingScreenState createState() => _ChildSavingScreenState();
}

class _ChildSavingScreenState extends State<ChildSavingScreen> {
  var savingPerFeed = 0;

  @override
  void initState() {
    savingPerFeed = widget.store.state.user.feedPerPeriod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: widget.store.state.user.userType == UserType.child
                ? piggyBackgroundDecoration(context, UserType.adult)
                : piggyChildBackgroundDecoration(context),
          ),
        ],
      ),
      Container(
        height: MediaQuery.of(context).size.height * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Megtakarítások",
                    style: Theme.of(context).textTheme.display2,
                  ),
                ),
                Text(
                  "Válassz malacperselyt!",
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
            ChildSavingsWidget(
              store: widget.store,
            ),
            Column(
              children: <Widget>[
                Opacity(
                  opacity: 0.9,
                  child: Container(
                      color: Colors.grey[300],
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${savingPerFeed} \$ = 1 ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Image.asset('assets/images/coin.png')
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: widget.store.state.user.userType == UserType.child
                      ? Container()
                      : PiggySlider(
                          maxMinTextTrailing: Text(
                            '€',
                          ),
                          maxVal: 10.toDouble(),
                          onChange: (val) {
                            setState(() {
                              savingPerFeed = val.toInt();
                            });
                          },
                          value: savingPerFeed.toDouble(),
                        ),
                ),
              ],
            ),
            PiggyButton(
              text: "MALACPERSELY LÉTREHOZÁSA",
              disabled: false,
              onClick: () async =>
                  await showCreatePiggyModal(context, widget.store),
            )
          ],
        ),
      )
    ]);
  }
}
