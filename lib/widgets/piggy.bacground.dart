import 'package:flutter/material.dart';

BoxDecoration piggyBackgroundDecoration(BuildContext context) {
  var align = Alignment.bottomRight;

  var assettName = 'assets/images/child_half.png';

  return BoxDecoration(
    image: DecorationImage(
        image: AssetImage(
          assettName,
        ),
        fit: BoxFit.scaleDown,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.4), BlendMode.dstATop),
        alignment: align),
  );
}

BoxDecoration piggyTeenBackgroundDecoration(BuildContext context) {
  var align = Alignment.bottomRight;

  var assettName = 'assets/images/teen_half.png';

  return BoxDecoration(
    image: DecorationImage(
        image: AssetImage(
          assettName,
        ),
        fit: BoxFit.scaleDown,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.4), BlendMode.dstATop),
        alignment: align),
  );
}

BoxDecoration piggyBusinessBackgroundDecoration(BuildContext context) {
  var align = Alignment.bottomRight;

  var assettName = 'assets/images/piggy_business_half_left_b.png';

  return BoxDecoration(
    image: DecorationImage(
        image: AssetImage(
          assettName,
        ),
        fit: BoxFit.scaleDown,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.4), BlendMode.dstATop),
        alignment: align),
  );
}

BoxDecoration piggyChildBackgroundDecoration(BuildContext context) {
  var align = Alignment.bottomRight;

  var assettName = 'assets/images/child_half.png';

  return BoxDecoration(
    image: DecorationImage(
        image: AssetImage(
          assettName,
        ),
        fit: BoxFit.scaleDown,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.3), BlendMode.dstATop),
        alignment: align),
  );
}

BoxDecoration piggyFamilyBackgroundDecoration(BuildContext context) {
  var align = Alignment.center;
  var assettName = 'assets/images/adult_create.png';
  return BoxDecoration(
    image: DecorationImage(
        image: AssetImage(
          assettName,
        ),
        fit: BoxFit.scaleDown,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.3), BlendMode.dstATop),
        alignment: align),
  );
}

BoxDecoration coinBackground(BuildContext context) {
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
