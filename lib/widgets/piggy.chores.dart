import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:piggycare/localization/Localizations.dart';
import 'package:piggycare/models/appState.dart';
import 'package:piggycare/widgets/chore.field.dart';

class ChoresWidget extends StatefulWidget {
  const ChoresWidget({Key key}) : super(key: key);
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
    var store = StoreProvider.of<AppState>(context);
    var user = store.state.user;
    var loc = PiggyLocalizations.of(context);

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, vm) {
          int i = 0;
          // savingTypeList =
          //     user.chores.where((c) => !c.isValidated).take(3).map((p) {
          //   i++;
          //   return ChoreInput(
          //     index: i,
          //     isDone: p.isDone,
          //     taskId: p.id,
          //     name: p.title,
          //     selectIndex: (i) => p.isDone ? null : _selectItem(i),
          //     parentId: store.state.user.parentId,
          //     userId: store.state.user.documentId,
          //   );
          // }).toList();

          // if (selectedIndex != null) {
          //   savingTypeList = savingTypeList.map((f) {
          //     if (f.index == selectedIndex) {
          //       return ChoreInput(
          //         taskId: f.taskId,
          //         index: f.index,
          //         isDone: f.isDone,
          //         selected: true,
          //         name: '${f.name}',
          //         selectIndex: (i) => f.isDone ? null : _selectItem(i),
          //         parentId: store.state.user.parentId,
          //         userId: store.state.user.documentId,
          //       );
          //     } else {
          //       return f;
          //     }
          //   }).toList();
          // }

          return Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.6,
            child: ListView(
              children: savingTypeList.length == 0
                  ? [Center(child: Text(loc.trans('no_task')))]
                  : savingTypeList,
            ),
          );
        });
  }
}
