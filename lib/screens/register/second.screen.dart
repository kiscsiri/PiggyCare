import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/models/store.dart';
import 'package:piggybanx/screens/register/third.screen.dart';
import 'package:piggybanx/widgets/PiggyScaffold.dart';
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
    var loc = PiggyLocalizations.of(context);
    var isAlreadyRegistered = widget.store.state.user.id.isNotEmpty;

    return PiggyScaffold(
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
              !isAlreadyRegistered ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: new Text(
                  loc.trans("welcome"),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title,
                ),
              ) : Container(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              !isAlreadyRegistered ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Text(
                  loc.trans("3_easy_steps"),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display3,
                ),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  loc.trans("register_saving_for"),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: PiggyInput(
                  hintText: loc.trans("your_wish_hint"),
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.8,
                  textController: textEditingController,
                  onErrorMessage: (error) {
                    setState(() {});
                  },
                  onValidate: (value) {
                    if (value.isEmpty) {
                      return loc.trans("required_field");
                    }
                  },
                ),
              ),
              PiggyButton(
                  text: loc.trans("next_step"),
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
