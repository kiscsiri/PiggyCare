import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/services/notification.modals.dart';
import 'package:piggybanx/services/notification.services.dart';
import 'package:piggybanx/widgets/chores.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:redux/redux.dart';

class ChildChoresPage extends StatefulWidget {
  ChildChoresPage({Key key}) : super(key: key);

  @override
  _ChoresPageState createState() => new _ChoresPageState();
}

class _ChoresPageState extends State<ChildChoresPage> {
  Widget _getFinishedChores(AppState state) {
    var finishedChores = state.user.chores
        .where((element) => element.isDone && element.isValidated)
        .toList();
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
                Image.asset('assets/images/yellow_tick.png', scale: 3.5)
              ],
            ),
          )
          .toList();
    } else {
      result = [Text("Nincs befejezett feladatod :(")];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: result,
    );
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return ListView(children: <Widget>[
      Stack(children: [
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
              ChoresWidget(),
              PiggyButton(
                text: "DUPLÁZÁS",
                disabled: false,
                onClick: () async {
                  var user = store.state.user;
                  if (user.parentId != null) {
                    if (await showChildrenAskDoubleSubmit(context) ?? false) {
                      NotificationServices.sendNotificationDouble(
                          store.state.user.parentId,
                          store.state.user.name,
                          store.state.user.id);
                    }
                  }
                },
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
                  child: StoreConnector<AppState, AppState>(
                      converter: (store) => store.state,
                      builder: (context, state) => _getFinishedChores(state)),
                ),
              )
            ],
          )),
        ),
      ])
    ]);
  }
}
