import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/translation_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/language_dialog.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({Key key}) : super(key: key);

  static const routeName = '/advanced';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(
          LocaleKeys.advanced_settings_page_title,
        ).tr(),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoadSuccess) {
            return ListView(
              children: [
                if (Platform.isAndroid)
                  CheckboxListTile(
                    title: const Text(LocaleKeys.settings_double_tap_exit_title)
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
                  title: const Text(LocaleKeys.settings_mask_info_title).tr(),
                  subtitle:
                      const Text(LocaleKeys.settings_mask_info_message).tr(),
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
    );
  }
}
