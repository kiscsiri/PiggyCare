import 'dart:async';

import 'package:flutter/material.dart';
import 'package:piggycare/localization/Localizations.dart';

class PiggyLocalizationsDelegate
    extends LocalizationsDelegate<PiggyLocalizations> {
  const PiggyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['hu', 'en'].contains(locale.languageCode);

  @override
  Future<PiggyLocalizations> load(Locale locale) async {
    PiggyLocalizations localizations = new PiggyLocalizations(locale);
    await localizations.load();

    print("Load ${locale.languageCode}");

    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}
