import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/piggy/piggy.export.dart';
import 'package:piggybanx/screens/saving.details.dart';
import 'package:redux/redux.dart';

import 'piggy.saving.type.input.dart';

class SavingForWidget extends StatefulWidget {
  const SavingForWidget({Key key, this.store}) : super(key: key);

  final Store<AppState> store;
  @override
  _SavingForWidgetState createState() => _SavingForWidgetState();
}

class _SavingForWidgetState extends State<SavingForWidget> {
  int selectedIndex;
  var savingTypeList = List<SavingTypeInput>();

  _selectItem(int index) {
    var piggy = widget.store.state.user.piggies[index - 1];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SavingDetails(
                  piggy: piggy,
                )));
  }

  Piggy getSelected() {
    var selected = savingTypeList.singleWhere((t) => t.selected == true);

    var piggy = new Piggy(
      currentFeedAmount: 1,
      currentSaving: 0,
      doubleUp: false,
      isAproved: false,
      isFeedAvailable: false,
      item: selected.name,
      money: 0,
      targetPrice: selected.coinValue,
      piggyLevel: PiggyLevel.Baby,
    );

    return piggy;
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    savingTypeList = widget.store.state.user.piggies.map((p) {
      i++;
      return SavingTypeInput(
        index: i,
        name: p.item,
        coinValue: p.targetPrice,
        selectIndex: (i) => _selectItem(i),
      );
    }).toList();
    if (selectedIndex != null) {
      savingTypeList = savingTypeList.map((f) {
        if (f.index == selectedIndex) {
          return SavingTypeInput(
            coinValue: f.coinValue,
            index: f.index,
            selected: true,
            name: f.name,
            selectIndex: (i) => _selectItem(i),
          );
        } else {
          return f;
        }
      }).toList();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        children: savingTypeList,
      ),
    );
  }
}
