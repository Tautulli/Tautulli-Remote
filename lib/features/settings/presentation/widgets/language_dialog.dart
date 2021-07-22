import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/translation_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../translate/presentation/bloc/translate_bloc.dart';

class LanguageDialog extends StatefulWidget {
  final Locale initialValue;

  LanguageDialog({
    Key key,
    @required this.initialValue,
  }) : super(key: key);

  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialValue;
  }

  void _languageRadioValueChanged(Locale value) {
    setState(() {
      _locale = value;
      context.read<TranslateBloc>().add(
            TranslateUpdate(locale: value),
          );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(LocaleKeys.settings_language_title).tr(),
      children: TranslationHelper.supportedLocales()
          .map(
            (locale) => RadioListTile(
              title: Text(
                TranslationHelper.localeToString(locale),
              ),
              value: locale,
              groupValue: _locale,
              onChanged: (value) {
                _languageRadioValueChanged(value);
                context.setLocale(value);
              },
            ),
          )
          .toList(),
    );
  }
}
