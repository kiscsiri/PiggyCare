import 'dart:math';

import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
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
          Container(
            height: 20.0,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 1.0),
                    borderRadius: new BorderRadius.all(Radius.circular(10.0))),
            child: LinearProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor),
              backgroundColor: Colors.grey,
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
