import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/translation_helper.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../translation/presentation/bloc/translation_bloc.dart';

class LanguageIosBottomSheet extends StatelessWidget {
  final Locale initialValue;

  const LanguageIosBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    List<Locale> locales = TranslationHelper.supportedLocales();
    locales.sort(
      (a, b) => TranslationHelper.localeToEnglishString(a).compareTo(
        TranslationHelper.localeToEnglishString(b),
      ),
    );

    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.home_page_title).tr(),
      leading: const IosBottomSheetCancelButton(),
      child: ListView(
        children: [
          CustomCupertinoListSection(
            hasLeading: false,
            children: locales
                .map(
                  (locale) => CustomNotchedCupertinoListTile(
                    onTap: () {
                      context.read<TranslationBloc>().add(
                            TranslationLocaleUpdated(locale),
                          );
                      context.setLocale(locale);
                      Navigator.of(context).pop();
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                    trailing: initialValue == locale ? const Icon(CupertinoIcons.checkmark_alt) : null,
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
