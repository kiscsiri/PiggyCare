import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/Enums/level.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/models/user/user.model.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class PiggyFeedWidget extends StatefulWidget {
  PiggyFeedWidget(
      {Key key,
      this.willAcceptStream,
      this.onDrop,
      @required this.isDisabled,
      @required this.store, 
      @required this.isAnimationPlaying})
      : super(key: key);

  final BehaviorSubject<bool> willAcceptStream;
  final Function onDrop;
  final bool isDisabled;
  final bool isAnimationPlaying;
  final Store<AppState> store;
  @override
  _PiggyFeedWidgetState createState() => new _PiggyFeedWidgetState();
}

Widget getAnimation(
    BuildContext context, Store<AppState> store, bool isDisabled) {
  if (isDisabled) {
    return Image.asset(
        'assets/animations/${levelStringValue(store.state.user.piggyLevel)}-Sleep.gif',
        gaplessPlayback: true,
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.2);
  } else {
    return Image.asset(
        'assets/animations/${levelStringValue(store.state.user.piggyLevel)}-Normal.gif',
        gaplessPlayback: true,
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.2);
  }
}

Widget getFeedAnimation(
    BuildContext context, Store<AppState> store, bool isDisabled) {
  var rng = new Random();
  try {
    return Image.asset(
        'assets/animations/${levelStringValue(store.state.user.piggyLevel)}-Feed${rng.nextInt(4)}.gif',
        gaplessPlayback: true,
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.2);
  } catch (err) {
    return Image.asset(
        'assets/animations/${levelStringValue(store.state.user.piggyLevel)}-Feed${rng.nextInt(3)}.gif',
        gaplessPlayback: true,
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.2);
  }
}

class _PiggyFeedWidgetState extends State<PiggyFeedWidget> {
  bool isFeedingPlayed = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new DragTarget(
          onWillAccept: (data) {
            if (data == "Coin") {
              setState(() {
                widget.willAcceptStream.value = true;
              });
              return true;
            } else {
              setState(() {
                widget.willAcceptStream.value = false;
              });
              return false;
            }
          },
          onLeave: (val) {
            setState(() {
              widget.willAcceptStream.value = false;
            });
          },
          onAccept: (data) {
            widget.onDrop();
          },
          builder: (context, List<String> candidateData, rejectedData) =>
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: getAnimation(
                          context, widget.store, widget.isDisabled)),
                ),
              )),
    );
  }
}
