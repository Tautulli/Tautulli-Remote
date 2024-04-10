import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

import '../../translations/locale_keys.g.dart';

class TranslationHelper {
  static List<Locale> supportedLocales() {
    return [
      const Locale('bg'),
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
      const Locale('my'),
      const Locale('nb'),
      const Locale('nl'),
      const Locale('pl'),
      const Locale('pt', 'BR'),
      const Locale('pt', 'PT'),
      const Locale('ru'),
      const Locale('sk'),
      const Locale('sl'),
      const Locale('sq'),
      const Locale('sv'),
      const Locale('uk'),
      const Locale('zh'),
    ];
  }

  static String localeToString(Locale locale) {
    if (locale.languageCode == 'ca') {
      return 'Català';
    } else if (locale.languageCode == 'bg') {
      return 'Български';
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
    } else if (locale.languageCode == 'my') {
      return 'မြန်မာစာ';
    } else if (locale.languageCode == 'nb') {
      return 'Bokmål';
    } else if (locale.languageCode == 'nl') {
      return 'Nederlands';
    } else if (locale.languageCode == 'pl') {
      return 'Polski';
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
    } else if (locale.languageCode == 'sl') {
      return 'Slovenščina';
    } else if (locale.languageCode == 'sq') {
      return 'Shqip';
    } else if (locale.languageCode == 'sv') {
      return 'Svenska';
    } else if (locale.languageCode == 'uk') {
      return 'українська мова';
    } else if (locale.languageCode == 'zh') {
      return '简体中文';
    } else {
      return LocaleKeys.unknown_title.tr();
    }
  }

  static String localeToEnglishString(Locale locale) {
    if (locale.languageCode == 'bg') {
      return 'Bulgarian';
    } else if (locale.languageCode == 'ca') {
      return 'Catalan';
    } else if (locale.languageCode == 'cs') {
      return 'Czech';
    } else if (locale.languageCode == 'da') {
      return 'Danish';
    } else if (locale.languageCode == 'de') {
      return 'German';
    } else if (locale.languageCode == 'el') {
      return 'Greek';
    } else if (locale.languageCode == 'en') {
      return 'English';
    } else if (locale.languageCode == 'es') {
      return 'Spanish';
    } else if (locale.languageCode == 'fr') {
      return 'French';
    } else if (locale.languageCode == 'hu') {
      return 'Hungarian';
    } else if (locale.languageCode == 'it') {
      return 'Italian';
    } else if (locale.languageCode == 'my') {
      return 'Myanmar';
    } else if (locale.languageCode == 'nb') {
      return 'Norwegian Bokmål';
    } else if (locale.languageCode == 'nl') {
      return 'Dutch';
    } else if (locale.languageCode == 'pl') {
      return 'Polish';
    } else if (locale.languageCode == 'pt') {
      if (locale.countryCode == 'BR') {
        return 'Portuguese (Brazil)';
      } else {
        return 'Portuguese (Portugal)';
      }
    } else if (locale.languageCode == 'ru') {
      return 'Russian';
    } else if (locale.languageCode == 'sk') {
      return 'Slovak';
    } else if (locale.languageCode == 'sl') {
      return 'Slovene';
    } else if (locale.languageCode == 'sq') {
      return 'Albanian';
    } else if (locale.languageCode == 'sv') {
      return 'Swedish';
    } else if (locale.languageCode == 'uk') {
      return 'Ukranian';
    } else if (locale.languageCode == 'zh') {
      return 'Chinese (Simplified)';
    } else {
      return LocaleKeys.unknown_title.tr();
    }
  }
}
