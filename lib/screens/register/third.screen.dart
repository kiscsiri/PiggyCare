import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piggybanx/Enums/period.dart';
import 'package:piggybanx/helpers/InputFormatters.dart';
import 'package:piggybanx/helpers/SavingScheduleGenerator.dart';
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

  scheduleChooser() {
    var schedules = ScheduleGenerator().generateSchedules(int.parse(
        textEditingController.text
            .substring(0, textEditingController.text.length - 2)));

    return showDialog(
        context: context,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(1.0),
              child: AlertDialog(
                title: Text(
                  "Let Piggy offer you some scheduling for getting the ${widget.store.state.registrationData.item}!",
                  style: Theme.of(context).textTheme.display3,
                  textAlign: TextAlign.center,
                ),
                content: Center(
                  child: ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      var schedule = schedules.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 5),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey,
                                  offset: new Offset(5.0, 2.0),
                                )
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.all(7),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  width: 30,
                                  child: FlareActor("assets/piggy_etetes.flr",
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                      animation: "sleep"),
                                ),
                                Flexible(
                                  child: ListTile(
                                    onTap: () {
                                      widget.store
                                          .dispatch(SetSchedule(schedule));
                                      Navigator.pushReplacement(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new RegisterPage(
                                                    store: widget.store,
                                                  )));
                                    },
                                    trailing: Text(
                                        "Get the ${widget.store.state.registrationData.item} in  ${schedule.daysUntilDone} days by feeding Piggy ${schedule.savingPerPeriod}\$ ${getStringValue(schedule.period)}"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ));
  }

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
          )),
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
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    EuroOnTheInputEndFormatter()
                  ],
                  textController: textEditingController,
                  keyboardType: TextInputType.number,
                  onValidate: (value) {
                    try {
                      if (value.length > 1 && value.startsWith("0"))
                        return "The price can't start with zero!";
                      int price = int.parse(
                          value.substring(0, value.length - 2),
                          radix: 10);
                      if (price.isNegative) {
                        return "The price must be positive!";
                      } else if (price == 0) {
                        return "The price can't be 0";
                      }
                    } catch (e) {
                      return "The price must be a number!";
                    }
                  },
                  onErrorMessage: null,
                ),
              ),
              PiggyButton(
                text: "Next step",
                disabled: false,
                onClick: () {
                  if (_priceFormKey.currentState.validate()) {
                    var action = SetPrice(int.parse(textEditingController.text
                        .substring(0, textEditingController.text.length - 2)));
                    widget.store.dispatch(action);
                    scheduleChooser();
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
