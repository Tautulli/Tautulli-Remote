// @dart=2.9

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

import '../../translations/locale_keys.g.dart';

class TranslationHelper {
  static List<Locale> supportedLocales() {
    return [
      const Locale('ca'),
      const Locale('cs'),
      const Locale('da'),
      const Locale('de'),
      const Locale('el'),
      const Locale('en'),
      const Locale('es'),
      const Locale('fr'),
      const Locale('hu'),
      const Locale('it'),
      const Locale('nl'),
      const Locale('pt', 'BR'),
      const Locale('pt', 'PT'),
      const Locale('ru'),
      const Locale('sk'),
      const Locale('sv'),
    ];
  }

  static String localeToString(Locale locale) {
    if (locale.languageCode == 'ca') {
      return 'Català';
    } else if (locale.languageCode == 'cs') {
      return 'Čeština';
    } else if (locale.languageCode == 'da') {
      return 'Dansk';
    } else if (locale.languageCode == 'de') {
      return 'Deutsch';
    } else if (locale.languageCode == 'el') {
      return 'Eλληνικά';
    } else if (locale.languageCode == 'en') {
      return 'English';
    } else if (locale.languageCode == 'es') {
      return 'Español';
    } else if (locale.languageCode == 'fr') {
      return 'Français';
    } else if (locale.languageCode == 'hu') {
      return 'Magyar';
    } else if (locale.languageCode == 'it') {
      return 'Italiano';
    } else if (locale.languageCode == 'nl') {
      return 'Nederlands';
    } else if (locale.languageCode == 'pt') {
      if (locale.countryCode == 'BR') {
        return 'Português (Brasil)';
      } else {
        return 'Português (Portugal)';
      }
    } else if (locale.languageCode == 'ru') {
      return 'Русский';
    } else if (locale.languageCode == 'sk') {
      return 'Slovenčina';
    } else if (locale.languageCode == 'sv') {
      return 'Svenska';
    } else {
      return LocaleKeys.general_unknown.tr();
    }
  }
}
