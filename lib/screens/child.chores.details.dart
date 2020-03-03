import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/user/user.export.dart';
import 'package:piggybanx/services/piggy.page.services.dart';
import 'package:piggybanx/widgets/childsaving.input.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.slider.dart';
import 'package:piggybanx/widgets/task.widget.dart';
import 'package:redux/redux.dart';

class ChildDetailsWidget extends StatefulWidget {
  const ChildDetailsWidget({Key key, this.documentId, this.store})
      : super(key: key);

  final String documentId;
  final Store<AppState> store;
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
    var children =
        mapChildrenToChilDto(widget.store.state.user.children).toList();

    child = children.singleWhere((t) => t.documentId == widget.documentId,
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
                .map((p) =>
                    SavingDto(index: i++, name: p.item, price: p.targetPrice))
                .toList(),
            taks: e.chores
                .map((c) => TaskDto(index: i++, name: c.title))
                .toList()))
        .toList();
  }

  Future<void> _showCreateModal() async {
    await showCreatePiggyModal(context, widget.store, child.id);

    setState(() {
      var children =
          mapChildrenToChilDto(widget.store.state.user.children).toList();

      child = children.singleWhere((t) => t.documentId == widget.documentId,
          orElse: null);
    });
  }

  Future<void> _showAddTaskModal() async {
    await showCreateTask(context, widget.store, child);
    setState(() {
      var children =
          mapChildrenToChilDto(widget.store.state.user.children).toList();

      child = children.singleWhere((t) => t.documentId == widget.documentId,
          orElse: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    var loc = PiggyLocalizations.of(context);
    var tasks = List<TaskInputWidget>();
    var savings = List<ChildSavingInputWidget>();

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

    int i = 0;
    tasks = child.taks.map((p) {
      i++;
      return TaskInputWidget(
        index: i,
        name: p.name,
        selected: false,
        selectIndex: (i) => _selectTaskItem(i),
      );
    }).toList();

    if (selectedTaskIndex != null) {
      tasks = tasks.map((f) {
        if (f.index == selectedTaskIndex) {
          return TaskInputWidget(
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

    int j = 0;
    savings = child.savings.map((p) {
      j++;
      return ChildSavingInputWidget(
        index: j,
        name: p.name,
        price: p.price,
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
                    child.name + " megtakarításai",
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    child.name + " feladatai",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text("Válassz malacperselyt",
                      style: Theme.of(context).textTheme.subtitle2),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      children: tasks,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: PiggyButton(
                      text: "+ FELADAT HOZZÁADÁS",
                      onClick: () async => await _showAddTaskModal(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ]));
  }
}

class ChildDto {
  List<TaskDto> taks;
  List<SavingDto> savings;

  String name;
  int feedPerCoin;

  String id;
  String documentId;

  ChildDto(
      {this.taks,
      this.id,
      this.documentId,
      this.savings,
      this.name,
      this.feedPerCoin});
}

class TaskDto {
  String name;
  int index;
  TaskDto({this.name, this.index});
}

class SavingDto {
  String name;
  int index;
  int price;

  SavingDto({this.name, this.index, this.price});
}
