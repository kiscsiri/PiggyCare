import 'package:flutter/material.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/screens/register/third.screen.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';

class FirstRegisterPage extends StatefulWidget {
  FirstRegisterPage({Key key, this.store}) : super(key: key);
  final Store<AppState> store;

  @override
  _FirstRegisterPageState createState() => new _FirstRegisterPageState();
}

class _FirstRegisterPageState extends State<FirstRegisterPage> {
  TextEditingController textEditingController = new TextEditingController();

  final _itemFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.pink,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _itemFormKey,
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
                padding: const EdgeInsets.all(10.0),
                child: new Text(
                  "Register with 3 easy steps!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "First, tell Piggy what do you want to buy.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: PiggyInput(
                  hintText: "What do you wish for?",
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.8,
                  textController: textEditingController,
                  onErrorMessage: (error) {
                    setState(() {});
                  },
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return "This field is required!";
                    }
                  },
                ),
              ),
              PiggyButton(
                  text: "Next step",
                  onClick: () {
                    if (_itemFormKey.currentState.validate()) {
                      var action = SetItem(textEditingController.text);
                      widget.store.dispatch(action);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SecondRegisterPage(
                                    store: widget.store,
                                  )));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
