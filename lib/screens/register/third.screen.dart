import 'package:flutter/material.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/screens/register/register.screen.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';

class SecondRegisterPage extends StatefulWidget {
  SecondRegisterPage({Key key, this.store}) : super(key: key);
  final Store<AppState> store;

  @override
  _SecondRegisterPageState createState() => new _SecondRegisterPageState();
}

class _SecondRegisterPageState extends State<SecondRegisterPage> {
  TextEditingController textEditingController = new TextEditingController();
  final _priceFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: Form(
        key: _priceFormKey,
        child: new Center(
          child: new ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: new Text(
                  "Welcome to PiggyBanx!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "Second, tell Piggy, how much does it cost!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: PiggyInput(
                  hintText: "How much does it cost?",
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.8,
                  textController: textEditingController,
                  keyboardType: TextInputType.number,
                  onValidate: (value) {
                    if (value.contains(r'[A-Z]')) {
                      return "This field is must be a number";
                    } else if (value.startsWith('0')) {
                      return "This field is must be a number";
                    }
                  },
                ),
              ),
              PiggyButton(
                text: "Next step",
                disabled: false,
                onClick: () {
                  var action = SetPrice(int.parse(textEditingController.text));
                  widget.store.dispatch(action);
                  if (_priceFormKey.currentState.validate()) {
                    var action = SetItem(textEditingController.text);
                    widget.store.dispatch(action);
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new RegisterPage(
                                  store: widget.store,
                                )));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
