import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/Enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/screens/search.user.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/no.parent.modal.dart';
import 'package:piggybanx/widgets/piggy.button.dart';

class NoPiggyWidget extends StatefulWidget {
  NoPiggyWidget({Key key, this.navigateToCreateWidget, @required this.type})
      : super(key: key);

  final Function navigateToCreateWidget;
  final UserType type;
  @override
  _NoPiggyWidgetState createState() => new _NoPiggyWidgetState();
}

class _NoPiggyWidgetState extends State<NoPiggyWidget> {
  _addUser() async {
    await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return NoParentModal();
        });
    return;

    var store = StoreProvider.of<AppState>(context);
    var searchString = await showUserAddModal(context, store);
    if (searchString.isNotEmpty)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new UserSearchScreen(
                    currentUserId: store.state.user.id,
                    userType: store.state.user.userType,
                    searchString: searchString,
                  )));
  }

  _createPiggy() async {
    widget.navigateToCreateWidget();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var user = store.state.user;
    var loc = PiggyLocalizations.of(context);
    var isParentConnected =
        (user.userType == UserType.child && user.parentId == null);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 52.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(
              loc.trans("welcome_on_board"),
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
            new Text(
              isParentConnected
                  ? loc.trans("if_you_dont_have_family")
                  : loc.trans("if_you_dont_have"),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            new Text(
              loc.trans("lets_start"),
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 1.2,
              height: MediaQuery.of(context).size.height * 0.25,
              child: widget.type == UserType.child
                  ? Image.asset('assets/images/create_child.png')
                  : Image.asset('assets/images/adult_create.png'),
            ),
            isParentConnected
                ? PiggyButton(
                    text: loc.trans('add_family').toUpperCase(),
                    onClick: () => _addUser(),
                  )
                : PiggyButton(
                    text: loc.trans('create_money_box').toUpperCase(),
                    onClick: () => _createPiggy(),
                  )
          ],
        ),
      ),
    );
  }
}
