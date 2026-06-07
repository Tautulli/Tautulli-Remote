import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../translations/locale_keys.g.dart';
import '../../pages/cupertino/cupertino_style_status_page.dart';

class SettingsNotLoadedIos extends StatelessWidget {
  const SettingsNotLoadedIos({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsInProgress) {
            return CupertinoStyleStatusPage(
              message: LocaleKeys.settings_loading_message.tr(),
              action: const CupertinoActivityIndicator(),
            );
          }
          if (state is SettingsFailure) {
            return CupertinoStyleStatusPage(
              message: LocaleKeys.settings_load_failed_message.tr(),
              action: CupertinoButton.filled(
                child: const Text(LocaleKeys.contact_support_title).tr(),
                onPressed: () async {
                  await launchUrlString(
                    mode: LaunchMode.externalApplication,
                    'https://tautulli.com/#support',
                  );
                },
              ),
            );
          }
          return CupertinoStyleStatusPage(
            message: LocaleKeys.settings_load_error_message.tr(),
            action: CupertinoButton.filled(
              onPressed: () async {
                await launchUrlString(
                  mode: LaunchMode.externalApplication,
                  'https://tautulli.com/#support',
                );
              },
              child: const Text(LocaleKeys.contact_support_title).tr(),
            ),
          );
        },
      ),
    );
  }
}
