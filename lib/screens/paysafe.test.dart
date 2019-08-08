import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaysafeCardPage extends StatefulWidget {
   PaysafeCardPage({Key key, this.title}) : super(key: key);
   final String title;
    @override 
   _PaysafeCardPageState createState() => new _PaysafeCardPageState();
}
class _PaysafeCardPageState extends State<PaysafeCardPage> {
     @override
     Widget build(BuildContext context) {
         return new Scaffold(
              appBar: new AppBar(
              title: new Text("PaysafeCard"),
              ),
              body: WebView(
                initialUrl: "https://private-anon-26455cec77-paysafecardapien.apiary-proxy.com/v1/payments",
              ),
         );
     }
  }