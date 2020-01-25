import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/services/user.services.dart';

class FirendRequestsScreen extends StatefulWidget {
  const FirendRequestsScreen({Key key, @required this.currentUserId, this.userType})
      : super(key: key);

  final String currentUserId;
  final UserType userType;
  @override
  _FirendRequestsScreenState createState() => _FirendRequestsScreenState();
}

class _FirendRequestsScreenState extends State<FirendRequestsScreen> {
  var users = List<UserData>();
  @override
  void initState() {
    super.initState();
  }

  _accept(String fromId) async {
    await UserServices.acceptRequest(fromId, widget.currentUserId, widget.userType);
    Navigator.of(context).pop();
  }

  _refuse(String fromId) async {
    await UserServices.declineRequest(fromId, widget.currentUserId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Family Requests"),
        ),
        body: new FutureBuilder<List<UserData>>(
          future: UserServices.getFriendRequests(
              widget.currentUserId), // a Future<String> or null
          builder:
              (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text('Press button to start');
              case ConnectionState.waiting:
                return Center(child: new Text('Awaiting result...'));
              default:
                if (snapshot.hasError)
                  return new Text('Error');
                else
                  return ListView(
                      children: snapshot.data
                          .map((u) => ListTile(
                              title: Text(u.name ?? ""),
                              trailing: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 4,
                                child: Row(children: <Widget>[
                                  IconButton(icon: Icon(Icons.clear, color: Colors.red), onPressed: () => _refuse(u.id)),
                                  IconButton(icon: Icon(Icons.done, color:Colors.green), onPressed: () => _accept(u.id))
                                ],),
                              )))
                          .toList());
            }
          },
        ));
  }
}
