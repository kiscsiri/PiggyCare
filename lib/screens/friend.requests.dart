import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/models/user/user.export.dart';
import 'package:piggycare/services/notification.services.dart';
import 'package:piggycare/services/user.services.dart';
import 'package:piggycare/widgets/piggy.widgets.export.dart';

class FirendRequestsScreen extends StatefulWidget {
  const FirendRequestsScreen(
      {Key key, @required this.currentUserId, this.userType})
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
    var store = StoreProvider.of<AppState>(context);
    try {
      var senderUser = await UserServices.acceptRequest(
          fromId, widget.currentUserId, store.state.user.userType);
      if (store.state.user.userType == UserType.donator) {
        store.dispatch(AddFamily(UserData(id: senderUser)));
      } else {
        store.dispatch(AddFamily(senderUser));
      }

      NotificationServices.sendNotificationAcceptFriendRequest(
          fromId, widget.currentUserId);
    } catch (err) {}
    Navigator.of(context).pop();
  }

  _refuse(String fromId) async {
    await UserServices.declineRequest(fromId, widget.currentUserId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(loc.trans('family_requests')),
        ),
        body: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: piggyFamilyBackgroundDecoration(context),
              ),
            ],
          ),
          new FutureBuilder<List<UserData>>(
            future: UserServices.getFriendRequests(
                widget.currentUserId), // a Future<String> or null
            builder:
                (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Press button to start');
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError)
                    return new Text(loc.trans('error'));
                  else if (snapshot.data.length == 0)
                    return Center(
                        child: Text(
                      loc.trans('no_friend_requests'),
                      textAlign: TextAlign.center,
                    ));
                  else
                    return ListView(
                        children: snapshot.data
                            .map((u) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 5),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: u.pictureUrl == null
                                                        ? AssetImage(
                                                            "lib/assets/images/piggy_nyito.png")
                                                        : NetworkImage(
                                                            u.pictureUrl))),
                                          ),
                                        ),
                                        title: Text(u.name ?? u.email),
                                        trailing: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: Row(
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(Icons.clear,
                                                      color: Colors.red),
                                                  onPressed: () =>
                                                      _refuse(u.id)),
                                              IconButton(
                                                  icon: Icon(Icons.done,
                                                      color: Colors.green),
                                                  onPressed: () =>
                                                      _accept(u.id))
                                            ],
                                          ),
                                        )),
                                  ),
                                ))
                            .toList());
              }
            },
          )
        ]));
  }
}
