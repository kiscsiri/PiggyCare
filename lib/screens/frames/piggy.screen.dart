import 'package:flutter/material.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/widgets/kid.piggy.dart';
import 'package:redux/redux.dart';

class PiggyPage extends StatefulWidget {
  PiggyPage({Key key, this.title, this.store}) : super(key: key);

  final String title;
  final Store<AppState> store;

  @override
  _PiggyPageState createState() => new _PiggyPageState();
}

class _PiggyPageState extends State<PiggyPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: KidPiggyWidget(
      store: widget.store,
    ));
  }
}
