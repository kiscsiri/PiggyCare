import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/widgets/chores.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:redux/redux.dart';

class ChildChoresPage extends StatefulWidget {
  ChildChoresPage({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  _ChoresPageState createState() => new _ChoresPageState();
}

class _ChoresPageState extends State<ChildChoresPage> {
  Widget _getFinishedChores() {
    var finishedChores =
        widget.store.state.user.chores.where((element) => element.isDone);
    int i = 1;

    var result;

    if (finishedChores.length != 0) {
      result = finishedChores
          .map(
            (e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('${i++}.  '),
                    Text(e.title),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/yellow_tick.png')
                  ],
                )
              ],
            ),
          )
          .toList();
    } else {
      result = Text("Nincs befejezett feladatod :(");
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[result],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: piggyBackgroundDecoration(context, UserType.adult),
          ),
        ],
      ),
      Container(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text('Elvégzendő feladatok',
                style: Theme.of(context).textTheme.headline3),
            ChoresWidget(store: widget.store),
            PiggyButton(
              text: "DUPLÁZÁS",
              disabled: false,
              onClick: () {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Elvégzett feladatok",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Image.asset('assets/images/pink_tick.png')
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Center(
                child: _getFinishedChores(),
              ),
            )
          ],
        )),
      )
    ]);
  }
}
