import 'package:flutter/material.dart';

enum PiggyLevel { Baby, Child, Teen, Adult, Old }

int levelMap(PiggyLevel level) {
  switch (level) {
    case PiggyLevel.Baby:
      return 0;
    case PiggyLevel.Child:
      return 1;
    case PiggyLevel.Teen:
      return 2;
    case PiggyLevel.Adult:
      return 3;
    case PiggyLevel.Old:
      return 4;
    default:
      return 0;
  }
}

String levelStringValue(PiggyLevel level) {
  switch (level) {
    case PiggyLevel.Baby:
      return "Baby";
    case PiggyLevel.Child:
      return "Child";
    case PiggyLevel.Teen:
      return "Teen";
    case PiggyLevel.Adult:
      return "Adult";
    case PiggyLevel.Old:
      return "Old";
    default:
      return "";
  }
}

Widget getAnimation(PiggyLevel level) {
  switch (level) {
    case PiggyLevel.Baby:
      return Image.asset(
        'lib/assets/animation/animation-piggy.gif',
        gaplessPlayback: true,
      );
    case PiggyLevel.Child:
      return Image.asset(
        'lib/assets/animation/animation-piggy.gif',
        gaplessPlayback: true,
      );
    case PiggyLevel.Teen:
      return Image.asset(
        'lib/assets/animation/animation-piggy.gif',
        gaplessPlayback: true,
      );
    case PiggyLevel.Adult:
      return Image.asset(
        'lib/assets/animation/animation-piggy.gif',
        gaplessPlayback: true,
      );
    case PiggyLevel.Old:
      return Image.asset(
        'lib/assets/animation/animation-piggy.gif',
        gaplessPlayback: true,
      );
    default:
      return Container();
  }
}
