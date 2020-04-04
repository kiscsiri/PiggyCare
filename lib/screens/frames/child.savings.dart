import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/models/user/user.export.dart';
import 'package:piggycare/services/piggy.page.services.dart';
import 'package:piggycare/widgets/piggy.saving.types.dart';
import 'package:piggycare/widgets/piggy.widgets.export.dart';

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
    var reducerStore = StoreProvider.of<AppState>(context);
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
      StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, store) => Container(
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
              SavingForListWidget(
                savingPerFeed: store.user.feedPerPeriod,
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
                              '${store.user.feedPerPeriod} € = 1 ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Image.asset('assets/images/coin.png')
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: store.user.userType == UserType.donator
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
                              reducerStore.dispatch(UpdateUserData(UserData(
                                  period: store.user.period,
                                  feedPerPeriod: val.toInt())));
                            },
                            value: store.user.feedPerPeriod.toDouble(),
                          ),
                  ),
                ],
              ),
              PiggyButton(
                  text: "MALACPERSELY LÉTREHOZÁSA",
                  disabled: false,
                  onClick: () async {
                    await showCreatePiggyModal(context);
                    setState(() {});
                  })
            ],
          ),
        ),
      )
    ]);
  }
}
