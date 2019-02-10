import 'package:flutter/material.dart';

class CounterWidget extends AnimatedWidget  {
  CounterWidget({Key key, this.animation, this.feedTime}) : super(key: key, listenable: animation);
  final Animation animation;

  Duration feedTime;
    
  @override
  Widget build(BuildContext context) {
    var minutes = feedTime.inMinutes % 60;
    var hours = feedTime.inHours.abs();
    return new Center(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // new Text("${widget.feedTime}"),
          // (widget.animation.value < 1)
          //     ? Text('00:')
          //     : Text('${widget.feedTime.toString()}:'),
          // (widget.animation.value < 1)
          //     ? Text('00:')
          //     : Text('${widget.animation.value}:'),
          // (widget.animation.value < 1)
          //     ? Text('00')
          //     : Text('${widget.animation.value}')
          new Text("$hours:"),
          new Text("$minutes:"),
          new Text("${animation.value}")
        ],
      ),
    );
 
  }
}