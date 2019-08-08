import 'package:flutter/material.dart';

typedef void OnClick();

class PiggyButton extends StatelessWidget {
  PiggyButton(
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
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.09,
          decoration: new BoxDecoration(
              color:
                  (disabled) ? Colors.grey : Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.circular(70.0),
              boxShadow: [
                new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8.0,
                  spreadRadius: 2,
                  offset: new Offset(3, 7.0),
                ),
              ]),
          child: FlatButton(
            onPressed: null,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                text,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
