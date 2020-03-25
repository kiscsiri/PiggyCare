import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/services/piggy.firebase.services.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:piggybanx/widgets/piggy.modal.widget.dart';
import 'package:redux/redux.dart';

import 'piggy.slider.dart';

class CreatePiggyWidget extends StatefulWidget {
  CreatePiggyWidget({Key key, this.navigateToPiggyWidget, this.childId})
      : super(key: key);

  final Function navigateToPiggyWidget;
  final String childId;

  @override
  _CreatePiggyWidgetState createState() => new _CreatePiggyWidgetState();
}

class _CreatePiggyWidgetState extends State<CreatePiggyWidget> {
  var item = "";
  double targetMoney = 1;
  double moneyPerFeed = 2;
  var controller = TextEditingController();
  var priceController = TextEditingController();
  final _createPiggyFormKey = new GlobalKey<FormState>();

  Future _createPiggy(Store<AppState> store) async {
    if (_createPiggyFormKey.currentState.validate()) {
      var action = CreateTempPiggy(
          piggy: Piggy(
        currentSaving: 0,
        doubleUp: false,
        isAproved: false,
        isFeedAvailable: true,
        item: controller.text,
        userId: widget.childId ?? store.state.user.id,
        money: 0,
        targetPrice: int.tryParse(priceController.text).round(),
        piggyLevel: PiggyLevel.Baby,
      ));

      store.dispatch(action);

      var add = AddPiggy(store.state.tempPiggy);
      store.dispatch(add);

      await PiggyServices.createPiggyForUser(
          action.piggy, widget.childId ?? store.state.user.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var store = StoreProvider.of<AppState>(context);
    return PiggyModal(
        vPadding: 0,
        title: new Text(
          loc.trans("create_money_box"),
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: _createPiggyFormKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        loc.trans(
                          'how_much_it_cost',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    PiggySlider(
                      maxMinTextTrailing: Text("€"),
                      value: double.tryParse(priceController.text) ?? 0,
                      maxVal: 1000,
                      onChange: (val) {
                        setState(() {
                          priceController.text = val.toInt().toString();
                          targetMoney = val;
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text(
                          "Vagy add meg kézzel",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      PiggyInput(
                        hintText: "Értéke",
                        textController: priceController,
                        onValidate: (val) {
                          if (int.tryParse(val) == null) {
                            return "Kérlek számot adj meg!";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: PiggyButton(
              text: loc.trans('create_money_box'),
              onClick: () async => await _createPiggy(store),
            ),
          )
        ]);
  }
}
