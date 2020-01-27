import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piggybanx/enums/period.dart';
import 'package:piggybanx/helpers/InputFormatters.dart';
import 'package:piggybanx/helpers/SavingScheduleGenerator.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/models/registration/registration.actions.dart';
import 'package:piggybanx/screens/main.screen.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';

import 'register.screen.dart';

class ThirdRegisterPage extends StatefulWidget {
  ThirdRegisterPage({Key key, this.store}) : super(key: key);
  final Store<AppState> store;

  @override
  _ThirdRegisterPageState createState() => new _ThirdRegisterPageState();
}

class _ThirdRegisterPageState extends State<ThirdRegisterPage> {
  TextEditingController textEditingController = new TextEditingController();
  final _priceFormKey = GlobalKey<FormState>();

  scheduleChooser() {
    var schedules = ScheduleGenerator().generateSchedules(int.parse(
        textEditingController.text
            .substring(0, textEditingController.text.length - 2)));

    return showDialog(
        context: context,
        builder: (context) {
          var loc = PiggyLocalizations.of(context);
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(1.0),
            child: AlertDialog(
              title: Text(
                "${loc.trans("piggy_offer_some_plans")} ${widget.store.state.registrationData.item}" +
                    ((loc.locale.languageCode == "hu") ? "-t!" : "!"),
                style: Theme.of(context).textTheme.display3,
                textAlign: TextAlign.center,
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                  child: ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      var schedule = schedules.elementAt(index);
                      return Container(
                        child: Padding(
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
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(7),
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 30,
                                      width: 30,
                                    ),
                                    Flexible(
                                      child: ListTile(
                                        onTap: () {
                                          widget.store
                                              .dispatch(SetSchedule(schedule));
                                          if (!["", null].contains(
                                              widget.store.state.user.id)) {
                                            var item = Piggy(
                                                currentSaving: 0,
                                                item: widget.store.state
                                                    .registrationData.item,
                                                targetPrice: widget
                                                    .store
                                                    .state
                                                    .registrationData
                                                    .targetPrice);

                                            widget.store
                                                .dispatch(AddPiggy(item));
                                            Navigator.pushReplacement(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new MainPage(
                                                          store: widget.store,
                                                        )));
                                          } else {
                                            Navigator.pushReplacement(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new LastPage(
                                                          store: widget.store,
                                                        )));
                                          }
                                        },
                                        trailing: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.38,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.38,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.38,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.38,
                                            child: Center(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "${loc.trans("time")}${schedule.daysUntilDone} ${loc.trans("days")}.",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.0),
                                                    ),
                                                    Text(
                                                      "\n${getStringValueRegister(schedule.period, context)} ${loc.trans("saving")}: ${schedule.savingPerPeriod}\$",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var isAlreadyRegistered = widget.store.state.user.id != null;

    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.white,
          title: Text(
            loc.trans('registration'),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.pink,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Form(
        key: _priceFormKey,
        child: Container(
          decoration: piggyBackgroundDecoration(
              context, widget.store.state.registrationData.userType),
          child: new Center(
            child: new ListView(
              children: <Widget>[
                !isAlreadyRegistered
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: new Text(
                          loc.trans("welcome"),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.title,
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    loc.trans("how_much_it_cost"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: PiggyInput(
                    hintText: loc.trans("how_much_it_cost_hint"),
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
                          return loc.trans("price_start_zero_validation");
                        int price = int.parse(
                            value.substring(0, value.length - 2),
                            radix: 10);
                        if (price.isNegative) {
                          return loc.trans("price_positive_validation");
                        } else if (price == 0) {
                          return loc.trans("price_non_zero_validation");
                        }
                      } catch (e) {
                        return loc.trans("price_must_be_number_validation");
                      }
                    },
                    onErrorMessage: null,
                  ),
                ),
                PiggyButton(
                  text: loc.trans("next_step"),
                  disabled: false,
                  onClick: () {
                    if (_priceFormKey.currentState.validate()) {
                      var action = SetPrice(int.parse(textEditingController.text
                          .substring(
                              0, textEditingController.text.length - 2)));
                      widget.store.dispatch(action);
                      scheduleChooser();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
