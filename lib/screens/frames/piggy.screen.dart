import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/widgets/kid.piggy.dart';

class PiggyPage extends StatefulWidget {
  PiggyPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PiggyPageState createState() => new _PiggyPageState();
}

class _PiggyPageState extends State<PiggyPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);

    return new Scaffold(
        body: KidPiggyWidget(
      initialPiggy: store.state.user.piggies
                  .where((element) => element.isApproved ?? false)
                  .length !=
              0
          ? store.state.user.piggies
              .where((element) => element.isApproved ?? false)
              .first
          : null,
      timeUntilNextFeed: store.state.user.timeUntilNextFeed,
    ));
  }
}
