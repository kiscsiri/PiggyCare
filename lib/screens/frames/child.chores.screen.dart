import 'package:flutter/material.dart';
import 'package:piggybanx/models/store.dart';
import 'package:redux/redux.dart';

class ChildChoresPage extends StatefulWidget {
  ChildChoresPage({Key key, this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  _ChoresPageState createState() => new _ChoresPageState();
}

class _ChoresPageState extends State<ChildChoresPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text('Chores oldal')],
        ),
      ),
    );
  }
}
