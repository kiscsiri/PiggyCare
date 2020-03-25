import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/navigation.redux.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/screens/frames/child.chores.screen.dart';
import 'package:piggybanx/screens/frames/child.savings.dart';
import 'package:piggybanx/screens/frames/parent.chores.screen.dart';
import 'package:piggybanx/screens/frames/piggy.screen.dart';
import 'package:piggybanx/screens/frames/social.screen.dart';
import 'package:piggybanx/screens/friend.requests.dart';
import 'package:piggybanx/screens/search.user.dart';
import 'package:piggybanx/screens/startup.screen.dart';
import 'package:piggybanx/services/notification.handler.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/exit.dialog.dart';
import 'package:piggybanx/widgets/piggy.navigationBar.dart';
import 'package:redux/redux.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  final navigationStore = new Store<NavigationState>(navigationReducer,
      initialState: new NavigationState(index: 0));
  final _pageController = new PageController(initialPage: 0, keepPage: true);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  _navigate(int index) {
    widget._pageController.animateToPage(index,
        curve: Curves.linear, duration: new Duration(milliseconds: 350));
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async =>
            await onResumeNotificationHandler(
                message, context, widget._pageController),
        onLaunch: (Map<String, dynamic> message) async =>
            await onResumeNotificationHandler(
                message, context, widget._pageController),
        onResume: (Map<String, dynamic> message) async =>
            await onResumeNotificationHandler(
                message, context, widget._pageController));
    super.initState();
  }

  @override
  void dispose() {
    widget._pageController.dispose();
    super.dispose();
  }

  Future<void> logout(Store<AppState> store) async {
    var isExit = await showExitModal(context);
    if (isExit ?? false) {
      await FirebaseAuth.instance.signOut();
      store.dispatch(InitUserData(UserData()));
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => new StartupPage()));
    }
  }

  List<Widget> getFrames() {
    var store = StoreProvider.of<AppState>(context);
    return [
      new PiggyPage(),
      ChildSavingScreen(
        initFeedPerPeriod: store.state.user.feedPerPeriod,
      ),
      if (store.state.user.userType != UserType.individual)
        store.state.user.userType == UserType.child
            ? ChildChoresPage()
            : ParentChoresPage(),
      PiggySocial()
    ];
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var store = StoreProvider.of<AppState>(context);
    var user = store.state.user;

    return WillPopScope(
      onWillPop: () async {
        var isExitTrue = await showExitModal(context);
        if (isExitTrue ?? false) {
          exit(0);
        }
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("PiggyBanx"),
          ),
          resizeToAvoidBottomInset: false,
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
                                          store.state.user.pictureUrl))),
                        ),
                        Text(store.state.user.name ?? ""),
                      ],
                    ),
                  ),
                  if (store.state.user.userType == UserType.child)
                    ListTile(
                      title: Text(loc.trans('add_parent')),
                      onTap: () async {
                        var searchString =
                            await showUserAddModal(context, store);
                        if (searchString.isNotEmpty)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new UserSearchScreen(
                                        currentUserId: store.state.user.id,
                                        userType: store.state.user.userType,
                                        searchString: searchString,
                                      )));
                      },
                    ),
                  if (store.state.user.userType == UserType.adult)
                    ListTile(
                      title: Text(loc.trans('add_child')),
                      onTap: () async {
                        var searchString =
                            await showUserAddModal(context, store);
                        if (searchString.isNotEmpty)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new UserSearchScreen(
                                        currentUserId: store.state.user.id,
                                        userType: store.state.user.userType,
                                        searchString: searchString,
                                      )));
                      },
                    ),
                  ListTile(
                    title: Text(loc.trans('requests')),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new FirendRequestsScreen(
                                    currentUserId: store.state.user.id,
                                    userType: store.state.user.userType,
                                  )));
                    },
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
                      logout(store);
                    },
                  ),
                ],
              ),
            ),
          ),
          body: PageView(
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
            userType: store.state.user.userType,
          )),
    );
  }
}
