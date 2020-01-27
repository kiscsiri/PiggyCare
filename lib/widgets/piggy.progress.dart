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
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(widget.item ?? ""),
                ),
                (widget.saving > widget.targetPrice &&
                        widget.userType != UserType.child)
                    ? IconButton(
                        icon: Icon(Icons.add_shopping_cart,
                            size: 35, color: Theme.of(context).primaryColor),
                        onPressed: () {
                          Navigator.of(context).pushNamed('register');
                        },
                      )
                    : Container()
              ],
            ),
          ),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width * 0.87,
            lineHeight: 13.0,
            percent:
                (max(widget.saving, widget.targetPrice) / widget.targetPrice),
            backgroundColor: Colors.grey,
            progressColor: Theme.of(context).primaryColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("${widget.saving.toInt()}\$"),
              Padding(
                padding: EdgeInsets.only(
                    left: max(currentSavingPadding - 110, 10), right: 10),
                child: Text("${widget.targetPrice.toInt()}\$"),
              )
            ],
          )
        ],
      ),
    );
  }
}
