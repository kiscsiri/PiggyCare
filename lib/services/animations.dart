import 'dart:async';

import 'package:flutter/material.dart';

Future<void> _loadAnimation(BuildContext context, TickerProvider provider,
    bool isAnimationPlaying) async {
  AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 5), vsync: provider)
        ..forward();

  var animation = new Tween<double>(begin: 0, end: 300).animate(_controller)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.dispose();
        isAnimationPlaying = false;
      }
    });
}
