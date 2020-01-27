import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:piggybanx/enums/userType.dart';

class PiggyProgress extends StatefulWidget {
  PiggyProgress(
      {Key key, this.saving, this.targetPrice, this.item, this.userType})
      : super(key: key);
  final double saving;
  final double targetPrice;
  final String item;
  final UserType userType;
  @override
  _PiggyProgressState createState() => new _PiggyProgressState();
}

class _PiggyProgressState extends State<PiggyProgress> {
  @override
  Widget build(BuildContext context) {
    final currentSavingPadding = (MediaQuery.of(context).size.width *
        (1 - widget.saving / widget.targetPrice));
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 14.0, left: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width * 0.87,
            lineHeight: 13.0,
            percent: (widget.saving > widget.targetPrice
                ? widget.targetPrice
                : widget.saving / widget.targetPrice),
            backgroundColor: Colors.grey,
            progressColor: Theme.of(context).primaryColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("${widget.saving.toInt()}\$"),
              Padding(
                padding: EdgeInsets.only(
                    left: max(currentSavingPadding - 90, 10), right: 10),
                child: Text("${widget.targetPrice.toInt()}\$"),
              )
            ],
          )
        ],
      ),
    );
  }
}
