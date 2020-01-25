import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/services/user.services.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen(
      {Key key,
      @required this.searchString,
      @required this.userType,
      @required this.currentUserId})
      : super(key: key);

  final String searchString;
  final UserType userType;
  final String currentUserId;
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  var users = List<UserData>();
  @override
  void initState() {
    super.initState();
  }

  _sendRequest(String id) async {
    await UserServices.sendRequest(widget.currentUserId, id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Result"),
        ),
        body: new FutureBuilder<List<UserData>>(
          future: UserServices.getUsers(
              widget.searchString, widget.userType), // a Future<String> or null
          builder:
              (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text('Press button to start');
              case ConnectionState.waiting:
                return Center(child: Text('Awaiting result...'));
              default:
                if (snapshot.hasError)
                  return new Text('Error');
                else
                  return ListView(
                      children: snapshot.data
                          .map((u) => ListTile(
                              onTap: () async => await _sendRequest(u.id),
                              title: Text(u.name ?? ""),
                              trailing: Text(u.email ?? "")))
                          .toList());
            }
          },
        ));
  }
}
