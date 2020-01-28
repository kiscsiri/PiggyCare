import 'package:flutter/material.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/widgets/chore.field.dart';

import 'package:redux/redux.dart';

const tasks = {1: "Autó lemosás", 2: "Házi feladat írás", 3: "Hólapátolás"};

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
    var selected =
        savingTypeList.singleWhere((t) => t.index == index, orElse: null);
    setState(() {
      selectedIndex = index;
    });

    var piggy = widget.store.state.user.piggies[index - 1];
  }

  Piggy getSelected() {
    // var selected = savingTypeList.singleWhere((t) => t.selected == true);

    // // var piggy = new Piggy(
    // //   currentFeedAmount: 1,
    // //   currentSaving: 0,
    // //   doubleUp: false,
    // //   isAproved: false,
    // //   isFeedAvailable: false,
    // //   item: selected.name,
    // //   money: 0,
    // //   targetPrice: selected.coinValue,
    // //   piggyLevel: PiggyLevel.Baby,
    // // );

    // return piggy;
  }

  @override
  Widget build(BuildContext context) {
    var dummyList = ["auto", "mosogatas", "szemetkivitel"];

    int i = 0;
    savingTypeList = dummyList.take(3).map((p) {
      i++;
      return ChoreInput(
        index: i,
        name: tasks[i],
        selectIndex: (i) => _selectItem(i),
      );
    }).toList();
    if (selectedIndex != null) {
      savingTypeList = savingTypeList.map((f) {
        if (f.index == selectedIndex) {
          return ChoreInput(
            index: f.index,
            selected: true,
            name: '${tasks[i]}',
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
