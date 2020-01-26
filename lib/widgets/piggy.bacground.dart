import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

BoxDecoration piggyBackgroundDecoration(BuildContext context) {
  var offset = (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width) * 0.17;

  return BoxDecoration(
    color: Color.fromRGBO(255, 0, 0, 255),
    image: DecorationImage(
        image: AssetImage(
          'assets/images/adult_profile_4K.png',
        ),
        fit: BoxFit.fitHeight,
        colorFilter: ColorFilter.mode(
            Color.fromRGBO(255, 255, 255, 0.6), BlendMode.lighten),
        alignment: AlignmentDirectional(
          offset,
          0,
        )),
  );
}

piggyBabyBackgroundDecoration(BuildContext context) {
  var offset = (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width) * 1;
  return BoxDecoration(
    color: Color.fromRGBO(255, 0, 0, 255),
    image: DecorationImage(
        image: AssetImage(
          'assets/images/Baby-Normal.png',
        ),
        fit: BoxFit.fitHeight,
        colorFilter: ColorFilter.mode(
            Color.fromRGBO(255, 255, 255, 0.6), BlendMode.lighten),
        alignment:
            AlignmentDirectional(offset, 0)),
  );
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeCounter(int counter) async {
  final file = await _localFile;

  // Write the file.
  return file.writeAsString('$counter');
}


