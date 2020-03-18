import 'package:flutter/material.dart';
import 'package:piggybanx/widgets/piggy.button.dart';

Future<bool> showExitModal(BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Text(
                  "Valóban kilépsz?",
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: PiggyButton(
                    text: "IGEN",
                    onClick: () async {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: PiggyButton(
                    text: "MÉGSE",
                    onClick: () async {
                      Navigator.of(context).pop(false);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      });
}
