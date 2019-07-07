import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piggybanx/models/navigation.redux.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/screens/frames/piggy.screen.dart';
import 'package:piggybanx/screens/frames/savings.screen.dart';
import 'package:piggybanx/screens/frames/settings.screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("PiggyBanx"),
          ),
          body: new PageView(
            children: <Widget>[
              new PiggyPage(store: widget.store),
              new SavingsPage(
                  store: widget.store, pageController: widget._pageController),
              new SettingsPage(store: widget.store)
            ],
            onPageChanged: (int index) {
              setState(() {
                widget.navigationStore
                    .dispatch(SetNavigationIndex(index: index));
              });
            },
            controller: widget._pageController,
          ),
          bottomNavigationBar: PiggyNavigationBar(
            onNavigateTap: (index) {
              _navigate(index);
            },
            store: widget.navigationStore,
          )),
    );
  }
}
