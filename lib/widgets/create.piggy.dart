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
  CreatePiggyWidget({Key key, this.store, this.navigateToPiggyWidget})
      : super(key: key);

  final Function navigateToPiggyWidget;
  final Store<AppState> store;

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
      money: 0,
      targetPrice: targetMoney.round(),
      piggyLevel: PiggyLevel.Baby,
    ));

    widget.store.dispatch(action);

    var add = AddPiggy(widget.store.state.tempPiggy);
    widget.store.dispatch(add);

    await PiggyServices.createPiggyForUser(
        action.piggy, widget.store.state.user.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text(
              loc.trans("create_money_box"),
              style: Theme.of(context).textTheme.display4,
              textAlign: TextAlign.center,
            ),
            new Text(
              "You can create your first money box!",
              textAlign: TextAlign.center,
            ),
            PiggyInput(
              hintText: "What do you saving for?",
              textController: controller,
              width: MediaQuery.of(context).size.width,
              onValidate: (val) {
                setState(() {
                  item = val;
                });
              },
            ),
            Text("How much money do you want to save?"),
            PiggySlider(
              maxMinTextTrailing: Text("s"),
              value: targetMoney,
              onChange: (val) {
                setState(() {
                  targetMoney = val;
                });
              },
            ),
            Text('How muck money do you want to spendat one feeding?'),
            PiggySlider(
              maxMinTextTrailing: Text("s"),
              value: moneyPerFeed,
              onChange: (val) {
                setState(() {
                  moneyPerFeed = val;
                });
              },
            ),
            PiggyButton(
              text: loc.trans('create_money_box'),
              onClick: () async => await _createPiggy(),
            )
          ],
        ),
      ),
    );
  }
}
