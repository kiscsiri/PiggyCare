import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/screens/child.chores.details.dart';
import 'package:piggybanx/widgets/create.piggy.dart';
import 'package:piggybanx/widgets/create.task.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:piggybanx/widgets/add.child.dart';

Future<int> showPiggySelector(
    BuildContext context, Store<AppState> store) async {
  var loc = PiggyLocalizations.of(context);
  final _formKey = GlobalKey<FormState>();

  int id;
  await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2),
        child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(loc.trans('selector_title'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2),
                    ),
                    Text(
                      loc.trans('selector_explanation'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        onChanged: (value) {
                          id = value;
                          Navigator.of(context).pop();
                        },
                        value: id,
                        items: store.state.user.piggies
                            .map((f) => DropdownMenuItem(
                                  value: f.id,
                                  child: Text(f.item),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                            hintText: "  " + loc.trans('choose_money_box'),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                )
              ],
            )),
      );
    },
  );

  return id;
}

Future<void> showAlert(BuildContext context, String errorMessage) async {
  await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2),
        child: AlertDialog(
            title: Text("Hiba!"),
            actions: <Widget>[
              PiggyButton(
                text: "OK",
                onClick: () => Navigator.pop(context),
              )
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Center(
              child: Text(errorMessage ?? ""),
            )),
      );
    },
  );
}

Future<void> showCreateTask(
    BuildContext context, Store<AppState> store, ChildDto child) async {
  await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: CreateTaskWidget(
                child: child,
                store: store,
              ),
            ),
          ),
        );
      });
}

Future<void> showCreatePiggyModal(
    BuildContext context, Store<AppState> store) async {
  await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: CreatePiggyWidget(
                store: store,
              ),
            ),
          ),
        );
      });
}

Future<void> showAddNewChildModal(
    BuildContext context, Store<AppState> store) async {
  await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: AddChildWidget(
                store: store,
              ),
            ),
          ),
        );
      });
}

Future<String> showUserAddModal(
    BuildContext context, Store<AppState> store) async {
  var textController = new TextEditingController();

  try {
    await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.2),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Keresés e-mail vagy név alapján",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    PiggyInput(
                      hintText: "A családtag...",
                      onValidate: (val) {
                        if (val.isEmpty) {
                          return "Can't be empty!";
                        }
                        return null;
                      },
                      textController: textController,
                    )
                  ],
                ),
                actions: <Widget>[
                  PiggyButton(
                    text: "Keresés",
                    onClick: () => Navigator.of(context).pop(),
                  )
                ],
                title: Text("Search user"),
              ),
            ),
          );
        });

    return textController.text;
  } on Exception {
    return "";
  }
}

Widget getFeedAnimation(
    BuildContext context, Store<AppState> store, int feedRandom) {
  try {
    return AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 1500),
        child: Image.asset(
            'assets/animations/${levelStringValue(store.state.user.piggyLevel)}-Feed$feedRandom.gif',
            gaplessPlayback: true,
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.2));
  } catch (err) {
    return Image.asset(
        'assets/animations/${levelStringValue(store.state.user.piggyLevel)}-Feed$feedRandom.gif',
        gaplessPlayback: true,
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.2);
  }
}

Future<void> loadAnimation(
    bool isLevelUp,
    TickerProviderStateMixin tickerProviderStateMixin,
    BuildContext context,
    Store<AppState> store) async {
  AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: tickerProviderStateMixin)
    ..forward();

  var animation = new Tween<double>(begin: 0, end: 300).animate(_controller)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        imageCache.clear();
        Navigator.of(context).pop();
        _controller.dispose();
      }
    });

  Future.delayed(Duration(milliseconds: 250), () {
    AudioCache().play("coin_sound.mp3");
    Vibration.vibrate(duration: 750);
  });
  var prefs = await SharedPreferences.getInstance();
  var feedRandom = prefs.getInt("animationCount");
  if (feedRandom > 2) {
    prefs.setInt('animationCount', 1);
    feedRandom = 1;
  }
  if (isLevelUp) {
    prefs.setInt("animationCount", 1);
  } else {
    prefs.setInt("animationCount", feedRandom + 1);
  }

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            _controller.dispose();
            imageCache.clear();
            return true;
          },
          child: Container(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) => Hero(
                tag: "piggy",
                child: (isLevelUp)
                    ? Image.asset(
                        'assets/animations/Baby-Feed$feedRandom.gif',
                        gaplessPlayback: true,
                      )
                    : (Image.asset(
                        'assets/animations/Baby-Feed$feedRandom.gif')),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFe25997),
          ),
        );
      });
}

Future<void> exitStartAnimation(
    TickerProviderStateMixin tickerProviderStateMixin,
    bool isExit,
    BuildContext context) async {
  AnimationController _controller = AnimationController(
      duration: Duration(milliseconds: !isExit ? 6000 : 6000),
      vsync: tickerProviderStateMixin)
    ..forward();

  var animation = new Tween<double>(begin: 0, end: 250).animate(_controller)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        imageCache.clear();
        Navigator.of(context).pop();
        _controller.dispose();
      }
    });

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            _controller.dispose();
            imageCache.clear();
            return true;
          },
          child: Container(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) => Hero(
                tag: "piggy",
                child: (isExit)
                    ? Image.asset(
                        'assets/animations/Baby-Exit.gif',
                        gaplessPlayback: true,
                      )
                    : (Image.asset('assets/animations/Baby-Start.gif')),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFe25997),
          ),
        );
      });
}
