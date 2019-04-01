import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/models/user.redux.dart';
import 'package:piggybanx/services/notification-update.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:vibration/vibration.dart';
import 'package:redux/redux.dart';

class PiggyPage extends StatefulWidget {
  PiggyPage({Key key, this.title, this.store}) : super(key: key);

  final String title;
  final Store<UserData> store;

  @override
  _PiggyPageState createState() => new _PiggyPageState();
}

class _PiggyPageState extends State<PiggyPage> with TickerProviderStateMixin {
  AnimationController _controller;
  StepTween tween = new StepTween();
  String _now;
  Timer _everySecond;
  double coinX = -1;
  double coinY = 20.0;
  bool _coinVisible = false;

  Future<void> _feedPiggy() async {
    widget.store.dispatch(FeedPiggy(widget.store.state.id));
    NotificationUpdate.feedPiggy(widget.store.state.id);
    
    await _loadAnimation();
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(
          seconds: widget.store.state.timeUntilNextFeed.inSeconds % 60),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.duration = new Duration(seconds: 60);

          setState(() {
            tween.begin = widget.store.state.timeUntilNextFeed.inSeconds % 60;
          });

          _controller.reset();
          _controller.forward();
        }
      });

    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _now = DateTime.now().second.toString();
      });
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _everySecond.cancel();
    _controller.dispose();
    super.dispose();
  }

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
  }

  setPosition(DraggableDetails data) {
    coinX = data.offset.dx;
    coinY = data.offset.dy;
  }

  @override
  Widget build(BuildContext context) {
    bool _isDisabled =
        widget.store.state.timeUntilNextFeed > Duration(seconds: 0)
            ? false
            : true;
    String period;
    if (widget.store.state.period == Period.daily) {
      period = "tomorrow";
    } else if (widget.store.state.period == Period.weely) {
      period = "next week";
    } else if (widget.store.state.period == Period.monthly) {
      period = "next month";
    }
    return new Scaffold(
      body: Stack(children: <Widget>[
        new Container(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // OutlineButton(
                //   onPressed: () {
                //     setState(() {
                //       if (_coinVisible) {
                //         _coinVisible = false;
                //       } else {
                //         _coinVisible = true;
                //       }
                //     });
                //   },
                //   child: Image.asset("lib/assets/images/coin.png",
                //       width: MediaQuery.of(context).size.width * 0.1,
                //       height: MediaQuery.of(context).size.width * 0.1),
                // ),
                _isDisabled
                    ? new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 30),
                            child: new Text(
                              "PIGGY IS FULL FOR TODAY :(",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display2,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 90.0),
                            child: new Text(
                              "Come back $period!",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    : new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 50),
                            child: new Text(
                              "PIGGY IS HUNGRY!",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display2,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 90.0),
                            child: new Text(
                              "You have to feed him before he starves to death!",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                DragTarget(
                    onWillAccept: (data) {
                      if (data == "Coin") {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    onAccept: (data) {
                      _feedPiggy();
                    },
                    builder: (context, List<String> candidateData,
                            rejectedData) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 38.0),
                          child: _isDisabled
                              ? new Image.asset(
                                  "lib/assets/images/piggy_inaktiv.png",
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  width:
                                      MediaQuery.of(context).size.height * 0.5,
                                )
                              : new Image.asset(
                                  "lib/assets/images/piggy_etetes.png",
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  width:
                                      MediaQuery.of(context).size.height * 0.5,
                                ),
                        )),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: PiggyButton(
                        disabled: _isDisabled,
                        text: "FEED PIGGY!",
                        onClick: () => _feedPiggy()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _isDisabled
                      ? new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "NEXT FEED IN: ",
                              style: Theme.of(context).textTheme.display4,
                            ),
                            new Text((widget.store.state.timeUntilNextFeed * -1)
                                .toString()
                                .replaceRange(
                                    widget.store.state.timeUntilNextFeed
                                        .toString()
                                        .lastIndexOf('.'),
                                    (widget.store.state.timeUntilNextFeed * -1)
                                        .toString()
                                        .length,
                                    '')),
                          ],
                        )
                      : new Container(),
                )
              ]),
        )),
        (!_isDisabled)
            ? Positioned(
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
                    });
                  },
                  child: Image.asset("lib/assets/images/coin.png",
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1),
                  feedback: Image.asset("lib/assets/images/coin.png",
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1),
                  childWhenDragging: Container(),
                ),
              )
            : Container(),
      ]),
    );
  }
}
