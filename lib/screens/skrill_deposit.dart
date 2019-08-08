import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SkrillPage extends StatelessWidget {
   SkrillPage({Key key, this.title}) : super(key: key);
   final String title;

    @override
     Widget build(BuildContext context) {
         return new Scaffold(
              appBar: new AppBar(
              title: Text("Skrill Deposit"),
              ),
              body: new Center(
                   child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          Container(
                            child: WebView(
                              initialUrl: "https://account.skrill.com/wallet/ng/deposit/card/instruments",
                              javascriptMode: JavascriptMode.unrestricted,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          )
                     ],
                ),
             ),
         );
     }
}