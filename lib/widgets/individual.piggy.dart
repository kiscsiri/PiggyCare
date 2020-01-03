import 'package:flutter/material.dart';
import 'package:piggybanx/enums/period.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/services/notification.services.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.coin.dart';
import 'package:piggybanx/widgets/piggy.main.dart';
import 'package:piggybanx/widgets/piggy.progress.dart';

import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class IndividualPiggyWidget extends StatefulWidget {
  IndividualPiggyWidget({
    Key key,
    this.store,
  }) : super(key: key);

  final Store<AppState> store;

  @override
  _IndividualPiggyWidgetState createState() =>
      new _IndividualPiggyWidgetState();
}

class _IndividualPiggyWidgetState extends State<IndividualPiggyWidget>
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

  void onCoinDrop(id) {
    setState(() {
      isOnTarget = false;
    });
    _feedPiggy(widget.store.state.user.piggies.first.id);
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
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var user = widget.store.state.user;
    Piggy item;
    if (user.piggies.length != 0) item = user.piggies.last;

    bool _isDisabled =
        user.timeUntilNextFeed > Duration(seconds: 0) ? false : true;

    _coinVisible = !_isDisabled;

    String period;
    if (user.period == Period.daily) {
      period = loc.trans("tomorrow");
    } else if (user.period == Period.weely) {
      period = loc.trans("next_week");
    } else if (user.period == Period.monthly) {
      period = loc.trans("next_month");
    }

    return Stack(children: <Widget>[
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
                          padding: const EdgeInsets.symmetric(horizontal: 90.0),
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
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: new Text(
                            loc.trans("you_have_to_feed"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.4,
                child: PageView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 23.0),
                      child: PiggyFeedWidget(
                          willAcceptStream: willAcceptStream,
                          isAnimationPlaying: isAnimationPlaying,
                          isDisabled: _isDisabled,
                          onDrop: (id) => onCoinDrop(id),
                          piggy: item),
                    ),
                  ],
                ),
              ),
              item != null
                  ? PiggyProgress(
                      item: item.item,
                      saving: item.currentSaving.toDouble(),
                      targetPrice: item.targetPrice.toDouble())
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.13,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: PiggyButton(
                      disabled: _isDisabled,
                      text: loc.trans('feed_piggy'),
                      onClick: () => _feedPiggy(user.piggies.first.id)),
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
    ]);
  }
}
