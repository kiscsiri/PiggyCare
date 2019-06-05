import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';

typedef int OnNavigateTap(int index);

class PiggyNavigationBar extends StatelessWidget {
  PiggyNavigationBar({Key key, this.onNavigateTap}) : super(key: key);
  
  final OnNavigateTap onNavigateTap;

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return BottomNavigationBar(
          onTap: (index) => onNavigateTap(index),
          items: [
            new BottomNavigationBarItem(
                title: new Text(loc.trans('home')), icon: Icon(Icons.home)),
            new BottomNavigationBarItem(
                title: new Text(loc.trans('savings') ), icon: Icon(Icons.attach_money)),
            new BottomNavigationBarItem(
                title: new Text(loc.trans('settings')), icon: Icon(Icons.settings))
          ],
        );
  }
}
