import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/Enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/navigation.redux.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/screens/frames/child.chores.screen.dart';
import 'package:piggybanx/screens/frames/savings.dart';
import 'package:piggybanx/screens/frames/parent.chores.screen.dart';
import 'package:piggybanx/screens/frames/piggy.screen.dart';
import 'package:piggybanx/screens/frames/social.screen.dart';
import 'package:piggybanx/screens/friend.requests.dart';
import 'package:piggybanx/screens/profile.dart';
import 'package:piggybanx/screens/search.user.dart';
import 'package:piggybanx/screens/startup.screen.dart';
import 'package:piggybanx/services/analytics.service.dart';
import 'package:piggybanx/services/email.services.dart';
import 'package:piggybanx/services/notification.handler.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/services/user.services.dart';
import 'package:piggybanx/widgets/exit.dialog.dart';
import 'package:piggybanx/widgets/piggy.navigationBar.dart';
import 'package:piggybanx/services/notification.modals.dart';
import 'package:redux/redux.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  final navigationStore = new Store<NavigationState>(navigationReducer,
      initialState: new NavigationState(index: 0));
  final _pageController = new PageController(initialPage: 0, keepPage: true);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  String versionNumber;
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
            await onStartNotificationHandler(
                message, context, widget._pageController),
        onResume: (Map<String, dynamic> message) async =>
            await onResumeNotificationHandler(
                message, context, widget._pageController));
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        versionNumber = '${packageInfo.version}.${packageInfo.buildNumber}';
      });
    });

    Future.delayed(Duration.zero, () {
      var store = StoreProvider.of<AppState>(context);
      if (store.state.user.initAutoShareSeen) {
        showAutmaticShareModal(context).then((value) async {
          var user = UserData.fromUserData(store.state.user);
          user.isAutoPostEnabled = value ?? false;
          user.initAutoShareSeen = true;
          if (store.state.user.initAutoShareSeen) {
          } else {
            await UserServices.updateUser(user);
            await UserServices.setInitAutoShareSetSeen(user.documentId, true);
            store.dispatch(InitAutoShareSet(true, value ?? false));
          }
        });
      }
    });
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
      AnalyticsService.logLogout();
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => new StartupPage()));
    }
  }

  List<Widget> getFrames() {
    var store = StoreProvider.of<AppState>(context);
    return [
      new PiggyWidget(
        initialPiggy: store.state.user.piggies
                    .where((element) => element.isApproved ?? false)
                    .length !=
                0
            ? store.state.user.piggies
                .where((element) => element.isApproved ?? false)
                .first
            : null,
        timeUntilNextFeed: store.state.user.timeUntilNextFeed,
      ),
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
          AnalyticsService.logLogout();
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
                        Hero(
                          tag: "profilePic",
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: user.pictureUrl == null
                                        ? AssetImage(
                                            "assets/images/Child-Normal.png")
                                        : NetworkImage(
                                            store.state.user.pictureUrl))),
                          ),
                        ),
                        Hero(
                          tag: "name",
                          child: Text(store.state.user.name ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ],
                    ),
                  ),
                  if (store.state.user.userType == UserType.child)
                    ListTile(
                      title: Text(loc.trans('add_parent'),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
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
                      title: Text(loc.trans('add_child'),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
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
                    title: Text(loc.trans('requests'),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
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
                  if (user.userType == UserType.adult)
                    ListTile(
                      title: Text(loc.trans('invite_child_menu'),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      onTap: () async {
                        var email = await showUserInviteModal(context, store);
                        EmailService.sendInviteEmail(
                            user.name, user.userType, email);
                        Navigator.pop(context);
                      },
                    )
                  else if (user.userType == UserType.child)
                    ListTile(
                      title: Text(loc.trans('invite_parent_menu'),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      onTap: () async {
                        var email = await showUserInviteModal(context, store);
                        EmailService.sendInviteEmail(
                            user.name, user.userType, email);
                        Navigator.pop(context);
                      },
                    ),
                  ListTile(
                    title: Text(loc.trans('privacy'),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    onTap: () async {
                      var url =
                          "https://piggybanx.com/wp-content/uploads/2019/11/Adatkezel%C3%A9si-t%C3%A1j%C3%A9koztat%C3%B3.pdf";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  ListTile(
                    title: Text('Profil',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                user: store.state.user,
                              )));
                    },
                  ),
                  // ListTile(
                  //   title: Text(loc.trans('terms_use'),
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.w600, fontSize: 15)),
                  //   onTap: () {},
                  // ),
                  ListTile(
                    title: Text(
                      loc.trans('logout'),
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    onTap: () {
                      logout(store);
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("Verzió: ${versionNumber ?? ""}"),
                      Text("Contact: support@piggybanx.com")
                    ],
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
