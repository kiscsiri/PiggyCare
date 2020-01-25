import 'package:flutter/material.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/services/user.services.dart';

class FirendRequestsScreen extends StatefulWidget {
  const FirendRequestsScreen({Key key, @required this.currentUserId})
      : super(key: key);

  final String currentUserId;
  @override
  _FirendRequestsScreenState createState() => _FirendRequestsScreenState();
}

class _FirendRequestsScreenState extends State<FirendRequestsScreen> {
  var users = List<UserData>();
  @override
  void initState() {
    super.initState();
  }

  _accept(String id) async {
    await UserServices.sendRequest(widget.currentUserId, id);
  }

  _refuse(String id) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Result"),
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
                return new Text('Awaiting result...');
              default:
                if (snapshot.hasError)
                  return new Text('Error');
                else
                  return ListView(
                      children: snapshot.data
                          .map((u) => ListTile(
                              title: Text(u.name ?? ""),
                              trailing: Row(children: <Widget>[
                                IconButton(icon: Icon(Icons.clear, color: Colors.red), onPressed: () => _accept(u.id)),
                                IconButton(icon: Icon(Icons.done, color:Colors.green), onPressed: () => _refuse(u.id))
                              ],)))
                          .toList());
            }
          },
        ));
  }
}
