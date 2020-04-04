import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/models/user/user.export.dart';
import 'package:piggycare/services/notification.modals.dart';
import 'package:piggycare/services/notification.services.dart';
import 'package:piggycare/services/user.services.dart';
import 'package:piggycare/services/piggy.page.services.dart';
import 'package:piggycare/widgets/piggy.widgets.export.dart';

class ChildChoresPage extends StatefulWidget {
  ChildChoresPage({Key key}) : super(key: key);

  @override
  _ChoresPageState createState() => new _ChoresPageState();
}

class _ChoresPageState extends State<ChildChoresPage> {
  Widget _getFinishedChores(AppState state) {
    var loc = PiggyLocalizations.of(context);
    var finishedChores = state.user.chores
        .where((d) => d.finishedDate != null)
        .where((element) => element.isDone && element.isValidated)
        .toList();
    int i = 1;
    var result;

    finishedChores.toList().sort((a, b) {
      return a.finishedDate.compareTo(b.finishedDate);
    });

    if (finishedChores.length != 0) {
      result = finishedChores.reversed
          .take(3)
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
      result = [Text(loc.trans('no_finished_task'))];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: result,
    );
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var store = StoreProvider.of<AppState>(context);
    return ListView(children: <Widget>[
      Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: piggyBackgroundDecoration(context),
            ),
          ],
        ),
        Container(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(loc.trans('active_tasks'),
                  style: Theme.of(context).textTheme.headline3),
              ChoresWidget(),
              PiggyButton(
                text: loc.trans('lets_double'),
                disabled: store.state.user.chores
                        .where((element) =>
                            !element.isValidated && !element.isDone)
                        .length >=
                    3,
                onClick: () async {
                  var user = store.state.user;
                  if (user.wantToSeeInfoAgain ?? true) {
                    var isNotShownAgainChecked =
                        await showDoubleInformationModel(context);
                    store.dispatch(
                        SetSeenDoubleInfo(!(isNotShownAgainChecked ?? false)));
                    await UserServices.setDoubleInformationSeen(
                        user.documentId, !(isNotShownAgainChecked ?? false));
                  }
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
                    loc.trans('finished_tasks'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04),
                    child: Image.asset('assets/images/pink_tick.png'),
                  )
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
