import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';
import 'package:piggybanx/screens/search.user.dart';
import 'piggy.modal.widget.dart';
import 'piggy.slider.dart';

class AddChildWidget extends StatefulWidget {
  AddChildWidget({Key key, this.navigateToPiggyWidget}) : super(key: key);

  final Function navigateToPiggyWidget;

  @override
  _AddChildWidgetState createState() => new _AddChildWidgetState();
}

class _AddChildWidgetState extends State<AddChildWidget> {
  var name = "";
  double feedPerDay = 1;

  var controller = TextEditingController();
  Future _createPiggy(Store<AppState> store) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserSearchScreen(
                  currentUserId: store.state.user.id,
                  userType: store.state.user.userType,
                  searchString: controller.text,
                )));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    return PiggyModal(
        vPadding: MediaQuery.of(context).size.height * 0,
        title: Text(
          '+ Vedd fel a gyereked',
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
        content: Column(children: <Widget>[
          PiggyInput(
            hintText: "E-mail/Név",
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
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
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
        ]),
        actions: [
          PiggyButton(
            text: "GYEREK HOZZÁADÁSA",
            onClick: () async => await _createPiggy(store),
          ),
        ]);
  }
}
