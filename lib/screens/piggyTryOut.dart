import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:vibration/vibration.dart';

class PiggyTestPage extends StatefulWidget {
  PiggyTestPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PiggyPageState createState() => new _PiggyPageState();
}

class _PiggyPageState extends State<PiggyTestPage>
    with TickerProviderStateMixin {
  double coinX = -1;
  double coinY = 20.0;
  int counter = 0;
  bool _coinVisible = false;
  bool isOnTarget = false;
  final _dragKey = GlobalKey();

  Future<void> _feedPiggy() async {
    await _loadAnimation();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  Future<void> testPurchace() async {}

  Future<void> _loadAnimation() async {
    AnimationController _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this)
          ..forward();

    var animation = new Tween<double>(begin: 0, end: 300).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          imageCache.clear();
          Navigator.pop(context);
          _controller.dispose();
        }
      });

    Future.delayed(Duration(milliseconds: 1500), () {
      AudioCache().play("coin_sound.mp3");
      Vibration.vibrate(duration: 1000);
    });

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              _controller.dispose();
              imageCache.clear();
            },
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) => Image.asset(
                    'lib/assets/animation/animation-piggy.gif',
                    gaplessPlayback: true,
                  ),
            ),
          );
        });

    setState(() {
      counter++;
    });
  }

  setPosition(DraggableDetails data) {
    coinX = data.offset.dx;
    coinY = data.offset.dy;
  }

  @override
  Widget build(BuildContext context) {
    var bigcoin = Image.asset(
      "lib/assets/images/coin.png",
      gaplessPlayback: false,
      width: MediaQuery.of(context).size.width * 0.1 * 1.5,
      height: MediaQuery.of(context).size.width * 0.1 * 1.5,
    );

    var smallCoin = Image.asset("lib/assets/images/coin.png",
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.width * 0.1);

    return new Scaffold(
      appBar: AppBar(
        title: Text("Feed piggy to save money"),
      ),
      body: Stack(children: <Widget>[
        new Container(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DragTarget(
                    onWillAccept: (data) {
                      if (data == "Coin") {
                        setState(() {
                          imageCache.clear();
                          isOnTarget = true;
                        });
                        return true;
                      } else {
                        setState(() {
                          imageCache.clear();
                          isOnTarget = false;
                        });
                        return false;
                      }
                    },
                    onAccept: (data) {
                      setState(() {
                        isOnTarget = false;
                      });
                      _feedPiggy();
                    },
                    builder: (context, List<String> candidateData,
                            rejectedData) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: new Image.asset(
                            "lib/assets/images/piggy_etetes.png",
                            height: MediaQuery.of(context).size.width * 0.5,
                            width: MediaQuery.of(context).size.height * 0.5,
                          ),
                        )),
                new Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).primaryColorDark,
                    ),
                    child: new Center(
                        child: new Text(
                      "You saved $counter \$!",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ))),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: PiggyButton(
                        text: "FEED PIGGY!", onClick: () => _feedPiggy()),
                  ),
                ),
              ]),
        )),
        Positioned(
          top: coinY,
          left: coinX.isNegative
              ? MediaQuery.of(context).size.width * 0.45
              : coinX,
          child: Draggable(
            axis: Axis.vertical,
            data: "Coin",
            onDragEnd: (data) {
              coinX = -1;
              coinY = 20.0;
              setState(() {
                _coinVisible = false;
                isOnTarget = false;
              });
            },
            key: _dragKey,
            child: smallCoin,
            feedback: ((!isOnTarget) ? smallCoin : bigcoin),
            ignoringFeedbackSemantics: true,
            maxSimultaneousDrags: 1,
          ),
        )
      ]),
    );
  }
}
