import 'package:flutter/material.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:rxdart/rxdart.dart';

class PiggyCoinDropPlaceWidget extends StatefulWidget {
  PiggyCoinDropPlaceWidget(
      {Key key,
      this.willAcceptStream,
      this.onDrop,
      @required this.isDisabled,
      @required this.isAnimationPlaying,
      this.piggy,
      @required this.scale})
      : super(key: key);

  final BehaviorSubject<bool> willAcceptStream;
  final Function(int) onDrop;
  final bool isDisabled;
  final bool isAnimationPlaying;
  final Piggy piggy;
  final double scale;
  @override
  _PiggyCoinDropPlaceWidgetState createState() =>
      new _PiggyCoinDropPlaceWidgetState();
}

class _PiggyCoinDropPlaceWidgetState extends State<PiggyCoinDropPlaceWidget> {
  bool isFeedingPlayed = false;
  bool isRandomGenerated = false;
  int feedRandom = 1;

  Widget getAnimation(BuildContext context, Piggy piggy) {
    return Image.asset(
      'assets/images/${levelStringValue(piggy.piggyLevel)}-Normal.png',
      gaplessPlayback: true,
    );
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
            widget.onDrop(widget.piggy?.id);
          },
          builder: (context, List<String> candidateData, rejectedData) =>
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Hero(
                        tag: "piggy",
                        child: getAnimation(context, widget.piggy))),
              )),
    );
  }
}
