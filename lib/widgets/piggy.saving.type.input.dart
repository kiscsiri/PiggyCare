import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SavingTypeInput extends StatefulWidget {
  const SavingTypeInput(
      {Key key,
      @required this.index,
      @required this.name,
      @required this.coinValue,
      this.selected,
      this.selectIndex,
      this.id})
      : super(key: key);

  final int index;
  final String name;
  final int coinValue;
  final bool selected;
  final int id;
  final Function(int) selectIndex;

  @override
  _SavingTypeInputState createState() => _SavingTypeInputState();
}

class _SavingTypeInputState extends State<SavingTypeInput> {
  bool selected = false;
  _selectType() {
    widget.selectIndex(widget.id);
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
        TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 17);
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.index.toString()}.",
                        style: textStyle,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.46,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(widget.name,
                            style: textStyle, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                          widget.coinValue != 0
                              ? widget.coinValue.toString()
                              : "∞",
                          style: textStyle),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.height * 0.12,
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
