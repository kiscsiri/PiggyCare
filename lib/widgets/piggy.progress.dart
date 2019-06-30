import 'dart:math';

import 'package:flutter/material.dart';

class PiggyProgress extends StatefulWidget {
  PiggyProgress({Key key, this.saving, this.targetPrice}) : super(key: key);
  final double saving;
  final double targetPrice;
  @override
  _PiggyProgressState createState() => new _PiggyProgressState();
}


class _PiggyProgressState extends State<PiggyProgress> {
  
  @override
  Widget build(BuildContext context) {
    final currentSavingPadding = (MediaQuery.of(context).size.width * (1 - widget.saving / widget.targetPrice));
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 0.5)),
            child: LinearProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              backgroundColor: Colors.white,
              value: widget.saving / widget.targetPrice,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("${widget.saving.toInt()}\$"),
              Padding(
                padding: EdgeInsets.only(left: max(currentSavingPadding - 88, 0), right: 0),
                child: Text("${widget.targetPrice.toInt()}\$"),
              )
            ],
          )
        ],
      ),
    );
  }
}
