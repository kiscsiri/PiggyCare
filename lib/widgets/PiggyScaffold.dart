import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piggybanx/localization/Localizations.dart';

class PiggyScaffold extends StatefulWidget {
  PiggyScaffold({Key key, this.body, this.bottomNavigationBar, this.appBar, this.backgroundColor})
      : super(key: key);
  final Widget body;
  final Widget bottomNavigationBar;
  final PreferredSizeWidget appBar;
  final Color backgroundColor;
  @override
  _PiggyScaffoldState createState() => new _PiggyScaffoldState();
}

class _PiggyScaffoldState extends State<PiggyScaffold> {
  alert(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(loc.trans("no_internet")),
          content: Text(loc.trans("check_internet")),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    (Connectivity().checkConnectivity()).then((value) {
      if (value == ConnectivityResult.none) {
        alert(context);
      }
    });
    return PiggyScaffold(
      backgroundColor: widget.backgroundColor,
      appBar: widget.appBar,
      body: widget.body,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
