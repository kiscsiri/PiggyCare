import 'package:app_review/app_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/Enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.modal.widget.dart';

Future<bool> showAskedForNewTask(
    BuildContext context, String name, String id) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Column(
          children: <Widget>[
            Text(
              name + " ${loc.trans('request_new_task')}",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          PiggyButton(
            text: loc.trans('sure'),
            onClick: () => Navigator.of(context).pop(true),
          )
        ]),
  );
}

Future<bool> showChildrenNewTask(BuildContext context, String name) async {
  var store = StoreProvider.of<AppState>(context);
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Text(
          loc.trans('hi') + store.state.user.name + "!",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          PiggyButton(
            text: loc.trans('let_s_check'),
            onClick: () => Navigator.pop(context),
          )
        ],
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/notification.png'),
            Text(
              loc.trans('new_task'),
            ),
          ],
        )),
  );
}

Future<bool> showChildrenPiggyInfo(BuildContext context) async {
  var loc = PiggyLocalizations.of(context);

  return await showDialog<bool>(
      context: context,
      builder: (context) => PiggyModal(
          title: Text(
            loc.trans('ready'),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            PiggyButton(
              text: loc.trans('sure'),
              onClick: () => Navigator.of(context).pop(true),
            ),
          ],
          content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  loc.trans('parent_validate_info'),
                  textAlign: TextAlign.center,
                ),
              ])));
}

Future<bool> showAppRate(BuildContext context) async {
  var loc = PiggyLocalizations.of(context);

  return await showDialog<bool>(
      context: context,
      builder: (context) => PiggyModal(
              actions: <Widget>[
                PiggyButton(
                  text: loc.trans('sure'),
                  onClick: () async {
                    await AppReview.requestReview;
                    Navigator.of(context).pop(false);
                  },
                ),
                PiggyButton(
                  text: loc.trans('not_now'),
                  onClick: () => Navigator.of(context).pop(false),
                ),
              ],
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      loc.trans('demo_over_info'),
                      textAlign: TextAlign.center,
                    ),
                  ])));
}

Future<bool> showChildrenNewPiggy(BuildContext context, String name,
    String targetName, int targetPrice) async {
  var store = StoreProvider.of<AppState>(context);
  var loc = PiggyLocalizations.of(context);

  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Text(
          (name ?? "${loc.trans('your_child')}") + "${loc.trans('new_piggy')}",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          PiggyButton(
            text: loc.trans('yes'),
            onClick: () => Navigator.of(context).pop(true),
          ),
          PiggyButton(
            text: loc.trans('no'),
            onClick: () => Navigator.of(context).pop(false),
          )
        ],
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${loc.trans('target')} " + targetName,
                  textAlign: TextAlign.left,
                ),
                Text(
                  "${loc.trans('sum')} " + targetPrice.toString() + ' €',
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Column(
              children: <Widget>[Text(loc.trans('ask_validate_saving'))],
            )
          ],
        )),
  );
}

Future<bool> showChildrenAcceptedPiggy(
    BuildContext context, int piggyId) async {
  var store = StoreProvider.of<AppState>(context);
  var loc = PiggyLocalizations.of(context);
  var piggy =
      store.state.user.piggies.singleWhere((element) => element.id == piggyId);

  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Text(
          loc.trans('super'),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          PiggyButton(
            text: loc.trans('sure'),
            onClick: () => Navigator.of(context).pop(true),
          ),
        ],
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  loc.trans('you_can_start_saving_in_this'),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${loc.trans('target')} " + piggy.item,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "${loc.trans('sum')} " +
                          piggy.targetPrice.toString() +
                          " €",
                      textAlign: TextAlign.start,
                    ),
                  ],
                ))
          ],
        )),
  );
}

Future<bool> showChildrenDouble(BuildContext context, String name) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Column(
          children: <Widget>[
            Text(
              name + " ${loc.trans('asked_for_new_task')}",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "${loc.trans('will_you_give_him_task_ask')}",
                style: Theme.of(context).textTheme.headline2,
              ),
            )
          ],
        ),
        actions: <Widget>[
          PiggyButton(
            text: loc.trans("yes"),
            onClick: () => Navigator.of(context).pop(true),
          ),
          PiggyButton(
            text: loc.trans("no"),
            onClick: () => Navigator.of(context).pop(false),
          )
        ]),
  );
}

