import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/translation_helper.dart';
import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../../../translation/presentation/bloc/translation_bloc.dart';

class MaterialStyleLanguageBottomSheet extends StatelessWidget {
  final Locale initialValue;

  const MaterialStyleLanguageBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final List<Locale> locales = TranslationHelper.supportedLocales()
      ..sort(
        (a, b) => TranslationHelper.localeToEnglishString(a).compareTo(
          TranslationHelper.localeToEnglishString(b),
        ),
      );

    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.language_title.tr(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: locales.map((locale) {
            return _SelectTile(
              title: TranslationHelper.localeToString(locale),
              subtitle: locale.languageCode != 'en' ? TranslationHelper.localeToEnglishString(locale) : null,
              selected: initialValue == locale,
              onTap: () {
                context.read<TranslationBloc>().add(TranslationLocaleUpdated(locale));
                context.setLocale(locale);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _SelectTile({
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ElevationOverlay.applySurfaceTint(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        1,
      ),
      child: ListTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: selected
            ? Icon(
                Icons.check_rounded,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
