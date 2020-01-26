import 'package:flutter/material.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/child.savings.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Savings",
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
              Text("Choose a money box", style: Theme.of(context).textTheme.subtitle,),
            ],
          ),
          ChildSavingsWidget(
            store: widget.store,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: PiggySlider(
                maxMinTextTrailing: Text('%'),
                
                value: widget.store.state.user.feedPerPeriod.toDouble(),
            ),
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
