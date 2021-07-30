import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/translation_helper.dart';
import '../../../../core/widgets/list_header.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../cache/presentation/bloc/cache_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/clear_cache_dialog.dart';
import '../widgets/language_dialog.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({Key key}) : super(key: key);

  static const routeName = '/advanced';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<CacheBloc>(),
      child: const AdvancedSettingsPageContent(),
    );
  }
}

class AdvancedSettingsPageContent extends StatelessWidget {
  const AdvancedSettingsPageContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text(
            LocaleKeys.advanced_settings_page_title,
          ).tr(),
        ),
        body: BlocListener<CacheBloc, CacheState>(
          listener: (context, state) {
            if (state is CacheSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: PlexColorPalette.shark,
                  content: const Text(LocaleKeys.image_cache_clear_alert).tr(),
                ),
              );
            }
          },
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoadSuccess) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListHeader(
                        headingText:
                            LocaleKeys.advanced_settings_page_title.tr(),
                      ),
                    ),
                    if (Platform.isAndroid)
                      CheckboxListTile(
                        title: const Text(
                                LocaleKeys.settings_double_tap_exit_title)
                            .tr(),
                        subtitle: const Text(
                          LocaleKeys.settings_double_tap_exit_message,
                        ).tr(),
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(
                                SettingsUpdateDoubleTapToExit(
                                  value: value,
                                ),
                              );
                        },
                        value: state.doubleTapToExit ?? false,
                      ),
                    CheckboxListTile(
                      title:
                          const Text(LocaleKeys.settings_mask_info_title).tr(),
                      subtitle:
                          const Text(LocaleKeys.settings_mask_info_message)
                              .tr(),
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                              SettingsUpdateMaskSensitiveInfo(
                                value: value,
                              ),
                            );
                      },
                      value: state.maskSensitiveInfo ?? false,
                    ),
                    ListTile(
                      title: const Text(
                        LocaleKeys.settings_language_title,
                      ).tr(),
                      subtitle: Text(
                        TranslationHelper.localeToString(context.locale),
                      ),
                      onTap: () {
                        return showDialog(
                          context: context,
                          builder: (context) => LanguageDialog(
                            initialValue: context.locale,
                          ),
                        );
                      },
                    ),
                    ListHeader(headingText: LocaleKeys.operations_heading.tr()),
                    ListTile(
                      title: const Text(
                        LocaleKeys.settings_clear_cache_title,
                      ).tr(),
                      subtitle: const Text(
                        LocaleKeys.settings_clear_cache_subtitle,
                      ).tr(),
                      onTap: () async {
                        await clearCacheDialog(
                          context: context,
                          cacheBloc: context.read<CacheBloc>(),
                        );
                      },
                    ),
                  ],
                );
              }
              if (state is SettingsLoadInProgress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const Center(
                child: Text('ERROR'),
              );
            },
          ),
        ));
  }
}
