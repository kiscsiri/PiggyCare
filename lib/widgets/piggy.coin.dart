import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PiggyCoin extends StatefulWidget {
  PiggyCoin(
      {Key key,
      this.willAcceptStream,
      this.coinVisible,
      this.coinController,
      @required this.scale,
      this.isOnTarget})
      : super(key: key);

  final BehaviorSubject<bool> willAcceptStream;
  final bool coinVisible;
  final bool isOnTarget;
  final coinController;
  final double scale;

  @override
  _PiggyCoinState createState() => new _PiggyCoinState();
}

class _PiggyCoinState extends State<PiggyCoin> with TickerProviderStateMixin {
  double coinX = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var coinSizeBig = MediaQuery.of(context).size.width * widget.scale * 1.7;
    var coinSizeSmall = MediaQuery.of(context).size.width * widget.scale;

    var bigcoin = Container(
        child: Image.asset(
      "assets/animations/coin.gif",
      gaplessPlayback: false,
      width: coinSizeBig,
      height: coinSizeBig,
    ));

    var smallCoin = Image.asset("assets/animations/coin.gif",
        width: coinSizeSmall, height: coinSizeSmall);

    return Positioned(
      top: (MediaQuery.of(context).size.width * widget.coinController.value) -
          75,
      left: coinX.isNegative ? MediaQuery.of(context).size.width * 0.38 : coinX,
      child: Draggable(
        data: "Coin",
        childWhenDragging: Container(),
        child: !widget.coinVisible
            ? Container()
            : AnimatedBuilder(
                animation: widget.coinController,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // perspective
                        ..rotateX(0)
                        ..rotateY(0),
                      alignment: FractionalOffset.center,
                      child: smallCoin);
                }),
        feedback: StreamBuilder(
          initialData: false,
          stream: widget.willAcceptStream,
          builder: (context, snapshot) {
            return snapshot.data ? bigcoin : smallCoin;
          },
        ),
        maxSimultaneousDrags: 1,
      ),
    );
  }
}
