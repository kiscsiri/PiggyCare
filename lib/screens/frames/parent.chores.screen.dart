import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/screens/child.chores.details.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:redux/redux.dart';

class ParentChoresPage extends StatefulWidget {
  ParentChoresPage({Key key, this.store, this.pageController})
      : super(key: key);

  final Store<AppState> store;
  final PageController pageController;
  @override
  _ParentChoresPageState createState() => new _ParentChoresPageState();
}

class _ParentChoresPageState extends State<ParentChoresPage> {
  var isChildSelected = false;
  var selectedIndex = 0;

  void _navigate() {
    widget.pageController.animateToPage(1,
        curve: Curves.linear, duration: new Duration(milliseconds: 350));
  }

  void _navigateToChild(int id) {
    setState(() {
      selectedIndex = id;
      isChildSelected = true;
    });
  }

  _showAddChild() async {
    await showAddNewChildModal(context, widget.store);
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return isChildSelected
        ? ChildDetailsWidget(id: selectedIndex.toString())
        : Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration:
                      piggyBackgroundDecoration(context, UserType.adult),
                ),
              ],
            ),
            Container(
              child: Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        "Gyerek Megtakarítások",
                        style: Theme.of(context).textTheme.display2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    PiggyButton(
                      color: Colors.white,
                      text: "Petike megtakarításai",
                      onClick: () => _navigateToChild(0),
                    ),
                    PiggyButton(
                      color: Colors.white,
                      text: "Kitti megtakarításai",
                      onClick: () => _navigateToChild(1),
                    ),
                    GestureDetector(
                      onTap: () async => await _showAddChild(),
                      child: Text(
                        "Gyerek hozzáadás",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]);
  }
}
