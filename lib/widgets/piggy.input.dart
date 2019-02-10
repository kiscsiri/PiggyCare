import 'package:flutter/material.dart';

typedef String OnValidate(String value);

class PiggyInput extends StatelessWidget {
  PiggyInput(
      {Key key, @required this.hintText, this.textController, this.onValidate})
      : super(key: key);
  final String hintText;
  final TextEditingController textController;
  final OnValidate onValidate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.only(left: 5),
        decoration: new BoxDecoration(
          border: new Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: textController,
          validator: (value) {
            onValidate(value);
          },
          decoration:
              InputDecoration(border: InputBorder.none, hintText: hintText),
        ),
      ),
    );
  }
}
