import 'package:flutter/material.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';
import 'package:piggybanx/screens/search.user.dart';
import 'piggy.slider.dart';

class AddChildWidget extends StatefulWidget {
  AddChildWidget({Key key, this.store, this.navigateToPiggyWidget})
      : super(key: key);

  final Function navigateToPiggyWidget;
  final Store<AppState> store;

  @override
  _AddChildWidgetState createState() => new _AddChildWidgetState();
}

class _AddChildWidgetState extends State<AddChildWidget> {
  var name = "";
  double feedPerDay = 1;

  var controller = TextEditingController();
  Future _createPiggy() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserSearchScreen(
                  currentUserId: widget.store.state.user.id,
                  userType: widget.store.state.user.userType,
                  searchString: controller.text,
                )));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(
              '+ Vedd fel a gyereked',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            PiggyInput(
              hintText: "Gyerek neve",
              textController: controller,
              width: MediaQuery.of(context).size.width,
              onValidate: (val) {
                setState(() {
                  name = val;
                });
                return null;
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Opacity(
                  opacity: 0.9,
                  child: Container(
                      color: Colors.grey[300],
                      width: MediaQuery.of(context).size.width * 0.67,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${feedPerDay.toInt()} € = 1 ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Image.asset('assets/images/coin.png')
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                      'Add meg, hogy mennyi legyen az értéke egy PiggyCoin-nak'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PiggySlider(
                    maxMinTextTrailing: Text(
                      '€',
                    ),
                    maxVal: 10,
                    onChange: (val) {
                      setState(() {
                        feedPerDay = val;
                      });
                    },
                    value: feedPerDay.toDouble(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: PiggyButton(
                text: "GYEREK HOZZÁADÁSA",
                onClick: () async => await _createPiggy(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
