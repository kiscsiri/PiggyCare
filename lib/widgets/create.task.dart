import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/chore/chore.export.dart';
import 'package:piggybanx/screens/child.chores.details.dart';
import 'package:piggybanx/services/notification.services.dart';
import 'package:piggybanx/services/services.export.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.input.dart';
import 'package:piggybanx/widgets/piggy.modal.widget.dart';
import 'package:redux/redux.dart';

class CreateTaskWidget extends StatefulWidget {
  CreateTaskWidget({Key key, this.navigateToTaskWidget, @required this.child})
      : super(key: key);

  final Function navigateToTaskWidget;
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

  Future _createTask(Store<AppState> store) async {
    try {
      var action = AddChore(Chore(
          childId: widget.child.id,
          choreType: ChoreType.haziMunka,
          details: "",
          isDone: false,
          isValidated: false,
          reward: "",
          title: item));

      action.chore.id = await ChoreFirebaseServices.createChoreForUser(
          context, action.chore, store);

      store.dispatch(action);
      NotificationServices.sendNotificationNewTask(widget.child.id,
          store.state.user.name, store.state.user.id, action.chore.id);
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var loc = PiggyLocalizations.of(context);
    return PiggyModal(
      hPadding: MediaQuery.of(context).size.width * 0.05,
      vPadding: MediaQuery.of(context).size.height * 0.2,
      actions: <Widget>[
        PiggyButton(
          text: loc.trans('create').toUpperCase(),
          onClick: () async {
            if (_formKey.currentState.validate()) {
              await _createTask(store);
            }
          },
        )
      ],
      title: Text(
        '${loc.trans('create_task')} ${widget.child.name} ${loc.trans('for')}',
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Form(
            key: _formKey,
            child: PiggyInput(
              hintText: loc.trans('task_ask'),
              textController: controller,
              width: MediaQuery.of(context).size.width,
              onValidate: (val) {
                if (val.isEmpty) {
                  return loc.trans('required_field');
                } else if (val.length >= 50) {
                  return loc.trans('maxumum_50_char');
                } else {
                  setState(() {
                    item = val;
                  });
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }
}
