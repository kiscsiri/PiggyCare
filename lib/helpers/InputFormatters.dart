import 'package:flutter/services.dart';

class EuroOnTheInputEndFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue
  ) {
    final StringBuffer newText = StringBuffer();
    int selectionIndex = newValue.text.length;

    if(!oldValue.text.endsWith("\$"))
    {
      newText.write(oldValue.text + newValue.text + " \$");
    } else {
      newText.write(newValue.text + " \$");
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex)
    );
  }
}