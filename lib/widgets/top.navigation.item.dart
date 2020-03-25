import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopNavigationBarItem extends StatelessWidget {
  const TopNavigationBarItem({Key key, this.text, this.icon}) : super(key: key);

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
            size: MediaQuery.of(context).size.height * 0.06,
          ),
          text != null ? Text(text) : Container()
        ],
      ),
    );
  }
}
