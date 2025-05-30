import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/translation_helper.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../translation/presentation/bloc/translation_bloc.dart';

class LanguageActionSheet extends StatefulWidget {
  final Locale initialValue;

  const LanguageActionSheet({
    super.key,
    required this.initialValue,
  });

  @override
  State<LanguageActionSheet> createState() => _LanguageActionSheetState();
}

class _LanguageActionSheetState extends State<LanguageActionSheet> {
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

    return CupertinoActionSheet(
      title: const Text(LocaleKeys.language_title).tr(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(LocaleKeys.cancel_title).tr(),
      ),
      actions: locales
          .map(
            (locale) => CupertinoActionSheetAction(
              isDefaultAction: _locale == locale,
              onPressed: () {
                setState(() {
                  _locale = locale;
                  context.read<TranslationBloc>().add(
                        TranslationLocaleUpdated(locale),
                      );
                  context.setLocale(locale);
                  Navigator.of(context).pop();
                });
              },
              child: Column(
                children: [
                  Text(TranslationHelper.localeToString(locale)),
                  if (locale.languageCode != 'en')
                    Text(
                      TranslationHelper.localeToEnglishString(locale),
                      style: const TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
