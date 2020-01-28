import 'package:flutter/material.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/services/piggy.firebase.services.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';

import 'piggy.slider.dart';

class AddChildWidget extends StatefulWidget {
  AddChildWidget({Key key, this.store, this.navigateToPiggyWidget})
      : super(key: key);

  final Function navigateToPiggyWidget;
  final Store<AppState> store;

  @override
  _AddChildWidgetState createState() => new _AddChildWidgetState();
}

class _AddChildWidgetState extends State<AddChildWidget> {
  var name = "";
  double feedPerDay = 1;

  var controller = TextEditingController();
  Future _createPiggy() async {
    // var action = CreateTempPiggy(
    //     piggy: Piggy(
    //   currentFeedAmount: 1,
    //   currentSaving: 0,
    //   doubleUp: false,
    //   isAproved: false,
    //   isFeedAvailable: true,
    //   item: controller.text,
    //   money: 0,
    //   targetPrice: targetMoney.round(),
    //   piggyLevel: PiggyLevel.Baby,
    // ));

    // widget.store.dispatch(action);

    // var add = AddPiggy(widget.store.state.tempPiggy);
    // widget.store.dispatch(add);

    // await PiggyServices.createPiggyForUser(
    //     action.piggy, widget.store.state.user.id);
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
              '+ Add meg a gyereked',
              style: Theme.of(context).textTheme.display2,
              textAlign: TextAlign.center,
            ),
            new Text(
              'Hozzáadhatod a gyereked',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            PiggyInput(
              hintText: "Gyerek neve",
              textController: controller,
              width: MediaQuery.of(context).size.width,
              onValidate: (val) {
                setState(() {
                  name = val;
                });
              },
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
                            '${feedPerDay} \$ = 1 ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Image.asset('assets/images/coin.png')
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: PiggySlider(
                    maxMinTextTrailing: Text(
                      '\$',
                    ),
                    onChange: (val) {
                      setState(() {
                        feedPerDay = val;
                      });
                    },
                    value: feedPerDay.toDouble(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: PiggyButton(
                text: loc.trans("GYEREK HOZZÁADÁS"),
                onClick: () async => await _createPiggy(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
