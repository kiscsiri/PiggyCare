import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef String OnValidate(String value);
typedef void OnErrorMessage(String value);

class PiggyInput extends StatelessWidget {
  PiggyInput(
      {Key key,
      @required this.hintText,
      this.textController,
      this.onValidate,
      this.width,
      this.height,
      this.onErrorMessage,
      this.keyboardType,
      this.inputFormatters})
      : super(key: key);
  final String hintText;
  final TextEditingController textController;
  final OnValidate onValidate;
  final List<TextInputFormatter> inputFormatters;
  final OnErrorMessage onErrorMessage;
  final TextInputType keyboardType;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        width: this.width,
        padding: EdgeInsets.only(left: 5),
        decoration: new BoxDecoration(
          border: new Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: textController,
          keyboardType: keyboardType ?? TextInputType.text,
          inputFormatters: inputFormatters,
          validator: (value) {
            var result = onValidate(value);
            if (result != null) {
              if (onErrorMessage != null) onErrorMessage(result);
              return result;
            }
          },
          decoration:
              InputDecoration(border: InputBorder.none, hintText: hintText),
        ),
      ),
    );
  }
}
