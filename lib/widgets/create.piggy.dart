import 'package:flutter/material.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/services/piggy.firebase.services.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';

import 'piggy.slider.dart';

class CreatePiggyWidget extends StatefulWidget {
  CreatePiggyWidget(
      {Key key, this.store, this.navigateToPiggyWidget, this.childId})
      : super(key: key);

  final Function navigateToPiggyWidget;
  final Store<AppState> store;
  final String childId;

  @override
  _CreatePiggyWidgetState createState() => new _CreatePiggyWidgetState();
}

class _CreatePiggyWidgetState extends State<CreatePiggyWidget> {
  var item = "";
  double targetMoney = 1;
  double moneyPerFeed = 2;
  var controller = TextEditingController();

  Future _createPiggy() async {
    var action = CreateTempPiggy(
        piggy: Piggy(
      currentFeedAmount: 1,
      currentSaving: 0,
      doubleUp: false,
      isAproved: false,
      isFeedAvailable: true,
      item: controller.text,
      userId: widget.childId ?? widget.store.state.user.id,
      money: 0,
      targetPrice: targetMoney.round(),
      piggyLevel: PiggyLevel.Baby,
    ));

    widget.store.dispatch(action);

    var add = AddPiggy(widget.store.state.tempPiggy);
    widget.store.dispatch(add);

    await PiggyServices.createPiggyForUser(
        action.piggy, widget.childId ?? widget.store.state.user.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(
              loc.trans("create_money_box"),
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            PiggyInput(
              hintText: loc.trans('what_do_you_saving'),
              textController: controller,
              width: MediaQuery.of(context).size.width,
              onValidate: (val) {
                setState(() {
                  item = val;
                });
                return null;
              },
            ),
            Column(
              children: <Widget>[
                Text(
                  loc.trans(
                    'how_much_it_cost',
                  ),
                  textAlign: TextAlign.center,
                ),
                PiggySlider(
                  maxMinTextTrailing: Text("€"),
                  value: targetMoney,
                  maxVal: 1000,
                  onChange: (val) {
                    setState(() {
                      targetMoney = val;
                    });
                  },
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  loc.trans('how_much_per_feed_question'),
                  textAlign: TextAlign.center,
                ),
                PiggySlider(
                  maxMinTextTrailing: Text("€"),
                  value: moneyPerFeed,
                  maxVal: 10,
                  onChange: (val) {
                    setState(() {
                      moneyPerFeed = val;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: PiggyButton(
                text: loc.trans('create_money_box'),
                onClick: () async => await _createPiggy(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
