import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/screens/child.chores.details.dart';
import 'package:piggycare/services/piggy.page.services.dart';
import 'package:piggycare/widgets/piggy.widgets.export.dart';
import 'package:redux/redux.dart';

class ParentChoresPage extends StatefulWidget {
  ParentChoresPage({Key key}) : super(key: key);

  @override
  _ParentChoresPageState createState() => new _ParentChoresPageState();
}

class _ParentChoresPageState extends State<ParentChoresPage> {
  var isChildSelected = false;
  var selectedId = "";

  void _navigateToChild(String id) {
    var store = StoreProvider.of<AppState>(context);
    setState(() {
      selectedId = id;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChildDetailsWidget(
              documentId: selectedId.toString(),
              initChildren: store.state.user.children,
            )));
  }

  Widget getGyerekMegtakaritasok(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var store = StoreProvider.of<AppState>(context);
    var children = store.state.user.children;
    var gyerekLista = List.generate(
        children.length,
        (int i) => PiggyButton(
              text: (children[i].name ?? children[i].email) +
                  " ${loc.trans('his_savings')}",
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
          loc.trans('add_your_children_for_information'),
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  _showAddChild(Store<AppState> store) async {
    await showAddNewChildModal(context, store);
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var loc = PiggyLocalizations.of(context);
    return isChildSelected
        ? ChildDetailsWidget(
            documentId: selectedId.toString(),
            initChildren: store.state.user.children,
          )
        : Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: piggyBackgroundDecoration(context),
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
                        loc.trans('children_savings'),
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    StoreConnector<AppState, AppState>(
                      converter: (store) => store.state,
                      builder: (context, store) =>
                          getGyerekMegtakaritasok(context),
                    ),
                    GestureDetector(
                      onTap: () async => await _showAddChild(store),
                      child: Text(
                        loc.trans('add_child_for_parent'),
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
