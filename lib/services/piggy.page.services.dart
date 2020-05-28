import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/Enums/level.dart';
import 'package:piggybanx/Enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/screens/child.chores.details.dart';
import 'package:piggybanx/services/notification.modals.dart';
import 'package:piggybanx/widgets/create.piggy.dart';
import 'package:piggybanx/widgets/create.task.dart';
import 'package:piggybanx/widgets/modals/double.information.modal.dart';
import 'package:piggybanx/widgets/no.parent.modal.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:piggybanx/widgets/piggy.modal.widget.dart';
import 'package:redux/redux.dart';
import 'package:piggybanx/widgets/add.child.dart';
import 'package:video_player/video_player.dart';

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
          vPadding: MediaQuery.of(context).size.height * 0.1,
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
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Image.asset('assets/images/business.png')),
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
    [String title, double verticalPadding]) async {
  var loc = PiggyLocalizations.of(context);
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(
            vertical:
                MediaQuery.of(context).size.height * (verticalPadding ?? 0.24)),
        child: AlertDialog(
            title: Text(title ?? loc.trans('error')),
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
  if (store.state.user.parentId == null &&
      store.state.user.userType == UserType.child) {
    await showDialog<Piggy>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return NoParentModal();
        });
    return;
  }
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
  var user = StoreProvider.of<AppState>(context).state.user;
  var nPiggiesBeforeAdd = user.piggies.length;
  if (user.parentId == null && user.userType == UserType.child) {
    await showDialog<Piggy>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return NoParentModal();
        });
    return;
  }
  var piggy = await showDialog<Piggy>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CreatePiggyWidget(
          childId: childId,
        );
      });
  if (user.userType == UserType.child &&
      nPiggiesBeforeAdd == 0 &&
      piggy != null) await showChildrenPiggyInfo(context);
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
          return PiggyModal(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  loc.trans('search_by_user_data'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                ),
                PiggyInput(
                  hintText: loc.trans('family_hint'),
                  onValidate: (val) {
                    if (val.isEmpty) {
                      return loc.trans('required');
                    }
                    return null;
                  },
                  textController: textController,
                )
              ],
            ),
            vPadding: MediaQuery.of(context).size.height * 0.2,
            actions: <Widget>[
              PiggyButton(
                text: loc.trans('search'),
                onClick: () => Navigator.of(context).pop(),
              )
            ],
            title: Text(
              loc.trans("search_user"),
              textAlign: TextAlign.center,
            ),
          );
        });

    return textController.text;
  } on Exception {
    return "";
  }
}

Future<String> showUserInviteModal(
    BuildContext context, Store<AppState> store) async {
  var textController = new TextEditingController();
  var loc = PiggyLocalizations.of(context);

  try {
    await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return PiggyModal(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  loc.trans('invite_by_email'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                ),
                PiggyInput(
                  hintText: loc.trans('email'),
                  onValidate: (val) {
                    if (val.isEmpty) {
                      return loc.trans('required');
                    }
                    return null;
                  },
                  textController: textController,
                )
              ],
            ),
            vPadding: MediaQuery.of(context).size.height * 0.2,
            actions: <Widget>[
              PiggyButton(
                text: loc.trans('invite'),
                onClick: () => Navigator.of(context).pop(),
              )
            ],
            title: Text(
              store.state.user.userType == UserType.adult
                  ? loc.trans("invite_child_menu")
                  : loc.trans("invite_parent_menu"),
              textAlign: TextAlign.center,
            ),
          );
        });

    return textController.text;
  } on Exception {
    return "";
  }
}

int getMaxAnimationIndex(PiggyLevel level) {
  if (level == PiggyLevel.Baby)
    return 2;
  else if (level == PiggyLevel.Child)
    return 6;
  else if (level == PiggyLevel.Teen)
    return 2;
  else if (level == PiggyLevel.Adult)
    return 2;
  else
    return 0;
}

Future<void> exitStartAnimation(
    TickerProviderStateMixin tickerProviderStateMixin,
    bool isExit,
    BuildContext context) async {
  VideoPlayerController vidController;
  vidController = VideoPlayerController.asset(
    'assets/animations/${isExit ? "exit" : "start"}.mp4',
  );
  await vidController.initialize();
  vidController.addListener(() {
    if (vidController.value.position >= vidController.value.duration) {
      Navigator.of(context).pop();
    }
  });

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            vidController.dispose();
            imageCache.clear();
            return true;
          },
          child: Container(
            child: Hero(
              tag: "piggy",
              child: AspectRatio(
                aspectRatio: vidController.value.aspectRatio,
                child: VideoPlayer(vidController),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFe25997),
          ),
        );
      });
}
