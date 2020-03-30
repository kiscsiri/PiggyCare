import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/screens/child.chores.details.dart';
import 'package:piggybanx/widgets/create.piggy.dart';
import 'package:piggybanx/widgets/create.task.dart';
import 'package:piggybanx/widgets/double.information.modal.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:piggybanx/widgets/piggy.modal.widget.dart';
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
      return PiggyModal(
          vPadding: MediaQuery.of(context).size.height * 0.2,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(loc.trans('selector_title'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2),
          ),
          content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        loc.trans('selector_explanation'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Image.asset('assets/images/business.png'),
                Form(
                  key: _formKey,
                  child: Container(
                    decoration: new BoxDecoration(
                      border: new Border.all(
                          color: Theme.of(context).primaryColor, width: 3.0),
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
                            .where((element) => element.isApproved ?? false)
                            .map(
                              (f) => DropdownMenuItem(
                                  value: f.id, child: Text(f.item)),
                            )
                            .toList(),
                        decoration: InputDecoration(
                            hintText: "  " + loc.trans('choose_money_box'),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
              ]));
    },
  );

  return id;
}

Future<void> showAlert(BuildContext context, String errorMessage,
    [String title]) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2),
        child: AlertDialog(
            title: Text(title ?? "Hiba!"),
            actions: <Widget>[
              PiggyButton(
                text: "OK",
                onClick: () => Navigator.of(context).pop(),
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

Future<bool> showAckDialog(BuildContext context, Widget message,
    [Widget title]) async {
  var loc = PiggyLocalizations.of(context);
  return await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2),
        child: AlertDialog(
            title: title ?? Text(""),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    PiggyButton(
                      text: loc.trans('yes'),
                      onClick: () => Navigator.of(context).pop(true),
                    ),
                    PiggyButton(
                      text: loc.trans('no'),
                      onClick: () => Navigator.of(context).pop(false),
                    )
                  ],
                ),
              ),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Center(
              child: message ?? Text(""),
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
        return CreateTaskWidget(
          child: child,
        );
      });
}

Future<bool> showDoubleInformationModel(BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DoubleInformationModal();
      });
}

Future<void> showCreatePiggyModal(BuildContext context,
    [String childId]) async {
  var piggy = await showDialog<Piggy>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CreatePiggyWidget(
          childId: childId,
        );
      });
}

Future<void> showAddNewChildModal(
    BuildContext context, Store<AppState> store) async {
  await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddChildWidget();
      });
}

Future<String> showUserAddModal(
    BuildContext context, Store<AppState> store) async {
  var textController = new TextEditingController();
  var loc = PiggyLocalizations.of(context);

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
                    text: loc.trans('search'),
                    onClick: () => Navigator.of(context).pop(),
                  )
                ],
                title: Text(loc.trans("search_user")),
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
