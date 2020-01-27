import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/navigation.redux.dart';
import 'package:redux/redux.dart';

typedef int OnNavigateTap(int index);

class PiggyNavigationBar extends StatelessWidget {
  PiggyNavigationBar({Key key, this.onNavigateTap, @required this.store})
      : super(key: key);

  final OnNavigateTap onNavigateTap;
  final Store<NavigationState> store;

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return BottomNavigationBar(
      onTap: (index) => onNavigateTap(index),
      items: [
        new BottomNavigationBarItem(
            title: new Text(loc.trans('home')), icon: Icon(Icons.home)),
        new BottomNavigationBarItem(
            title: new Text(loc.trans('saving')),
            icon: Icon(Icons.attach_money)),
        new BottomNavigationBarItem(
            title: new Text(loc.trans('tasks')),
            icon: Icon(FontAwesomeIcons.clipboardCheck)),
      ],
      currentIndex: store.state.index,
    );
  }
}
