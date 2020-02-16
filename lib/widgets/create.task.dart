import 'package:flutter/material.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/chore/chore.export.dart';
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
  final _formKey = GlobalKey<FormState>();
  var item = "";
  double targetMoney = 1;
  double moneyPerFeed = 2;
  var controller = TextEditingController();

  Future _createTask() async {
    widget.store.dispatch(AddChore(Chore(
        childId: widget.child.documentId,
        choreType: ChoreType.haziMunka,
        details: "",
        isDone: false,
        isValidated: false,
        reward: "",
        title: item)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(
              'Feladat létrehozás ${widget.child.name} számára',
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
            Form(
              key: _formKey,
              child: PiggyInput(
                hintText: 'Mi a feladat?',
                textController: controller,
                width: MediaQuery.of(context).size.width,
                onValidate: (val) {
                  if (val.isEmpty) {
                    return "Kötelező mező";
                  } else {
                    setState(() {
                      item = val;
                    });
                  }

                  return null;
                },
              ),
            ),
            PiggyButton(
              text: 'LÉTREHOZÁS',
              onClick: () async {
                if (_formKey.currentState.validate()) {
                  await _createTask();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
