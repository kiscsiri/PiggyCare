import 'package:flutter/material.dart';

class PiggyModal extends StatefulWidget {
  const PiggyModal(
      {Key key,
      this.title,
      this.content,
      this.actions,
      this.vPadding,
      this.hPadding})
      : super(key: key);

  final Widget title;
  final double vPadding;
  final double hPadding;
  final Widget content;
  final List<Widget> actions;

  @override
  _PiggyModalState createState() => _PiggyModalState();
}

class _PiggyModalState extends State<PiggyModal>
    with SingleTickerProviderStateMixin {
  bool isShown = false;
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animation = Tween<double>(
      begin: -(MediaQuery.of(context).size.height * 0.143),
      end: 0,
    ).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical:
                  widget.vPadding ?? MediaQuery.of(context).size.height * 0.1,
              horizontal:
                  widget.hPadding ?? MediaQuery.of(context).size.width * 0),
          child: AlertDialog(
              title: widget.title,
              actions: [
                Padding(
                    padding: EdgeInsets.only(bottom: 30, right: 30, left: 30),
                    child: Column(children: widget.actions ?? [Container()]))
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(
                      color: Theme.of(context).primaryColor, width: 3.0)),
              content: widget.content),
        ),
      ),
      AnimatedPositioned(
          duration: Duration(seconds: 1),
          bottom: animation.value,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/modal_piggy.png',
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ],
            ),
          ))
    ]);
  }
}
