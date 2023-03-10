import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/translation_helper.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../translation/presentation/bloc/translation_bloc.dart';

class LanguageDialog extends StatefulWidget {
  final Locale initialValue;

  const LanguageDialog({
    super.key,
    required this.initialValue,
  });

  @override
  LanguageDialogState createState() => LanguageDialogState();
}

class LanguageDialogState extends State<LanguageDialog> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locales = TranslationHelper.supportedLocales();
    locales.sort(
      (a, b) => TranslationHelper.localeToEnglishString(a).compareTo(
        TranslationHelper.localeToEnglishString(b),
      ),
    );
    return SimpleDialog(
      clipBehavior: Clip.hardEdge,
      titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      title: const Text(LocaleKeys.language_title).tr(),
      children: locales
          .map(
            (locale) => RadioListTile(
              title: Text(
                TranslationHelper.localeToString(locale),
              ),
              subtitle: locale.languageCode != 'en'
                  ? Text(
                      TranslationHelper.localeToEnglishString(locale),
                    )
                  : null,
              value: locale,
              groupValue: _locale,
              onChanged: (value) {
                setState(() {
                  _locale = value as Locale;
                  context.read<TranslationBloc>().add(
                        TranslationLocaleUpdated(locale),
                      );
                  context.setLocale(value);
                  Navigator.of(context).pop();
                });
              },
            ),
          )
          .toList(),
    );
  }
}
