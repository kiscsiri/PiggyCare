import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:rxdart/rxdart.dart';

class PiggyTestPage extends StatefulWidget {
  PiggyTestPage({Key key}) : super(key: key);

  @override
  _PiggyPageState createState() => new _PiggyPageState();
}

class _PiggyPageState extends State<PiggyTestPage>
    with TickerProviderStateMixin {
  BehaviorSubject<bool> willAcceptStream;

  Tween<double> _tween;
  AnimationController _animationController;

  int counter = 0;
  bool isOnTarget = false;
  bool _isDisabled = true;
  bool isAnimationPlaying = false;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _tween = Tween(begin: 0.15, end: 0.25);
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

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(loc.trans("feed_piggy_to_save"))),
        ),
        body: new Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xFFcb435b),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.asset('assets/images/Baby-Normal.png')),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            loc.trans('welcome'),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            "Let's ...",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: _isDisabled
                                ? PiggyButton(
                                    disabled: !_isDisabled,
                                    text: loc.trans("register"),
                                    onClick: () => Navigator.pushNamed(
                                        context, 'register'))
                                : Container(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.10,
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
                      ],
                    )
                  ]),
            )));
  }
}
