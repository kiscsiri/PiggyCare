import 'package:flutter/material.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/screens/child.chores.details.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:redux/redux.dart';

class CreateTaskWidget extends StatefulWidget {
  CreateTaskWidget(
      {Key key, this.store, this.navigateToTaskWidget, @required this.child})
      : super(key: key);

  final Function navigateToTaskWidget;
  final Store<AppState> store;
  final ChildDto child;
  @override
  _CreateTaskWidgetState createState() => new _CreateTaskWidgetState();
}

class _CreateTaskWidgetState extends State<CreateTaskWidget> {
  var item = "";
  double targetMoney = 1;
  double moneyPerFeed = 2;
  var controller = TextEditingController();
  Future _createTask() async {
    // var action = CreateTempTask(
    //     piggy: Task(
    //   currentFeedAmount: 1,
    //   currentSaving: 0,
    //   doubleUp: false,
    //   isAproved: false,
    //   isFeedAvailable: true,
    //   item: controller.text,
    //   money: 0,
    //   targetPrice: targetMoney.round(),
    //   piggyLevel: TaskLevel.Baby,
    // ));

    // widget.store.dispatch(action);

    // var add = AddTask(widget.store.state.tempTask);
    // widget.store.dispatch(add);

    // await TaskServices.createTaskForUser(
    //     action.piggy, widget.store.state.user.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(
              'Feladat létrehozás ${widget.child.name} számára',
              style: Theme.of(context).textTheme.display3,
              textAlign: TextAlign.center,
            ),
            PiggyInput(
              hintText: 'Mi a feladat?',
              textController: controller,
              width: MediaQuery.of(context).size.width,
              onValidate: (val) {
                setState(() {
                  item = val;
                });
              },
            ),
            PiggyButton(
              text: 'LÉTREHOZÁS',
              onClick: () async => await _createTask(),
            )
          ],
        ),
      ),
    );
  }
}
