import 'package:flutter/material.dart';
import 'package:piggycare/models/user/user.export.dart';
import 'package:piggycare/services/notification.modals.dart';
import 'package:piggycare/services/piggy.page.services.dart';
import 'package:piggycare/services/user.services.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({Key key, @required this.user, this.currentUserId})
      : super(key: key);

  final UserData user;
  final String currentUserId;

  _sendRequest(
      BuildContext context, String id, String name, String picUrl) async {
    bool isAck = await showAckDialog(
        context,
        Container(
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: picUrl == null
                        ? AssetImage("lib/assets/images/piggy_nyito.png")
                        : NetworkImage(picUrl)))),
        Text(
          "Biztosan elküldöd az ismerős kérelmet?",
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ));
    if (isAck ?? false) {
      try {
        await UserServices.sendRequest(currentUserId, id);
        await showRequestSent(context);
      } catch (err) {
        await showAlert(context, err.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Container(
        decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
                spreadRadius: 0.5,
                offset: Offset(
                  0.5,
                  0.5,
                ),
              ),
            ],
            color: Colors.white,
            borderRadius: new BorderRadius.all(
              Radius.circular(15.0),
            )),
        child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.13,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: user.pictureUrl == null
                              ? AssetImage("lib/assets/images/piggy_nyito.png")
                              : NetworkImage(user.pictureUrl)))),
            ),
            title: Text(user.name ?? user.email),
            trailing: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () async => await _sendRequest(
                    context, user.id, user.name ?? user.email, user.pictureUrl),
                child: Text(
                  "Add+",
                  style: TextStyle(color: Colors.white),
                ))),
      ),
    );
  }
}
