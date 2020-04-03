import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.slider.dart';

class SavingDetails extends StatefulWidget {
  const SavingDetails({Key key, this.piggy}) : super(key: key);

  final Piggy piggy;

  @override
  _SavingDetailsState createState() => _SavingDetailsState();
}

class _SavingDetailsState extends State<SavingDetails> {
  String _getRemainingCoinsToCollect() {
    if (widget.piggy != null)
      return ((widget.piggy.targetPrice - widget.piggy.currentSaving)
              .ceil()
              .toString() +
          " / " +
          ((widget.piggy.targetPrice - widget.piggy.currentSaving) * 350)
              .toString());
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.piggy.item)),
      body: Container(
        decoration: coinBackground(context, UserType.adult),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    widget.piggy.item,
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(loc.trans('home')),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                      '${loc.trans('collecting_start_date')} ${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}'),
                ),
              ],
            ),
            Image.asset('assets/images/piggybank.png'),
            Opacity(
              opacity: 0.8,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            right: 45.0,
                            left: 45.0,
                            bottom: MediaQuery.of(context).size.height * 0.04),
                        child: PiggySlider(
                          maxMinTextTrailing: Text("€"),
                          value: widget.piggy.currentSaving.toDouble(),
                          onChange: (val) {},
                          maxVal: widget.piggy.targetPrice.toDouble(),
                          trackColor: Colors.white,
                          centerTextStyle:
                              TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.height * 0.05),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "${_getRemainingCoinsToCollect()}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                loc.trans('money_to_your_goal'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
