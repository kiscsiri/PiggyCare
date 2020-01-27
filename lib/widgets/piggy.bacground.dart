import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';

BoxDecoration piggyBackgroundDecoration(
    BuildContext context, UserType userType) {
  var align = Alignment.bottomRight;

  var assettName = 'assets/images/piggy_half.png';

  return BoxDecoration(
    image: DecorationImage(
        image: AssetImage(
          assettName,
        ),
        fit: BoxFit.scaleDown,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
        alignment: align),
  );
}

BoxDecoration coinBackground(BuildContext context, UserType userType) {
  var assettName = 'assets/images/coins.png';
  return BoxDecoration(
    color: Color.fromRGBO(255, 255, 0, 0),
    image: DecorationImage(
        image: AssetImage(
          assettName,
        ),
        fit: BoxFit.fitWidth,
        colorFilter: ColorFilter.mode(
            Color.fromRGBO(255, 255, 255, 0.1), BlendMode.lighten),
        alignment: Alignment.topCenter),
  );
}
