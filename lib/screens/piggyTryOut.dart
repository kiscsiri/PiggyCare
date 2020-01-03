import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.coin.dart';
import 'package:piggybanx/widgets/piggy.main.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vibration/vibration.dart';

class PiggyTestPage extends StatefulWidget {
  PiggyTestPage({Key key}) : super(key: key);

  @override
  _PiggyPageState createState() => new _PiggyPageState();
}

class _PiggyPageState extends State<PiggyTestPage>
    with TickerProviderStateMixin {
  BehaviorSubject<bool> willAcceptStream;

  Animation<double> _coinAnimation;
  Tween<double> _tween;
  AnimationController _animationController;

  int counter = 0;
  bool _coinVisible = true;
  bool isOnTarget = false;
  bool _isDisabled = false;
  bool isAnimationPlaying = false;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _tween = Tween(begin: 0.15, end: 0.25);
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
        setState(() {});
      });
    _animationController.forward();

    willAcceptStream = new BehaviorSubject<bool>();
    willAcceptStream.add(false);
    super.initState();
  }

  @override
  void dispose() async {
    _animationController.dispose();
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
          setState(() {
            isAnimationPlaying = false;
          });
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

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FittedBox(
            fit: BoxFit.fitWidth, child: Text(loc.trans("feed_piggy_to_save"))),
      ),
      body: Center(
        child: Stack(alignment: Alignment.center, children: <Widget>[
          new Container(
              color: Color(0xFFcb435b),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.2),
                      ),
                      PiggyFeedWidget(
                        willAcceptStream: willAcceptStream,
                        isDisabled: _isDisabled,
                        isAnimationPlaying: isAnimationPlaying,
                        onDrop: (id) {
                          setState(() {
                            _coinVisible = false;
                            _isDisabled = true;
                          });
                          _loadAnimation();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: _isDisabled
                              ? PiggyButton(
                                  disabled: !_isDisabled,
                                  text: loc.trans("register"),
                                  onClick: () =>
                                      Navigator.pushNamed(context, 'register'))
                              : Container(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: _isDisabled
                              ? PiggyButton(
                                  disabled: !_isDisabled,
                                  text: loc.trans("login"),
                                  onClick: () =>
                                      Navigator.pushNamed(context, 'login'))
                              : Container(),
                        ),
                      ),
                    ]),
              )),
          PiggyCoin(
            coinController: _coinAnimation,
            coinVisible: _coinVisible,
            isOnTarget: isOnTarget,
            willAcceptStream: willAcceptStream,
          )
        ]),
      ),
    );
  }
}
