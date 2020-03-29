import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/chore/chore.action.dart';
import 'package:piggybanx/services/chore.firebase.dart';
import 'package:piggybanx/services/notification.modals.dart';
import 'package:piggybanx/services/notification.services.dart';

class ParentChoreInput extends StatefulWidget {
  const ParentChoreInput(
      {Key key,
      @required this.index,
      @required this.name,
      this.selected,
      this.selectIndex,
      this.userId,
      this.parentId,
      @required this.taskId,
      this.isDone})
      : super(key: key);

  final int index;
  final int taskId;
  final String name;
  final String userId;
  final String parentId;
  final bool selected;
  final bool isDone;
  final Function(int) selectIndex;

  @override
  _ChoreInputState createState() => _ChoreInputState();
}

class _ChoreInputState extends State<ParentChoreInput> {
  bool selected = false;

  Future<void> _finishChore(BuildContext context) async {
    bool ack = await showCompletedTask(context, "");
    if (ack ?? false) {
      StoreProvider.of<AppState>(context)
          .dispatch(ValidateChoreParent(widget.userId, widget.taskId, true));
      await ChoreFirebaseServices.validateChildChore(
          widget.userId, widget.taskId);
      await NotificationServices.sendNotificationValidatedTask(
          widget.userId, widget.taskId);
    } else {
      StoreProvider.of<AppState>(context)
          .dispatch(ValidateChoreParent(widget.userId, widget.taskId, false));
      await NotificationServices.sendNotificationRefusedTask(
          widget.userId, widget.taskId);
      await ChoreFirebaseServices.refuseChildChore(
          widget.userId, widget.taskId);
    }
    setState(() {});
  }

  @override
  void initState() {
    selected = widget.selected ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selected = widget.selected ?? false;
    var width = MediaQuery.of(context).size.width;

    final Color background = Colors.white;
    final Color fill = Theme.of(context).primaryColor;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    final double fillPercent = width * 0.05;
    final double fillStop = (100 - (selected ? fillPercent : 0)) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    Color color;
    Color textColor;

    color = selected ? Theme.of(context).primaryColor : Colors.white;
    textColor = selected ? Theme.of(context).primaryColor : Colors.grey;

    TextStyle textStyle =
        TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 17);
    return GestureDetector(
      onTap: () async => selected ? _finishChore(context) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
            width: width * 0.8,
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: new BoxDecoration(
                border: new Border.all(color: color),
                color: Colors.white,
                gradient: LinearGradient(colors: gradient, stops: stops),
                borderRadius: BorderRadius.circular(70.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.index.toString()}.",
                        style: textStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(widget.name, style: textStyle),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: width * 0.12,
                            height: MediaQuery.of(context).size.height * 0.12,
                            child: Image.asset("assets/coin.png"),
                          )
                        ],
                      ),
                    ),
                    selected
                        ? Container(
                            width: width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.12,
                            child: Center(
                                child: Icon(FontAwesomeIcons.checkDouble,
                                    color: Colors.white)),
                          )
                        : Container()
                  ],
                )
              ],
            )),
      ),
    );
  }
}
