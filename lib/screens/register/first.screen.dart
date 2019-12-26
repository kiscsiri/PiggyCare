import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../models/appState.dart';

class FirstRegisterPage extends StatefulWidget {
  FirstRegisterPage({Key key, this.store}) : super(key: key);

  final Store<AppState> store;
  @override
  _FirstRegisterPageState createState() => new _FirstRegisterPageState();
}

class _FirstRegisterPageState extends State<FirstRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text('User típus választó oldal')],
        ),
      ),
    );
  }
}
