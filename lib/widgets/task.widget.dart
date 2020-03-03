import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskInputWidget extends StatefulWidget {
  const TaskInputWidget(
      {Key key,
      @required this.index,
      @required this.name,
      this.selected,
      this.selectIndex})
      : super(key: key);

  final int index;
  final String name;
  final bool selected;
  final Function(int) selectIndex;

  @override
  _SavingTypeInputState createState() => _SavingTypeInputState();
}

class _SavingTypeInputState extends State<TaskInputWidget> {
  bool selected = false;
  _selectType() {
    widget.selectIndex(widget.index);
  }

  @override
  void initState() {
    selected = widget.selected ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selected = widget.selected ?? false;
    Color color = selected ? Theme.of(context).primaryColor : Colors.white;
    Color textColor = selected ? Theme.of(context).primaryColor : Colors.grey;

    TextStyle textStyle =
        TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13);
    return GestureDetector(
      onTap: () => _selectType(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: new BoxDecoration(
                border: new Border.all(color: color),
                color: Colors.white,
                borderRadius: BorderRadius.circular(70.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.index.toString()}.",
                        style: textStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(widget.name, style: textStyle),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.10,
                        height: MediaQuery.of(context).size.height * 0.10,
                        child: Image.asset("assets/coin.png"),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
