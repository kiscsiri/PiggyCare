import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:piggybanx/enums/level.dart';
import 'package:piggybanx/enums/period.dart';
import 'package:piggybanx/localization/Localizations.dart';
import 'package:piggybanx/models/appState.dart';
import 'package:piggybanx/models/item/item.model.dart';
import 'package:piggybanx/models/user/user.actions.dart';
import 'package:piggybanx/services/notification.services.dart';
import 'package:piggybanx/widgets/individual.piggy.dart';
import 'package:piggybanx/widgets/piggy.button.dart';
import 'package:piggybanx/widgets/piggy.coin.dart';
import 'package:piggybanx/widgets/piggy.main.dart';
import 'package:piggybanx/widgets/piggy.progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class PiggyPage extends StatefulWidget {
  PiggyPage({Key key, this.title, this.store}) : super(key: key);

  final String title;
  final Store<AppState> store;

  @override
  _PiggyPageState createState() => new _PiggyPageState();
}

class _PiggyPageState extends State<PiggyPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: IndividualPiggyWidget(
      store: widget.store,
    ));
  }
}
