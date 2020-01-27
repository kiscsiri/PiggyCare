import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';
import 'package:piggybanx/widgets/childsaving.input.dart';
import 'package:piggybanx/widgets/piggy.bacground.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.saving.type.input.dart';
import 'package:piggybanx/widgets/piggy.saving.types.dart';
import 'package:piggybanx/widgets/piggy.slider.dart';
import 'package:piggybanx/widgets/task.widget.dart';

var children = [
  ChildDto(feedPerCoin: 3, name: "Petike", id: "0", savings: [
    SavingDto(name: "Play station", price: 600),
    SavingDto(name: "Focilabda", price: 5),
    SavingDto(name: "Bulizás", price: 10)
  ], taks: [
    TaskDto(name: "Takarítsd ki a szobád!"),
    TaskDto(name: "Vidd ki a szemetet!"),
    TaskDto(name: "Csináld meg a házifeladatot!"),
  ]),
  ChildDto(feedPerCoin: 7, id: "1", name: "Kitti", savings: [
    SavingDto(name: "Görkorcsolya", price: 10),
    SavingDto(name: "Telefon", price: 150),
    SavingDto(name: "Ruha", price: 20)
  ], taks: [
    TaskDto(name: "Segíts az ebédet elkészíteni!"),
    TaskDto(name: "Csináld meg a házifeladatot!"),
    TaskDto(name: "Szerezz egy 5-öst a suliban!"),
  ])
];

class ChildDetailsWidget extends StatefulWidget {
  const ChildDetailsWidget({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _ChildDetailsWidgetState createState() => _ChildDetailsWidgetState();
}

class _ChildDetailsWidgetState extends State<ChildDetailsWidget> {
  ChildDto child;
  var selectedTaskIndex = 0;
  var selectedSavingIndex = 0;

  @override
  void initState() {
    child = children.singleWhere((t) => t.id == widget.id, orElse: null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    style: Theme.of(context).textTheme.display3,
                  ),
                  Text("Válassz malacperselyt",
                      style: Theme.of(context).textTheme.subtitle),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      children: tasks,
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
                              Text('${child.feedPerCoin} \$ = 1 '),
                              Image.asset('assets/images/coin.png')
                            ],
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15),
                    child: PiggySlider(
                      value: child.feedPerCoin.toDouble(),
                      maxMinTextTrailing: Text('\$'),
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
                      text: "CREATE NEW MONEY BOX",
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
                    style: Theme.of(context).textTheme.display3,
                  ),
                  Text("Válassz malacperselyt",
                      style: Theme.of(context).textTheme.subtitle),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      children: savings,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: PiggyButton(
                      text: "+ FELADAT HOZZÁADÁS",
                    ),
                  )
                ],
              ),
            ),
          )
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

  ChildDto({this.taks, this.id, this.savings, this.name, this.feedPerCoin});
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
