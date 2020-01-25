import 'package:flutter/material.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/child.savings.dart';
import 'package:piggybanx/widgets/piggy.button.dart';

import 'package:redux/redux.dart';

class ChildSavingScreen extends StatefulWidget {
  const ChildSavingScreen({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  _ChildSavingScreenState createState() => _ChildSavingScreenState();
}

class _ChildSavingScreenState extends State<ChildSavingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Savings"),
          Text("Choose a money box"),
          ChildSavingsWidget(
            store: widget.store,
          ),
          Slider(
            value: widget.store.state.user.feedPerPeriod.toDouble(),
            onChanged: (val) {},
            min: 0,
            max: 10,
          ),
          PiggyButton(
            text: "Create",
            disabled: false,
            onClick: () async =>
                await showCreatePiggyModal(context, widget.store),
          )
        ],
      ),
    );
  }
}
