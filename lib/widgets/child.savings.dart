import 'package:flutter/material.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:redux/redux.dart';

import 'piggy.saving.types.dart';

class ChildSavingsWidget extends StatefulWidget {
  const ChildSavingsWidget({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  _ChildSavingsWidgetState createState() => _ChildSavingsWidgetState();
}

class _ChildSavingsWidgetState extends State<ChildSavingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SavingForWidget(store: widget.store),
    );
  }
}