Future<bool> showChildrenAskDoubleSubmit(BuildContext context) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Column(
          children: <Widget>[
            Text(
              loc.trans('sure_you_want_to_double'),
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          PiggyButton(
            text: loc.trans('yes'),
            onClick: () => Navigator.of(context).pop(true),
          ),
          PiggyButton(
            text: loc.trans('no'),
            onClick: () => Navigator.of(context).pop(false),
          )
        ]),
  );
}

Future<bool> showChildrenFinishTaskSubmit(BuildContext context) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Column(
          children: <Widget>[
            Text(
              loc.trans('sure_you_want_to_finish'),
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          PiggyButton(
            text: loc.trans('yes'),
            onClick: () => Navigator.of(context).pop(true),
          ),
          PiggyButton(
            text: loc.trans('no'),
            onClick: () => Navigator.of(context).pop(false),
          )
        ]),
  );
}

Future<bool> showRequestSent(BuildContext context, UserType userType) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        vPadding: 0,
        title: Column(
          children: <Widget>[
            Text(
              loc.trans('succesful_request'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/yellow_tick.png',
              scale: 1.4,
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(loc.trans('request_sent'))),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: userType == UserType.adult
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Text(
                          loc.trans('parent_request_info'),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ))
                    : Container()),
          ],
        ),
        actions: <Widget>[
          PiggyButton(
            text: "OK",
            onClick: () => Navigator.of(context).pop(true),
          ),
        ]),
  );
}

Future<bool> showCompletedTask(BuildContext context, String name) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PiggyModal(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset("assets/images/yellow_tick.png", scale: 1.5),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  (name ?? "") + " ${loc.trans('finished_hist_task')}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 26),
                ),
              ),
            ],
          ),
          actions: [
            PiggyButton(
              text: loc.trans('yes'),
              onClick: () => Navigator.of(context).pop(true),
            ),
            PiggyButton(
              text: loc.trans('no'),
              onClick: () => Navigator.of(context).pop(false),
            )
          ],
          content: Center(
            child: Column(
              children: <Widget>[
                Text(loc.trans('validate_ask')),
              ],
            ),
          ),
        );
      });
}

Future<bool> showValidatedTask(BuildContext context, String name) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PiggyModal(
          vPadding: MediaQuery.of(context).size.height * 0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset("assets/images/yellow_tick.png", scale: 1.3),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, right: 0, left: 0),
                child: Text(
                  loc.trans('validated_task'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            PiggyButton(
              text: "OK",
              onClick: () => Navigator.of(context).pop(true),
            )
          ],
          content: Center(
            child: Column(
              children: <Widget>[
                Text(loc.trans('collect_double')),
              ],
            ),
          ),
        );
      });
}

Future<bool> showFriendRequestAccepted(
    BuildContext context, String name) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PiggyModal(
          vPadding: MediaQuery.of(context).size.height * 0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset("assets/images/yellow_tick.png", scale: 1.3),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, right: 0, left: 0),
                child: Text(
                  loc.trans('success'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            PiggyButton(
              text: "OK",
              onClick: () => Navigator.of(context).pop(true),
            )
          ],
          content: Center(
            child: Column(
              children: <Widget>[
                Text(name + loc.trans('friend_accepted')),
              ],
            ),
          ),
        );
      });
}

Future<void> showRefusedTask(BuildContext context, String name) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PiggyModal(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset("assets/images/yellow_tick.png", scale: 1),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  loc.trans('task_refused'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            PiggyButton(
              text: "OK",
              onClick: () => Navigator.of(context).pop(true),
            )
          ],
          content: Center(
            child: Column(
              children: <Widget>[
                Text(loc.trans('ask_about_the_problem')),
              ],
            ),
          ),
        );
      });
}
