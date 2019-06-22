import 'package:flutter/material.dart';

enum PiggyLevel { baby, child, teen, adult, old }

int levelMap(PiggyLevel level) {
  switch (level) {
    case PiggyLevel.baby:
      return 0;
    case PiggyLevel.child:
      return 1;
    case PiggyLevel.teen:
      return 2;
    case PiggyLevel.adult:
      return 3;
    case PiggyLevel.old:
      return 4;
    default:
      return 0;
  }
}

Widget getAnimation(PiggyLevel level) {
  switch (level) {
    case PiggyLevel.baby:
      return Image.asset(
        'lib/assets/animation/animation-piggy.gif',
        gaplessPlayback: true,
      );
    case PiggyLevel.child:
      return Image.asset(
        'lib/assets/animation/animation-piggy.gif',
        gaplessPlayback: true,
      );
    case PiggyLevel.teen:
      return Image.asset(
        'lib/assets/animation/animation-piggy.gif',
        gaplessPlayback: true,
      );
    case PiggyLevel.adult:
      return Image.asset(
        'lib/assets/animation/animation-piggy.gif',
        gaplessPlayback: true,
      );
    case PiggyLevel.old:
      return Image.asset(
        'lib/assets/animation/animation-piggy.gif',
        gaplessPlayback: true,
      );
    default:
      return Container();
  }
}
