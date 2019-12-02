import 'package:flutter/material.dart';
import 'package:piggybanx/services/services.export.dart';
import 'package:provider/provider.dart';

class ParentChoresPage extends StatefulWidget {
  ParentChoresPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ParentChoresPageState createState() => new _ParentChoresPageState();
}

class _ParentChoresPageState extends State<ParentChoresPage> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ChoreFirebaseServices>(context);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text('ParentChores oldal')],
        ),
      ),
    );
  }
}
