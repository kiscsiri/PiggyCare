import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/services/notification.services.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/services/user.services.dart';
import 'package:piggybanx/widgets/childsaving.input.dart';
import 'package:piggybanx/widgets/parent.chore.input.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.slider.dart';
import 'package:piggybanx/widgets/task.widget.dart';
import 'package:redux/redux.dart';

class ChildDetailsWidget extends StatefulWidget {
  const ChildDetailsWidget(
      {Key key, this.documentId, @required this.initChildren})
      : super(key: key);

  final String documentId;
  final List<UserData> initChildren;

  @override
  _ChildDetailsWidgetState createState() => _ChildDetailsWidgetState();
}

class _ChildDetailsWidgetState extends State<ChildDetailsWidget> {
  var children = List<UserData>();

  ChildDto child;
  var selectedTaskIndex = 0;
  var selectedSavingIndex = 0;

  @override
  void initState() {
    var children = mapChildrenToChilDto(widget.initChildren).toList();

    child = children.firstWhere((t) => t.documentId == widget.documentId,
        orElse: null);

    super.initState();
  }

  List<ChildDto> mapChildrenToChilDto(List<UserData> children) {
    int i = 0;
    return children
        .map((e) => ChildDto(
            feedPerCoin: e.feedPerPeriod,
            id: e.id,
            documentId: e.documentId,
            name: e.name ?? e.email,
            savings: e.piggies
                .map((p) => SavingDto(
                    index: i++,
                    name: p.item,
                    price: p.targetPrice,
                    saving: p.currentSaving))
                .toList(),
            tasks: e.chores
                .where((e) => !e.isValidated)
                .map((c) => TaskDto(
                    index: i++,
                    name: c.title,
                    isFinished: c.isValidated,
                    isDone: c.isDone,
                    id: c.id))
                .toList()))
        .toList();
  }

  Future<void> _showCreateModal() async {
    var store = StoreProvider.of<AppState>(context);

    await showCreatePiggyModal(context, store, child.id);

    setState(() {
      var children = mapChildrenToChilDto(store.state.user.children).toList();

      child = children.singleWhere((t) => t.documentId == widget.documentId,
          orElse: null);
    });
  }

  Future<void> _showAddTaskModal() async {
    var store = StoreProvider.of<AppState>(context);

    await showCreateTask(context, store, child);
    setState(() {
      var children = mapChildrenToChilDto(store.state.user.children).toList();

      child = children.singleWhere((t) => t.documentId == widget.documentId,
          orElse: null);
    });
  }

  Future<void> _changeChildSavingPerFeed(int val) async {
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(SetChildSavingPerFeed(widget.documentId, val));
    await NotificationServices.sendEmptyNotificationSetFeedPerCoin(
        child.id, val);
    await UserServices.setChildSavingPerDay(widget.documentId, val);
  }

  int _compareFinishedTasks(TaskDto a, TaskDto b) {
    if ((a.isFinished ?? false) && (b.isFinished ?? false))
      return 0;
    else if ((a.isFinished ?? false) && (!b.isFinished ?? false))
      return 1;
    else
      return -1;
  }

  _selectTaskItem(int i) {
    setState(() {
      selectedTaskIndex = i;
    });
  }

  _selectSavingItem(int i) {
    setState(() {
      selectedSavingIndex = i;
    });
  }

  _getTasks(context) {
    int i = 0;
    var tasks = List<ParentChoreInput>();
    var store = StoreProvider.of<AppState>(context);

    var children = mapChildrenToChilDto(store.state.user.children).toList();

    child = children.singleWhere((t) => t.documentId == widget.documentId,
        orElse: null);

    child.tasks.sort(_compareFinishedTasks);

    tasks = child.tasks.take(3).map((p) {
      i++;
      return ParentChoreInput(
        taskId: p.id,
        isDone: p.isDone,
        parentId: store.state.user.id,
        userId: widget.initChildren.first.id,
        index: i,
        name: p.name,
        selected: p.isDone,
        selectIndex: (i) => _selectTaskItem(i),
      );
    }).toList();

    if (selectedTaskIndex != null) {
      tasks = tasks.map((f) {
        if (f.index == selectedTaskIndex) {
          return ParentChoreInput(
            taskId: f.taskId,
            isDone: f.isDone,
            parentId: store.state.user.id,
            userId: widget.initChildren.first.id,
            index: f.index,
            selected: true,
            name: f.name,
            selectIndex: (i) => _selectTaskItem(i),
          );
        } else {
          return f;
        }
      }).toList();
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var savings = List<ChildSavingInputWidget>();

    int j = 0;
    savings = child.savings.take(3).map((p) {
      j++;
      return ChildSavingInputWidget(
        index: j,
        name: p.name,
        price: (child.feedPerCoin == 0
                ? "∞"
                : (p.price - p.saving) ~/ child.feedPerCoin)
            .toString(),
        saving: p.saving,
        selected: false,
        selectIndex: (j) => _selectSavingItem(j),
      );
    }).toList();

    if (selectedSavingIndex != null) {
      savings = savings.map((f) {
        if (f.index == selectedSavingIndex) {
          return ChildSavingInputWidget(
            index: f.index,
            selected: true,
            name: f.name,
            saving: f.saving,
            price: f.price,
            selectIndex: (j) => _selectSavingItem(j),
          );
        } else {
          return f;
        }
      }).toList();
    }

    return Container(
        child: ListView(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            decoration: coinBackground(context, UserType.adult),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    child.name + " ${loc.trans('his_savings')}",
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      children: savings,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.15,
                        right: MediaQuery.of(context).size.width * 0.15,
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: Opacity(
                      opacity: 0.9,
                      child: Container(
                          color: Colors.grey[300],
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('${child.feedPerCoin} € = 1 '),
                              Image.asset('assets/images/coin.png')
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.15),
                    child: PiggySlider(
                      value: child.feedPerCoin.toDouble(),
                      maxMinTextTrailing: Text('€'),
                      onChangeEnding: (val) async =>
                          await _changeChildSavingPerFeed(val.toInt()),
                      maxVal: 10,
                      onChange: (val) {
                        setState(() {
                          child.feedPerCoin = val.toInt();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: PiggyButton(
                      text: loc.trans('create_money_box_button'),
                      onClick: () async => await _showCreateModal(),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: coinBackground(context, UserType.adult),
            child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, store) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      child.name + " ${loc.trans('his_tasks')}",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    Text(loc.trans('choose_task'),
                        style: Theme.of(context).textTheme.subtitle2),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        children: _getTasks(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: PiggyButton(
                        text: loc.trans('+_add_task'),
                        onClick: () async => await _showAddTaskModal(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ]));
  }
}

class ChildDto {
  List<TaskDto> tasks;
  List<SavingDto> savings;

  String name;
  int feedPerCoin;

  String id;
  String documentId;

  ChildDto(
      {this.tasks,
      this.id,
      this.documentId,
      this.savings,
      this.name,
      this.feedPerCoin});
}

class TaskDto {
  int id;

  String name;
  int index;
  bool isDone;
  bool isFinished;
  TaskDto({this.name, this.id, this.index, this.isFinished, this.isDone});
}

class SavingDto {
  String name;
  int index;
  int price;
  int saving;

  SavingDto({this.name, this.index, this.price, this.saving});
}
