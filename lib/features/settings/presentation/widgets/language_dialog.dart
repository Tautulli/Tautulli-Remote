import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/translation_helper.dart';
import '../../../translation/presentation/bloc/translation_bloc.dart';

class LanguageDialog extends StatefulWidget {
  final Locale initialValue;

  const LanguageDialog({
    Key? key,
    required this.initialValue,
  }) : super(key: key);

  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Language'),
      children: TranslationHelper.supportedLocales()
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
