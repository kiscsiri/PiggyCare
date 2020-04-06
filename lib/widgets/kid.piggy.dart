import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggycare/Enums/period.dart';
import 'package:piggycare/Enums/userType.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/models/piggy/piggy.export.dart';
import 'package:piggycare/models/user/user.export.dart';
import 'package:piggycare/screens/search.user.dart';
import 'package:piggycare/services/notification.services.dart';
import 'package:piggycare/services/piggy.page.services.dart';
import 'package:piggycare/services/user.services.dart';
import 'package:piggycare/widgets/nopiggy.widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:redux/redux.dart';
import 'create.piggy.dart';
import 'piggy.coin.dart';
import 'piggy.main.dart';
import 'piggy.progress.dart';

class PiggyWidget extends StatefulWidget {
  PiggyWidget(
      {Key key, @required this.initialPiggy, @required this.timeUntilNextFeed})
      : super(key: key);

  final Piggy initialPiggy;
  final Duration timeUntilNextFeed;

  @override
  _PiggyWidgetState createState() => new _PiggyWidgetState();
}

class _PiggyWidgetState extends State<PiggyWidget>
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

  void onCoinDrop(int piggyId, Store<AppState> store) {
    setState(() {
      isOnTarget = false;
      _feedPiggy(piggyId, store);
    });
  }

  @override
  void initState() {
    super.initState();

    piggy = widget.initialPiggy;

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
          timeUntilNextFeed = (widget.timeUntilNextFeed * -1)
              .toString()
              .replaceRange(
                  widget.timeUntilNextFeed.toString().lastIndexOf('.'),
                  (widget.timeUntilNextFeed * -1).toString().length,
                  '');
        });
      });
    _animationController.forward();

    willAcceptStream = new BehaviorSubject<bool>();
    willAcceptStream.add(false);
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: widget.timeUntilNextFeed.inSeconds % 60),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.duration = new Duration(seconds: 60);
          setState(() {
            tween.begin = widget.timeUntilNextFeed.inSeconds % 60;
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

  Future<void> _feedPiggy(int piggyId, Store<AppState> store) async {
    var tempLevel = store.state.user.piggyLevel;

    store.dispatch(FeedPiggy(store.state.user.id, piggyId));
    NotificationServices.feedPiggy(store.state.user.id);

    if (tempLevel.index == store.state.user.piggyLevel.index) {
      await loadAnimation(false, this, context, store, piggyId);
    } else {
      await loadAnimation(true, this, context, store, piggyId);
    }

    setState(() {
      // piggy.currentSaving += 10;
      // piggy = store.state.user.piggies
      //     .where((element) => element.isApproved ?? false)
      //     .singleWhere((p) => p.id == piggy.id);
    });
  }

  _changeCreatePiggyState() async {
    var store = StoreProvider.of<AppState>(context);
    var searchString = await showUserAddModal(context, store);

    if (searchString.isNotEmpty) {
      var userId = await Navigator.push<String>(
          context,
          MaterialPageRoute(
              builder: (context) => new UserSearchScreen(
                    currentUserId: store.state.user.id,
                    userType: store.state.user.userType,
                    searchString: searchString,
                    isNearbySearch: false,
                  )));
      var user = await UserServices.getUserById(userId);
      setState(() {
        if (user.piggies.first != null) piggy = user.piggies.first;
      });
    }
  }

  _changePiggyData(index, Store<AppState> store) {
    setState(() {
      piggy = store.state.user.piggies
          .where((element) => element.isApproved ?? false)
          .singleWhere((d) => d.id == index, orElse: null);
    });
  }

  Future<void> selectPiggy(BuildContext context, Store<AppState> store) async {
    var newId = await showPiggySelector(context, store);
    if (newId != null) {
      _changePiggyData(newId, store);
    }
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var store = StoreProvider.of<AppState>(context);

    var user = store.state.user;

    var validatedPiggies =
        user.piggies.where((element) => element.isApproved ?? false).toList();

    if (piggy != null) {
      validatedPiggies.add(piggy);
    }
    bool _isDisabled = piggy == null ? false : !piggy.isFeedAvailable;
    if (piggy == null && validatedPiggies.length != 0) {
      piggy = validatedPiggies
          .where((element) => element.isApproved ?? false)
          .first;
    }
    _coinVisible = user.userType == UserType.donator;

    String period;
    if (user.period == Period.daily) {
      period = loc.trans("tomorrow");
    } else if (user.period == Period.weely) {
      period = loc.trans("next_week");
    } else if (user.period == Period.monthly) {
      period = loc.trans("next_month");
    }

    return (validatedPiggies.length == 0 || creatingPiggy)
        ? (creatingPiggy
            ? AnimatedOpacity(
                opacity: creatingPiggy ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: CreatePiggyWidget(
                  navigateToPiggyWidget: () => _changeCreatePiggyState(),
                ),
              )
            : NoPiggyWidget(
                type: store.state.user.userType,
                navigateToCreateWidget: () => _changeCreatePiggyState(),
              ))
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                  0.5,
                  0.8,
                  0.85,
                  1
                ],
                    colors: [
                  Colors.white,
                  Colors.grey[400],
                  Colors.white,
                  Colors.grey[100]
                ])),
            child: Stack(children: <Widget>[
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
                                    style:
                                        Theme.of(context).textTheme.headline3,
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
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *
                                      0.16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 20),
                                        child: new Text(
                                          loc.trans('money_box_name'),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 20),
                                        child: new Text(
                                          '${piggy.item}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 10),
                                        child: GestureDetector(
                                          onTap: () async =>
                                              await selectPiggy(context, store),
                                          child: new Text(
                                              loc.trans('change_box'),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                      Container(
                        child: Stack(children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.13),
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: PiggyFeedWidget(
                                scale: 1,
                                willAcceptStream: willAcceptStream,
                                isAnimationPlaying: isAnimationPlaying,
                                isDisabled: _isDisabled,
                                onDrop: (val) => onCoinDrop(val, store),
                                piggy: piggy),
                          ),
                        ]),
                      ),
                      piggy != null
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0),
                              child: PiggyProgress(
                                  userType: user.userType,
                                  item: piggy.item,
                                  saving: piggy.currentSaving.toDouble(),
                                  targetPrice: piggy.targetPrice.toDouble()),
                            )
                          : Container(),
                    ]),
              )),
              (!_isDisabled)
                  ? PiggyCoin(
                      coinController: _coinAnimation,
                      coinVisible: _coinVisible,
                      isOnTarget: isOnTarget,
                      willAcceptStream: willAcceptStream,
                      scale: MediaQuery.of(context).size.height * 0.0003,
                    )
                  : Container(),
            ]),
          );
  }
}
