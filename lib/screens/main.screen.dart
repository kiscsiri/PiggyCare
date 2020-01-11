import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/navigation.redux.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/screens/frames/piggy.screen.dart';
import 'package:piggybanx/screens/frames/savings.screen.dart';
import 'package:piggybanx/screens/frames/settings.screen.dart';
import 'package:piggybanx/screens/startup.screen.dart';
import 'package:piggybanx/widgets/piggy.navigationBar.dart';
import 'package:redux/redux.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.store}) : super(key: key);

  final String title = "Piggybanx";

  final Store<AppState> store;

  final navigationStore = new Store<NavigationState>(navigationReducer,
      initialState: new NavigationState(index: 0));

  final swipeKey = GlobalKey();
  final _pageController = new PageController(initialPage: 0, keepPage: true);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  _navigate(int index) {
    widget._pageController.animateToPage(index,
        curve: Curves.linear, duration: new Duration(milliseconds: 350));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget._pageController.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    widget.store.dispatch(InitUserData(UserData()));
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) => new StartupPage(
                  store: widget.store,
                )));
  }

  List<Widget> getFrames() {
    return [
      new PiggyPage(store: widget.store),
      new SavingsPage(
          store: widget.store, pageController: widget._pageController),
      // widget.store.state.user.userType == UserType.adult
      //     ? ParentChoresPage()
      //     : ChildChoresPage(),
      new SettingsPage(store: widget.store)
    ];
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var user = widget.store.state.user;

    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
          appBar: AppBar(
            title: Text("PiggyBanx"),
          ),
          endDrawer: Drawer(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: user.pictureUrl == null
                                      ? AssetImage(
                                          "lib/assets/images/piggy_nyito.png")
                                      : NetworkImage(
                                          widget.store.state.user.pictureUrl))),
                        ),
                        Text(widget.store.state.user.name),
                      ],
                    ),
                  ),
                  if (widget.store.state.user.userType == UserType.child)
                    ListTile(
                      title: Text(loc.trans('add_parent')),
                      onTap: () {},
                    ),
                  if (widget.store.state.user.userType == UserType.adult)
                    ListTile(
                      title: Text(loc.trans('add_child')),
                      onTap: () {},
                    ),
                  ListTile(
                    title: Text(loc.trans('eula_short')),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Profil'),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(loc.trans('terms_use')),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(loc.trans('logout')),
                    onTap: () {
                      logout();
                    },
                  ),
                ],
              ),
            ),
          ),
          body: new PageView(
            children: getFrames(),
            onPageChanged: (int index) {
              setState(() {
                widget.navigationStore
                    .dispatch(SetNavigationIndex(index: index));
              });
            },
            controller: widget._pageController,
          ),
          bottomNavigationBar: PiggyNavigationBar(
            onNavigateTap: (index) => _navigate(index),
            store: widget.navigationStore,
          )),
    );
  }
}
