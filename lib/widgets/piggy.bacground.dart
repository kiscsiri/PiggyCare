import 'package:flutter/material.dart';

piggyBackgroundDecoration(BuildContext context) {
  return BoxDecoration(
    color: Color.fromRGBO(255, 0, 0, 255),
    image: DecorationImage(
        image: AssetImage(
          'assets/images/adult_profile_4K.png',
        ),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
            Color.fromRGBO(255, 255, 255, 0.6), BlendMode.lighten),
        alignment: AlignmentDirectional(
            MediaQuery.of(context).size.width * 0.0014, 0)),
  );
}

piggyBabyBackgroundDecoration(BuildContext context) {
  return BoxDecoration(
    color: Color.fromRGBO(255, 0, 0, 255),
    image: DecorationImage(
        image: AssetImage(
          'assets/images/Baby-Normal.png',
        ),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
            Color.fromRGBO(255, 255, 255, 0.6), BlendMode.lighten),
        alignment:
            AlignmentDirectional(MediaQuery.of(context).size.width * 0.017, 0)),
  );
}
