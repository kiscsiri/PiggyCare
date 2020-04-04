import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piggycare/enums/userType.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/user/user.export.dart';
import 'package:piggycare/services/user.services.dart';
import 'package:piggycare/widgets/piggy.widgets.export.dart';

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
  var _searchString = "";

  @override
  void initState() {
    _searchString = widget.searchString;
    super.initState();
  }

  _search(val) {
    setState(() {
      _searchString = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(loc.trans('add_family')),
        ),
        body: Stack(children: [
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: PiggyInput(
                    hintText: "Keresés",
                    inputIcon: FontAwesomeIcons.search,
                    onSubmit: (val) => _search(val),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: new FutureBuilder<List<UserData>>(
                      future:
                          UserServices.getUsers(_searchString, widget.userType),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<UserData>> snapshot) {
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
                                  child: Text(loc.trans('no_user_found')));
                            else
                              return ListView(
                                  children: snapshot.data
                                      .map((u) => SearchTile(
                                            user: u,
                                            currentUserId: widget.currentUserId,
                                          ))
                                      .toList());
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
