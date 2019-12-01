import 'package:flutter/material.dart';

class FirstRegisterPage extends StatefulWidget {
  FirstRegisterPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _FirstRegisterPageState createState() => new _FirstRegisterPageState();
}

class _FirstRegisterPageState extends State<FirstRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text('User típus választó oldal')],
        ),
      ),
    );
  }
}
