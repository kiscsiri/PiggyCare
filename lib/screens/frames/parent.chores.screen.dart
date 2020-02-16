import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
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
  var selectedId = "";

  void _navigateToChild(String id) {
    setState(() {
      selectedId = id;
      isChildSelected = true;
    });
  }

  Widget getGyerekMegtakaritasok(BuildContext context) {
    var children = widget.store.state.user.children;
    var gyerekLista = List.generate(
        children.length,
        (int i) => PiggyButton(
              text: (children[i].name ?? children[i].email) + " megtakarításai",
              onClick: () => _navigateToChild(children[i].documentId),
              color: Colors.white,
            ));
    if (gyerekLista.length != 0) {
      return Column(
        children: gyerekLista,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Vedd fel a gyerekeidet ismerősnek, hogy lásd a megtakarításaikat!",
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  _showAddChild() async {
    await showAddNewChildModal(context, widget.store);
  }

  @override
  Widget build(BuildContext context) {
    return isChildSelected
        ? ChildDetailsWidget(
            documentId: selectedId.toString(),
            store: widget.store,
          )
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
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    getGyerekMegtakaritasok(context),
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
