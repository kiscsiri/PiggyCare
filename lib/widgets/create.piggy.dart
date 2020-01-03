import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/services/piggy.firebase.services.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:redux/redux.dart';

import 'piggy.saving.types.dart';

class CreatePiggyWidget extends StatefulWidget {
  CreatePiggyWidget({Key key, this.store, this.navigateToPiggyWidget})
      : super(key: key);

  final Function navigateToPiggyWidget;
  final Store<AppState> store;

  @override
  _CreatePiggyWidgetState createState() => new _CreatePiggyWidgetState();
}

class _CreatePiggyWidgetState extends State<CreatePiggyWidget> {
  Future _createPiggy() async {
    var action = AddPiggy(widget.store.state.tempPiggy);
    widget.store.dispatch(action);

    await PiggyServices.createPiggyForUser(
        action.piggy, widget.store.state.user.id);
    widget.navigateToPiggyWidget();
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(bottom: 30.0, top: 30.0),
                child: new Text(
                  loc.trans("your_money_boxes"),
                  style: Theme.of(context).textTheme.display3,
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: const EdgeInsets.only(bottom: 30.0, top: 30.0),
                child: new Text(
                  loc.trans("choose_money_box"),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0, top: 30.0),
              child: SavingForWidget(
                store: widget.store,
              ),
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
