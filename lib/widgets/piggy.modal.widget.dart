import 'package:flutter/material.dart';

class PiggyModal extends StatefulWidget {
  const PiggyModal({Key key, this.name, this.title, this.content, this.actions})
      : super(key: key);

  final String name;
  final Widget title;
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
      Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.1,
              horizontal: MediaQuery.of(context).size.width * 0),
          child: AlertDialog(
              title: widget.title,
              actions: [
                Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Column(children: widget.actions))
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: widget.content)),
      AnimatedPositioned(
          duration: Duration(seconds: 1),
          bottom: animation.value,
          right: MediaQuery.of(context).size.width * 0.315,
          child: Image.asset(
            'assets/images/modal_piggy.png',
            scale: 3,
          ))
    ]);
  }
}
