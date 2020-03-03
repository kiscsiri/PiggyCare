import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.modal.widget.dart';

Future<bool> showAskedForNewTask(
    BuildContext context, String name, String id) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Column(
          children: <Widget>[
            Text(
              name + " asked for a new task",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "Will you give him one?",
                style: Theme.of(context).textTheme.headline2,
              ),
            )
          ],
        ),
        actions: <Widget>[
          PiggyButton(
            text: "YES",
            onClick: () => Navigator.of(context).pop(true),
          ),
          PiggyButton(
            text: "NO",
            onClick: () => Navigator.of(context).pop(false),
          )
        ]),
  );
}

Future<bool> showChildrenNewTask(BuildContext context, String name) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Text(
          "Welcome back " + name + "!",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          PiggyButton(
            text: "LET'S CHECK IT!",
            onClick: () => Navigator.pop(context),
          )
        ],
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/notification.png'),
            Text(
              "You have a new task!",
            ),
          ],
        )),
  );
}

Future<bool> showChildrenDouble(BuildContext context, String name) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Column(
          children: <Widget>[
            Text(
              name + " asked for a new task",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "Will you give him one?",
                style: Theme.of(context).textTheme.headline2,
              ),
            )
          ],
        ),
        actions: <Widget>[
          PiggyButton(
            text: "YES",
            onClick: () => Navigator.of(context).pop(true),
          ),
          PiggyButton(
            text: "NO",
            onClick: () => Navigator.of(context).pop(false),
          )
        ]),
  );
}

Future<bool> showChildrenAskDoubleSubmit(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Column(
          children: <Widget>[
            Text(
              "Are you sure you want to double?",
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          PiggyButton(
            text: "YES",
            onClick: () => Navigator.of(context).pop(true),
          ),
          PiggyButton(
            text: "NO",
            onClick: () => Navigator.of(context).pop(false),
          )
        ]),
  );
}

Future<bool> showChildrenFinishTaskSubmit(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Column(
          children: <Widget>[
            Text(
              "Are you sure you finished the task?",
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          PiggyButton(
            text: "YES",
            onClick: () => Navigator.of(context).pop(true),
          ),
          PiggyButton(
            text: "NO",
            onClick: () => Navigator.of(context).pop(false),
          )
        ]),
  );
}

Future<bool> showRequestSent(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => PiggyModal(
        title: Column(
          children: <Widget>[
            Text(
              "Done!",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/yellow_tick.png',
              scale: 1,
            ),
            Text("Your request was sent")
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
                Text("Megerősíted?"),
              ],
            ),
          ),
          name: name,
        );
      });
}

Future<bool> showValidatedTask(BuildContext context, String name) async {
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
                  "Megerősítették hogy elkészült a feladatod!",
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
                Text("Gyűjtsd be a duplázást!"),
              ],
            ),
          ),
          name: name,
        );
      });
}

Future<void> showRefusedTask(BuildContext context, String name) async {
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
                Text("Kérdezd meg, mi volt a baj!"),
              ],
            ),
          ),
          name: name,
        );
      });
}
