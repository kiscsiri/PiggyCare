import 'package:flutter/material.dart';

class SecondRegisterPage extends StatefulWidget {
   SecondRegisterPage({Key key, this.title}) : super(key: key);
   final String title;
    @override 
   _SecondRegisterPageState createState() => new _SecondRegisterPageState();
}
class _SecondRegisterPageState extends State<SecondRegisterPage> {
     @override
     Widget build(BuildContext context) {
         return new Scaffold(
              appBar: new AppBar(
              title: new Text(widget.title),
              ),
              body: new Center(
                   child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          new Text('SecondRegister oldal')
                     ],
                ),
             ),
         );
     }
  }