import 'dart:math';

import 'package:flutter/material.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class PiggyFeedWidget extends StatefulWidget {
  PiggyFeedWidget(
      {Key key,
      this.willAcceptStream,
      this.onDrop,
      @required this.isDisabled,
      this.store,
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

class _PiggyFeedWidgetState extends State<PiggyFeedWidget> {
  bool isFeedingPlayed = false;
  bool isRandomGenerated = false;
  int feedRandom = 1;

  Widget getFeedAnimation(BuildContext context, Store<AppState> store) {
    if (widget.isAnimationPlaying && !isRandomGenerated) {
      feedRandom = Random().nextInt(3) + 1;
      isRandomGenerated = true;
    }
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

  Widget getAnimation(BuildContext context, Store<AppState> store) {
    if (store == null) {
      return Image.asset('assets/animations/Baby-Feed1.gif',
          gaplessPlayback: true,
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.2);
    } else if (widget.isDisabled && !widget.isAnimationPlaying) {
      return Image.asset(
          'assets/animations/${levelStringValue(store.state.user.piggyLevel)}-Sleep.gif',
          gaplessPlayback: true,
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.2);
    } else if (widget.isAnimationPlaying) {
      return getFeedAnimation(context, store);
    } else {
      isRandomGenerated = false;
      return Image.asset(
          'assets/animations/${levelStringValue(store.state.user.piggyLevel)}-Normal.gif',
          gaplessPlayback: true,
          scale: 0.8,
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.2);
    }
  }

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
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Hero(
                          tag: "piggy",
                          child: getAnimation(context, widget.store))),
                ),
              )),
    );
  }
}
