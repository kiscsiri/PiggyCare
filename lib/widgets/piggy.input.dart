import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef String OnValidate(String value);
typedef void OnErrorMessage(String value);

class PiggyInput extends StatefulWidget {
  PiggyInput(
      {Key key,
      @required this.hintText,
      this.textController,
      this.onValidate,
      this.width,
      this.height,
      this.onErrorMessage,
      this.keyboardType,
      this.inputFormatters,
      this.inputIcon,
      this.obscureText = false})
      : super(key: key);
  final String hintText;
  final TextEditingController textController;
  final OnValidate onValidate;
  final List<TextInputFormatter> inputFormatters;
  final OnErrorMessage onErrorMessage;
  final TextInputType keyboardType;
  final double width;
  final double height;
  final IconData inputIcon;
  final bool obscureText;

  @override
  _PiggyInputState createState() => new _PiggyInputState();
}

class _PiggyInputState extends State<PiggyInput> {
  final FocusNode _focusNode = FocusNode();

  bool isFocused = false;
  Color color = Color(0xffe25979);

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    color = isFocused ? Theme.of(context).primaryColor : Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
      child: Container(
        width: widget.width,
        padding: EdgeInsets.only(
            left: widget.inputIcon == null ? 7 : 3, top: 3, bottom: 2),
        decoration: new BoxDecoration(
          border: new Border.all(color: color),
          borderRadius: BorderRadius.circular(35),
        ),
        child: TextFormField(
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          controller: widget.textController,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          inputFormatters: widget.inputFormatters,
          validator: (value) {
            var result = widget.onValidate(value);
            if (result != null) {
              if (widget.onErrorMessage != null) widget.onErrorMessage(result);
              return result;
            }
            return null;
          },
          decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 14),
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: color),
              prefixIcon: widget.inputIcon != null
                  ? Icon(
                      widget.inputIcon,
                      color: color,
                    )
                  : null),
        ),
      ),
    );
  }
}
