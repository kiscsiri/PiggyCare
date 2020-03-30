import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Text(
          "Szia " + store.state.user.name + "!",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          PiggyButton(
            text: "NÉZZÜK MEG",
            onClick: () => Navigator.pop(context),
          )
        ],
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/notification.png'),
            Text(
              "Kaptál egy új feladatot!",
            ),
          ],
        )),
  );
}

Future<bool> showChildrenNewPiggy(BuildContext context, String name,
    String targetName, int targetPrice) async {
  var store = StoreProvider.of<AppState>(context);
  var loc = PiggyLocalizations.of(context);

  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Text(
          (name ?? "A gyereked") + " új malacperselyt készített!",
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
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Cél: " + targetName,
                ),
                Text(
                  "Öszzeg: " + targetPrice.toString(),
                ),
              ],
            ),
            Column(
              children: <Widget>[Text("Jóváhagyod a megtakarítási célt?")],
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
          "Szuper!",
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
                  "Az alábbi malacperselybe már el is kezdheted a gyűjtést:",
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
                      "Cél: " + piggy.item,
                    ),
                    Text(
                      "Öszzeg: " + piggy.targetPrice.toString(),
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
              name + " egy új feladatot kért",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "Adsz neki egyet?",
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
              "Biztosan duplázni akarsz?",
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
              "Biztos vagy benne, hogy befejezted a feladatod?",
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

Future<bool> showRequestSent(BuildContext context) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        vPadding: 0,
        title: Column(
          children: <Widget>[
            Text(
              "Sikeres felkérés!",
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
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Text(
                    "Amikor visszaigazolja a kérelmet, látni fogod a gyerek megtakarításait és különböző feladatokat is adhatsz neki.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  )),
            ),
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
                  (name ?? "") + " elkészült a feladatával.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 26),
                ),
              ),
            ],
          ),
          actions: [
            PiggyButton(
              text: "IGEN",
              onClick: () => Navigator.of(context).pop(true),
            ),
            PiggyButton(
              text: "NEM",
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
                  "Jóváhagyták, hogy kész a feladatod!",
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
                  "Siker!",
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
                  "Elutasították hogy elkészült a feladatod!",
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
