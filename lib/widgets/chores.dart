import 'package:flutter/material.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/widgets/chore.field.dart';

import 'package:redux/redux.dart';

class ChoresWidget extends StatefulWidget {
  final Store<AppState> store;

  const ChoresWidget({Key key, this.store}) : super(key: key);
  @override
  _ChoresWidgetState createState() => _ChoresWidgetState();
}

class _ChoresWidgetState extends State<ChoresWidget> {
  int selectedIndex;
  var savingTypeList = List<ChoreInput>();

  _selectItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.store.state.user;

    int i = 0;
    savingTypeList = user.chores.where((c) => !c.isValidated).take(3).map((p) {
      i++;
      return ChoreInput(
        index: i,
        store: widget.store,
        isDone: p.isDone,
        taskId: p.id,
        name: p.title,
        selectIndex: (i) => p.isDone ? null : _selectItem(i),
        parentId: widget.store.state.user.parentId,
        userId: widget.store.state.user.documentId,
      );
    }).toList();

    if (selectedIndex != null) {
      savingTypeList = savingTypeList.map((f) {
        if (f.index == selectedIndex) {
          return ChoreInput(
            taskId: f.taskId,
            index: f.index,
            isDone: f.isDone,
            store: widget.store,
            selected: true,
            name: '${f.name}',
            selectIndex: (i) => f.isDone ? null : _selectItem(i),
            parentId: widget.store.state.user.parentId,
            userId: widget.store.state.user.documentId,
          );
        } else {
          return f;
        }
      }).toList();
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.6,
      child: ListView(
        children: savingTypeList.length == 0
            ? [Center(child: Text("Nincs feladatod!"))]
            : savingTypeList,
      ),
    );
  }
}
