import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PiggyFeedWidget extends StatefulWidget {
  PiggyFeedWidget({Key key, this.willAcceptStream, this.onDrop, @required this.isDisabled}) : super(key: key);

  final BehaviorSubject<bool> willAcceptStream;
  final Function onDrop;
  final bool isDisabled;
  @override
  _PiggyFeedWidgetState createState() => new _PiggyFeedWidgetState();
}

class _PiggyFeedWidgetState extends State<PiggyFeedWidget> {
  @override
  Widget build(BuildContext context) {
    return new DragTarget(
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
        onAccept:(data) {
          widget.onDrop();
          },
        builder: (context, List<String> candidateData, rejectedData) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.65,
                child: widget.isDisabled
                    ? Container(
                      height: MediaQuery.of(context).size.height,
                        child: FlareActor("assets/piggy_sleep.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                            animation: "sleep"))
                    : Container(
                        child: FlareActor("assets/piggy_etetes.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                            animation: "sleep")),
              ),
            ));
  }
}
