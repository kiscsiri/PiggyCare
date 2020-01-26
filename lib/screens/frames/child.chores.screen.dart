import 'package:flutter/material.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/widgets/child.savings.dart';
import 'package:piggybanx/widgets/chores.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.saving.types.dart';
import 'package:redux/redux.dart';

class ChildChoresPage extends StatefulWidget {
  ChildChoresPage({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  _ChoresPageState createState() => new _ChoresPageState();
}

class _ChoresPageState extends State<ChildChoresPage> {
  List<Widget> _getFinishedChores() {
    int i = 1;
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${i++}.  '),
              Text('Do the shopping'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Image.asset('assets/images/yellow_tick.png')],
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${i++}.  '),
              Text('Do the shopping'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Image.asset('assets/images/yellow_tick.png')],
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${i++}.  '),
              Text('Do the shopping'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Image.asset('assets/images/yellow_tick.png')],
          )
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Text('Active Tasks', style: Theme.of(context).textTheme.display2),
        ChoresWidget(store: widget.store),
        PiggyButton(
          text: "LET'S DOUBLE",
          disabled: false,
          onClick: () {},
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Finished tasks",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline,
            ),
            Image.asset('assets/images/pink_tick.png')
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _getFinishedChores(),
        )
      ],
    ));
  }
}
