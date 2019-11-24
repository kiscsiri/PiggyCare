import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/enums/period.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/services/notification.services.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.coin.dart';
import 'package:piggybanx/widgets/piggy.main.dart';
import 'package:piggybanx/widgets/piggy.progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class PiggyPage extends StatefulWidget {
  PiggyPage({Key key, this.title, this.store}) : super(key: key);

  final String title;
  final Store<AppState> store;

  @override
  _PiggyPageState createState() => new _PiggyPageState();
}

class _PiggyPageState extends State<PiggyPage> with TickerProviderStateMixin {
  AnimationController _controller;
  BehaviorSubject<bool> willAcceptStream;

  Animation<double> _coinAnimation;
  Tween<double> _tween;
  AnimationController _animationController;

  StepTween tween = new StepTween();
  double coinX = -1;
  double coinY = 20.0;
  bool _coinVisible = true;
  bool isOnTarget = false;
  bool isAnimationPlaying = false;
  String timeUntilNextFeed = "";

  Future<void> _feedPiggy() async {
    var tempLevel = widget.store.state.user.piggyLevel;
    var tempIsDemoOver = widget.store.state.user.isDemoOver;

    widget.store.dispatch(FeedPiggy(widget.store.state.user.id));
    NotificationServices.feedPiggy(widget.store.state.user.id);

    var showDemoAlert = (tempIsDemoOver != widget.store.state.user.isDemoOver);
    if (showDemoAlert) {
      showDemoOverDialog(context);
    }
    if (tempLevel.index == widget.store.state.user.piggyLevel.index) {
      await _loadAnimation(false, showDemoAlert);
    } else {
      await _loadAnimation(true, showDemoAlert);
    }
  }

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _tween = Tween(begin: 0.35, end: 0.4);
    _coinAnimation = _tween.animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      })
      ..addListener(() {
        setState(() {
          timeUntilNextFeed = (widget.store.state.user.timeUntilNextFeed * -1)
              .toString()
              .replaceRange(
                  widget.store.state.user.timeUntilNextFeed
                      .toString()
                      .lastIndexOf('.'),
                  (widget.store.state.user.timeUntilNextFeed * -1)
                      .toString()
                      .length,
                  '');
        });
      });
    _animationController.forward();

    super.initState();
    willAcceptStream = new BehaviorSubject<bool>();
    willAcceptStream.add(false);
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(
          seconds: widget.store.state.user.timeUntilNextFeed.inSeconds % 60),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.duration = new Duration(seconds: 60);

          setState(() {
            tween.begin =
                widget.store.state.user.timeUntilNextFeed.inSeconds % 60;
          });

          _controller.reset();
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() async {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void onCoinDrop() {
    setState(() {
      isOnTarget = false;
    });
    _feedPiggy();
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

  showDemoOverDialog(BuildContext context) async {
    var loc = PiggyLocalizations.of(context);

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(loc.trans("congratulations"),
                style: Theme.of(context).textTheme.display3),
            content: Text(loc.trans("demo_over_dialog_content")),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> _loadAnimation(bool isLevelUp, bool showDemoOverAlert) async {
    AnimationController _controller = AnimationController(
        duration: const Duration(milliseconds: 7500), vsync: this)
      ..forward();

    var animation = new Tween<double>(begin: 0, end: 300).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          imageCache.clear();
          setState(() {
            isAnimationPlaying = false;
          });
          Navigator.of(context).pop();
          _controller.dispose();
        }
      });

    setState(() {
      isAnimationPlaying = true;
    });

    Future.delayed(Duration(milliseconds: 250), () {
      AudioCache().play("coin_sound.mp3");
      Vibration.vibrate(duration: 750);
    });
    var prefs = await SharedPreferences.getInstance();
    var feedRandom = prefs.getInt("animationCount");
    if (isLevelUp) {
      prefs.setInt("animationCount", 1);
    } else if (widget.store.state.user.isDemoOver) {
      feedRandom = Random().nextInt(3) + 1;
    } else {
      prefs.setInt("animationCount", feedRandom + 1);
    }

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              _controller.dispose();
              imageCache.clear();
            },
            child: Container(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) => Hero(
                  tag: "piggy",
                  child: (isLevelUp)
                      ? Image.asset(
                          'assets/animations/${levelStringValue(PiggyLevel.values[widget.store.state.user.piggyLevel.index - 1])}-LevelUp.gif',
                          gaplessPlayback: true,
                        )
                      : (Image.asset(
                          'assets/animations/${levelStringValue(PiggyLevel.values[widget.store.state.user.piggyLevel.index])}-Feed$feedRandom.gif')),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0xFFce475e),
            ),
          );
        });
  }

  Future<void> testPurchace() async {}

  setPosition(DraggableDetails data) {
    coinX = data.offset.dx;
    coinY = data.offset.dy;
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var item = widget.store.state.user.items.last;

    bool _isDisabled =
        widget.store.state.user.timeUntilNextFeed > Duration(seconds: 0)
            ? false
            : true;
    _coinVisible = !_isDisabled;
    String period;
    if (widget.store.state.user.period == Period.daily) {
      period = loc.trans("tomorrow");
    } else if (widget.store.state.user.period == Period.weely) {
      period = loc.trans("next_week");
    } else if (widget.store.state.user.period == Period.monthly) {
      period = loc.trans("next_month");
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
                _isDisabled
                    ? new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 30),
                            child: new Text(
                              loc.trans("piggy_full"),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display2,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 90.0),
                            child: new Text(
                              loc.trans("come_back") + "$period!",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    : new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: new Text(
                              loc.trans("piggy_hungry"),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display2,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 60.0),
                            child: new Text(
                              loc.trans("you_have_to_feed"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 23.0),
                  child: PiggyFeedWidget(
                      willAcceptStream: willAcceptStream,
                      isAnimationPlaying: isAnimationPlaying,
                      isDisabled: _isDisabled,
                      onDrop: onCoinDrop,
                      store: widget.store),
                ),
                PiggyProgress(
                    item: item.item,
                    saving: item.currentSaving.toDouble(),
                    targetPrice: item.targetPrice.toDouble()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: PiggyButton(
                        disabled: _isDisabled,
                        text: loc.trans('feed_piggy'),
                        onClick: () => _feedPiggy()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: _isDisabled
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              loc.trans("next_feed_in"),
                              style: Theme.of(context).textTheme.display4,
                            ),
                            Text(timeUntilNextFeed),
                          ],
                        )
                      : Container(),
                )
              ]),
        )),
        (!_isDisabled)
            ? PiggyCoin(
                coinController: _coinAnimation,
                coinVisible: _coinVisible,
                isOnTarget: isOnTarget,
                willAcceptStream: willAcceptStream,
              )
            : Container(),
      ]),
    );
  }
}
