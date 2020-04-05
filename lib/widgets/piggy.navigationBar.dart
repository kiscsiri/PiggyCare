import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/navigation.redux.dart';
import 'package:redux/redux.dart';

typedef int OnNavigateTap(int index);

class PiggyNavigationBar extends StatelessWidget {
  PiggyNavigationBar(
      {Key key,
      this.onNavigateTap,
      @required this.store,
      @required this.userType})
      : super(key: key);

  final OnNavigateTap onNavigateTap;
  final Store<NavigationState> store;
  final UserType userType;

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return BottomNavigationBar(
      onTap: (index) => onNavigateTap(index),
      type: BottomNavigationBarType.fixed,
      items: [
        new BottomNavigationBarItem(
            title: new Text("Piggy"),
            icon: Icon(
              Icons.home,
            )),
        new BottomNavigationBarItem(
            title: new Text("Perselyek"),
            icon: Icon(
              Icons.attach_money,
            )),
        new BottomNavigationBarItem(
            title: userType == UserType.business
                ? Text('Adományok')
                : Text(loc.trans('tasks')),
            icon: Icon(FontAwesomeIcons.handHoldingUsd)),
      ],
      currentIndex: store.state.index,
    );
  }
}
