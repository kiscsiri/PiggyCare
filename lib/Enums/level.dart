import 'package:flutter/material.dart';

import 'package:piggybanx/Enums/level.dart' as PiggyLevel2;

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

// Ez itt package összeakadás miatt van, így kellett megoldani, mert valamiért 2 csomagba csinált egy enums és egy Enums mappa ágat is
String levelStringValue(PiggyLevel2.PiggyLevel level) {
  switch (level) {
    case PiggyLevel2.PiggyLevel.Baby:
      return "Baby";
    case PiggyLevel2.PiggyLevel.Child:
      return "Child";
    case PiggyLevel2.PiggyLevel.Teen:
      return "Teen";
    case PiggyLevel2.PiggyLevel.Adult:
      return "Adult";
    case PiggyLevel2.PiggyLevel.Old:
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
