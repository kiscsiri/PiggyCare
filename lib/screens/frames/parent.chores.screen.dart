import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/screens/child.chores.details.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:redux/redux.dart';

class ParentChoresPage extends StatefulWidget {
  ParentChoresPage({Key key, this.store, this.pageController}) : super(key: key);

  final Store<AppState> store;
  final PageController pageController;
  @override
  _ParentChoresPageState createState() => new _ParentChoresPageState();
}

class _ParentChoresPageState extends State<ParentChoresPage> {
  var isChildSelected = false;
  var selectedIndex = 0;

  void _navigate() {
    widget.pageController.animateToPage(2,
        curve: Curves.linear, duration: new Duration(milliseconds: 350));
  }

  void _navigateToChild(int id) {
    setState(() {
      selectedIndex = id;
      isChildSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    isChildSelected ? ChildDetailsWidget(id: selectedIndex.toString()) :
    Container(
      decoration: piggyBackgroundDecoration(context, UserType.adult),
      child: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Savings"),
            Text(""),
            PiggyButton(
              text: "Saját megtakarítások",
              onClick: () => _navigate(),
            ),
            PiggyButton(
              text: "Petike megtakarításai",
              onClick: () => _navigateToChild(0),
            ),
            PiggyButton(
              text: "Kitti megtakarításai",
              onClick: () => _navigateToChild(1),
            )
          ],
        ),
      ),
    );
  }
}
