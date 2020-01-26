import 'package:flutter/material.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
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
                  child: Text('Start date: ${DateTime.now().toLocal()}'),
                ),
              ],
            ),
            Image.asset('assets/images/piggybank.png'),
            Opacity(
              opacity: 0.8,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4,
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45.0),
                        child: PiggySlider(
                          maxMinTextTrailing: Text("\$"),
                          value: widget.piggy.currentSaving.toDouble(),
                          onChange: (val) {},
                          trackColor: Colors.white,
                        ),
                      ),
                      Text(
                        "You have to collect ${_getRemainingCoinsToCollect()} Piggy Coin to reach your goal!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
