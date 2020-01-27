import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:piggybanx/enums/userType.dart';

BoxDecoration piggyBackgroundDecoration(BuildContext context, UserType userType) {
  var offset = (MediaQuery.of(context).size.height / MediaQuery.of(context).size.width) * 0.17;
var assett = userType == UserType.child ? 'assets/images/Baby-Normal.png' : 'assets/images/adult_profile_4K.png';
  return BoxDecoration(
    color: Color.fromRGBO(255, 255, 0, 0),
    image: DecorationImage(
        image: AssetImage(
          assett,
        ),

        fit: BoxFit.fitWidth,
        colorFilter: ColorFilter.mode(
            Color.fromRGBO(255, 255, 255, 0.6), BlendMode.lighten),
        alignment: Alignment.bottomRight),
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


