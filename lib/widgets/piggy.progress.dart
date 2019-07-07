import 'dart:math';

import 'package:flutter/material.dart';

class PiggyProgress extends StatefulWidget {
  PiggyProgress({Key key, this.saving, this.targetPrice, this.item})
      : super(key: key);
  final double saving;
  final double targetPrice;
  final String item;
  @override
  _PiggyProgressState createState() => new _PiggyProgressState();
}

class _PiggyProgressState extends State<PiggyProgress> {
  @override
  Widget build(BuildContext context) {
    final currentSavingPadding = (MediaQuery.of(context).size.width *
        (1 - widget.saving / widget.targetPrice));
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.22),
                  child: Text(widget.item ?? ""),
                ),
                (widget.saving > widget.targetPrice)
                    ? IconButton(
                        icon: Icon(Icons.add_shopping_cart,
                            size: 35, color: Theme.of(context).primaryColor),
                        onPressed: () {
                          Navigator.of(context).pushNamed('register');
                        },
                      )
                    : Container(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
                    )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 0.5)),
            child: LinearProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor),
              backgroundColor: Colors.white,
              value: widget.saving / widget.targetPrice,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("${widget.saving.toInt()}\$"),
              Padding(
                padding: EdgeInsets.only(
                    left: max(currentSavingPadding - 90, 10), right: 0),
                child: Text("${widget.targetPrice.toInt()}\$"),
              )
            ],
          )
        ],
      ),
    );
  }
}
