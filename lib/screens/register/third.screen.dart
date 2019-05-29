import 'package:flutter/material.dart';

class ThirdRegisterPage extends StatefulWidget {
   ThirdRegisterPage({Key key, this.title}) : super(key: key);
   final String title;
    @override 
   _ThirdRegisterPageState createState() => new _ThirdRegisterPageState();
}
class _ThirdRegisterPageState extends State<ThirdRegisterPage> {
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
                          new Text('ThirdRegister oldal')
                     ],
                ),
             ),
         );
     }
  }