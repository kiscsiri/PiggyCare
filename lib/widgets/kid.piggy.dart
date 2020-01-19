import 'package:flutter/material.dart';
import 'package:piggybanx/enums/period.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/services/notification.services.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/nopiggy.widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:redux/redux.dart';

import 'create.piggy.dart';
import 'piggy.coin.dart';
import 'piggy.main.dart';
import 'piggy.progress.dart';

class KidPiggyWidget extends StatefulWidget {
  KidPiggyWidget({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  _KidPiggyWidgetState createState() => new _KidPiggyWidgetState();
}

class _KidPiggyWidgetState extends State<KidPiggyWidget>
    with TickerProviderStateMixin {
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
  bool creatingPiggy = false;
  Piggy piggy;

  void onCoinDrop(int piggyId) {
    setState(() {
      isOnTarget = false;
      _feedPiggy(piggyId);
    });
  }

  @override
  void initState() {
    if (widget.store.state.user.piggies.length != 0) {
      piggy = widget.store.state.user.piggies.first;
    }

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

  Future<void> _feedPiggy(int piggyId) async {
    var tempLevel = widget.store.state.user.piggyLevel;
    var tempIsDemoOver = widget.store.state.user.isDemoOver;

    widget.store.dispatch(FeedPiggy(widget.store.state.user.id, piggyId));
    NotificationServices.feedPiggy(widget.store.state.user.id);

    var showDemoAlert = (tempIsDemoOver != widget.store.state.user.isDemoOver);
    if (showDemoAlert) {
      showDemoOverDialog(context);
    }
    if (tempLevel.index == widget.store.state.user.piggyLevel.index) {
      await loadAnimation(false, showDemoAlert, this, context, widget.store);
    } else {
      await loadAnimation(true, showDemoAlert, this, context, widget.store);
    }

    setState(() {
      piggy =
          widget.store.state.user.piggies.singleWhere((p) => p.id == piggy.id);
    });
  }

  _changeCreatePiggyState() async {
    await showCreatePiggyModal(context, widget.store);  
  }

  _changePiggyData(index) {
    setState(() {
      piggy = widget.store.state.user.piggies
          .singleWhere((d) => d.id == index, orElse: null);
    });
  }

  Future<void> selectPiggy(BuildContext context) async {
    var newId = await showPiggySelector(context, widget.store);
    if (newId != null) {
      _changePiggyData(newId);
    }
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var user = widget.store.state.user;

    bool _isDisabled = piggy == null ? false : !piggy.isFeedAvailable;
    if (piggy == null && user.piggies.length != 0) {
      piggy = user.piggies.first;
    }
    _coinVisible = !_isDisabled;

    String period;
    if (user.period == Period.daily) {
      period = loc.trans("tomorrow");
    } else if (user.period == Period.weely) {
      period = loc.trans("next_week");
    } else if (user.period == Period.monthly) {
      period = loc.trans("next_month");
    }

    return (user.piggies.length == 0 || creatingPiggy)
        ? (creatingPiggy
            ? AnimatedOpacity(
                opacity: creatingPiggy ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: CreatePiggyWidget(
                  store: widget.store,
                  navigateToPiggyWidget: () => _changeCreatePiggyState(),
                ),
              )
            : NoPiggyWidget(
                navigateToCreateWidget: () => _changeCreatePiggyState(),
              ))
        : Stack(children: <Widget>[
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 90.0),
                                child: new Text(
                                  loc.trans("come_back") + "$period!",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                        : new Container(
                            child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 20),
                                    child: new Text(
                                      'Name of the money box:',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 20),
                                    child: new Text(
                                      '${piggy.item}',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10),
                                    child: GestureDetector(
                                      onTap: () async =>
                                          await selectPiggy(context),
                                      child: new Text(
                                        'Change money box',
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display4,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.7,
                      child: Stack(children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Container(
                                child: PiggyFeedWidget(
                                    willAcceptStream: willAcceptStream,
                                    isAnimationPlaying: isAnimationPlaying,
                                    isDisabled: _isDisabled,
                                    onDrop: onCoinDrop,
                                    piggy: piggy),
                          ),
                        ),
                        Positioned(
                          right: 25,
                          top: 25,
                          child: IconButton(
                            iconSize: 35,
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _changeCreatePiggyState();
                            },
                          ),
                        )
                      ]),
                    ),
                    piggy != null
                        ? PiggyProgress(
                            userType: user.userType,
                            item: piggy.item,
                            saving: piggy.currentSaving.toDouble(),
                            targetPrice: piggy.targetPrice.toDouble())
                        : Container(),
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
          ]);
  }
}
