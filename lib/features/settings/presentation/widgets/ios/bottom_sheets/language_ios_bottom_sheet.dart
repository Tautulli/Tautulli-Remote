import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/translation_helper.dart';
import '../../../../../../core/widgets/ios/cupertino_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
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

    return CupertinoModalPopupScaffold(
      middleText: LocaleKeys.language_title.tr(),
      leading: const IosBottomSheetCancelButton(),
      child: CustomCupertinoListSection(
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
                titleText: TranslationHelper.localeToString(locale),
                subtitleText: locale.languageCode != 'en' ? TranslationHelper.localeToEnglishString(locale) : null,
                trailing: initialValue == locale ? const Icon(CupertinoIcons.checkmark_alt) : null,
              ),
            )
            .toList(),
      ),
    );
  }
}
