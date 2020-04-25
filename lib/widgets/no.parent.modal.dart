import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/screens/search.user.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/piggy.modal.widget.dart';

import 'piggy.button.dart';

class NoParentModal extends StatefulWidget {
  @override
  _NoParentModalState createState() => _NoParentModalState();
}

class _NoParentModalState extends State<NoParentModal> {
  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return PiggyModal(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Szia! Ahhoz, hogy létre tudd hozni az első Malacperselyedet, hozzá kell adnod a szülőt az ismerőseidhez.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        PiggyButton(
          onClick: () async {
            var searchString = await showUserAddModal(
                context, StoreProvider.of<AppState>(context));
            if (searchString.isNotEmpty)
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserSearchScreen(
                            currentUserId: store.state.user.id,
                            userType: store.state.user.userType,
                            searchString: searchString,
                          )));
            Navigator.of(context).pop();
          },
          text: "SZÜLŐ HOZZÁADÁSA",
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
        ),
        Text("Ha még nem regisztrált…"),
        PiggyButton(
          onClick: null,
          text: "SZÜLŐ MEGHÍVÁSA",
          disabled: true,
        ),
      ],
    );
  }
}
