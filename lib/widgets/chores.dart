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
    savingTypeList = user.chores.where((c) => !c.isDone).take(3).map((p) {
      i++;
      return ChoreInput(
        index: i,
        name: p.title,
        selectIndex: (i) => _selectItem(i),
      );
    }).toList();

    if (selectedIndex != null) {
      savingTypeList = savingTypeList.map((f) {
        if (f.index == selectedIndex) {
          return ChoreInput(
            index: f.index,
            selected: true,
            name: '${f.name}',
            selectIndex: (i) => _selectItem(i),
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
        children: savingTypeList,
      ),
    );
  }
}
