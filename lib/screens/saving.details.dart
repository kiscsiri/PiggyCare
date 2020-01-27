import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
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
    if (widget.piggy.currentFeedAmount != null)
      return ((widget.piggy.targetPrice - widget.piggy.currentSaving) /
              widget.piggy.currentFeedAmount)
          .toString();
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.piggy.item)),
      body: Container(
        decoration: coinBackground(context, UserType.adult),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  widget.piggy.item,
                  style: Theme.of(context).textTheme.display2,
                ),
                Text("Money box"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                      'Start date: ${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}'),
                ),
              ],
            ),
            Image.asset('assets/images/piggybank.png'),
            Opacity(
              opacity: 0.8,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            right: 45.0,
                            left: 45.0,
                            bottom: MediaQuery.of(context).size.height * 0.05),
                        child: PiggySlider(
                          maxMinTextTrailing: Text("\$"),
                          value: widget.piggy.currentSaving.toDouble(),
                          onChange: (val) {},
                          trackColor: Colors.white,
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
                                    'You have to collect ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    " ${_getRemainingCoinsToCollect()}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                "Piggy Coin to reach your goal!",
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
