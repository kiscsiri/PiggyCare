import 'package:flutter/material.dart';
import 'package:piggycare/models/user/user.export.dart';

class SearchTile extends StatelessWidget {
  const SearchTile(
      {Key key, @required this.user, this.currentUserId, this.onSelect})
      : super(key: key);

  final UserData user;
  final String currentUserId;
  final Function(String) onSelect;
  _navigateToBusiness(businessId) async {
    onSelect(businessId);
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
                onPressed: () async => await _navigateToBusiness(user.id),
                child: Text(
                  "Donate+",
                  style: TextStyle(color: Colors.white),
                ))),
      ),
    );
  }
}
