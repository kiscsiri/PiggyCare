import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'piggy.widgets.export.dart';

class PiggyFacebookButton extends StatelessWidget {
  PiggyFacebookButton(
      {Key key, @required this.text, this.onClick, this.disabled = false})
      : super(key: key);
  final String text;
  final OnClick onClick;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !disabled
          ? () async {
              onClick();
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: new Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.04,
          decoration: new BoxDecoration(
              color: (disabled) ? Colors.grey : Colors.blue,
              borderRadius: BorderRadius.circular(7.0)),
          child: FlatButton(
            onPressed: null,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    FontAwesomeIcons.facebookF,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
