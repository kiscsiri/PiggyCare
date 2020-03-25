import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/child.savings.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.modal.widget.dart';
import 'package:piggybanx/widgets/piggy.slider.dart';

class ChildSavingScreen extends StatefulWidget {
  ChildSavingScreen({Key key, @required this.initFeedPerPeriod})
      : super(key: key);
  final int initFeedPerPeriod;

  @override
  _ChildSavingScreenState createState() => _ChildSavingScreenState();
}

class _ChildSavingScreenState extends State<ChildSavingScreen> {
  var savingPerFeed = 0;

  @override
  void initState() {
    savingPerFeed = widget.initFeedPerPeriod;
    super.initState();
  }

  Future<bool> showChildrenAskDoubleSubmit(BuildContext context) async {
    var loc = PiggyLocalizations.of(context);
    return await showDialog<bool>(
      context: context,
      builder: (context) => PiggyModal(
          title: Column(
            children: <Widget>[
              Text(
                loc.trans('wants_to_double_ask'),
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            PiggyButton(
              text: loc.trans('yes'),
              onClick: () => Navigator.of(context).pop(true),
            ),
            PiggyButton(
              text: loc.trans('no'),
              onClick: () => Navigator.of(context).pop(false),
            )
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var loc = PiggyLocalizations.of(context);
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: piggyBusinessBackgroundDecoration(context),
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
                    loc.trans('savings'),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Text(
                  loc.trans('choose_money_box'),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
            ChildSavingsWidget(
              savingPerFeed: savingPerFeed,
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
                            '$savingPerFeed € = 1 ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Image.asset('assets/images/coin.png')
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: store.state.user.userType == UserType.child
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
                          onChangeEnding: (val) async {
                            store.dispatch(UpdateUserData(UserData(
                                period: store.state.user.period,
                                feedPerPeriod: val.toInt())));
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
                onClick: () async {
                  await showCreatePiggyModal(context, store);
                  setState(() {});
                })
          ],
        ),
      )
    ]);
  }
}
