import 'package:flutter/material.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/widgets/chore.field.dart';

import 'piggy.saving.type.input.dart';
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
    var selected =
        savingTypeList.singleWhere((t) => t.index == index, orElse: null);

    // var action = CreateTempPiggy(
    //     piggy: Piggy(
    //   currentFeedAmount: 1,
    //   currentSaving: 0,
    //   doubleUp: false,
    //   isAproved: false,
    //   isFeedAvailable: true,
    //   item: selected.name,
    //   money: 0,
    //   targetPrice: selected.coinValue,
    //   piggyLevel: PiggyLevel.Baby,
    // ));

    // widget.store.dispatch(action);

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
    int i = 0;
    savingTypeList = widget.store.state.user.piggies.map((p) {
      i++;
      return ChoreInput(
        index: i,
        name: 'Task$i',
        selectIndex: (i) => _selectItem(i),
      );
    }).toList();
    if (selectedIndex != null) {
      savingTypeList = savingTypeList.map((f) {
        if (f.index == selectedIndex) {
          return ChoreInput(
            index: f.index,
            selected: true,
            name: 'Task${f.index}',
            selectIndex: (i) => _selectItem(i),
          );
        } else {
          return f;
        }
      }).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: savingTypeList,
    );
  }
}
