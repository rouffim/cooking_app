import 'package:cool_cooker/l10n/app_en.dart';
import 'package:cool_cooker/l10n/app_fr.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  static Map<String, Map<String, String>> _localizedValues = {
    'en': EnMessages.getMessages(),
    'fr': FrMessages.getMessages(),
  };

  String getMessage(String key) {
    return _localizedValues[locale.languageCode].containsKey(key) ?
      _localizedValues[locale.languageCode][key] : 'UNKNOWN MESSAGE KEY';
  }

  String getMessageOrDefault(String key, String defaultKey) {
    return _localizedValues[locale.languageCode].containsKey(key) ?
    _localizedValues[locale.languageCode][key] : getMessage(defaultKey);
  }
}
