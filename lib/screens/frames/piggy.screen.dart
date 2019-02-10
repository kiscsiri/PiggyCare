import 'dart:async';

import 'package:flutter/material.dart';
import 'package:piggybanx/models/user.redux.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.counter.dart';
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

  Future<void> _feedPiggy() async {
    widget.store.dispatch(FeedPiggy(widget.store.state.id));
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

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _loadAnimation() async {
    AnimationController _controller =
        AnimationController(duration: const Duration(seconds: 4), vsync: this)
          ..forward();
    var animation = new Tween<double>(begin: 0, end: 300).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          imageCache.clear();
          Navigator.pop(context);
          _controller.dispose();
        }
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

  @override
  Widget build(BuildContext context) {
    
    var tween = new StepTween(
      begin: widget.store.state.timeUntilNextFeed.inSeconds % 60,
      end: 0,
    );
    bool _isDisabled =
        widget.store.state.timeUntilNextFeed < Duration(seconds: 1)
            ? true
            : false;
    return new Scaffold(
      body: new Container(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isDisabled
                    ? new Image.asset("lib/assets/images/piggy_inaktiv.png")
                    : new Image.asset("lib/assets/images/piggy_etetes.png"),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: new PiggyButton(
                        disabled: _isDisabled,
                        text: "FEED PIGGY",
                        onClick: () => _feedPiggy()),
                  ),
                ),
                _isDisabled
                    ? new Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "NEXT FEED IN: ",
                              style: Theme.of(context).textTheme.display4,
                            ),
                            new CounterWidget(
                                feedTime: widget.store.state.timeUntilNextFeed,
                                animation: tween.animate(_controller))
                          ],
                        ))
                    : new Container()
              ]),
        ),
      )),
    );
  }
}
