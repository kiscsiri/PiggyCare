import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PiggyCoin extends StatefulWidget {
  PiggyCoin(
      {Key key,
      this.willAcceptStream,
      this.coinVisible,
      this.coinController,
      this.isOnTarget})
      : super(key: key);

  final BehaviorSubject<bool> willAcceptStream;
  final bool coinVisible;
  final bool isOnTarget;
  final coinController;

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
    double coinY = MediaQuery.of(context).size.height * 0.18;
    var bigcoin = Container(
        decoration: ShapeDecoration(
          shape: CircleBorder(side: BorderSide(width: 2, color: Colors.green)),
          color: Colors.green,
        ),
        child: Image.asset(
          "lib/assets/images/coin.png",
          gaplessPlayback: false,
          width: MediaQuery.of(context).size.width * 0.1 * 1.7,
          height: MediaQuery.of(context).size.width * 0.1 * 1.7,
        ));

    var smallCoin = Image.asset("lib/assets/images/coin.png",
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.width * 0.1);

    return Positioned(
      top: MediaQuery.of(context).size.width * widget.coinController.value,
      left: coinX.isNegative ? MediaQuery.of(context).size.width * 0.42 : coinX,
      child: Draggable(
        data: "Coin",
        childWhenDragging: Container(),
        child: !widget.coinVisible ? Container() : AnimatedBuilder(
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
