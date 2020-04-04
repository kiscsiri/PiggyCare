import 'package:flutter/material.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/widgets/piggy.button.dart';

class PiggyAfterStartupScreen extends StatefulWidget {
  PiggyAfterStartupScreen({Key key}) : super(key: key);

  @override
  _PiggyPageState createState() => new _PiggyPageState();
}

class _PiggyPageState extends State<PiggyAfterStartupScreen>
    with TickerProviderStateMixin {
  int counter = 0;
  bool isOnTarget = false;
  bool _isDisabled = true;
  bool isAnimationPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.asset('assets/images/Child-Login.png')),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 30),
                      child: Column(
                        children: <Widget>[
                          Text(
                            loc.trans('welcome'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20),
                          ),
                          Text(
                            loc.trans('saving_fun'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20),
                          )
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
