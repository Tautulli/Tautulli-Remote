import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/widgets/permission_setting_dialog.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/onesignal_health_bloc.dart';
import '../bloc/onesignal_privacy_bloc.dart';

class OneSignalDataPrivacyListTile extends StatelessWidget {
  const OneSignalDataPrivacyListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = context.read<OneSignalPrivacyBloc>();
    final oneSignalHealthBloc = context.read<OneSignalHealthBloc>();
    final settingsBloc = context.read<SettingsBloc>();

    return BlocBuilder<OneSignalPrivacyBloc, OneSignalPrivacyState>(
      builder: (context, state) {
        return Material(
          color: ElevationOverlay.applySurfaceTint(
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceTint,
            1,
          ),
          child: SwitchListTile(
            title: const Text(LocaleKeys.onesignal_consent_switch_title).tr(),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${LocaleKeys.status_title.tr()}: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    if (state is OneSignalPrivacyFailure)
                      TextSpan(
                        text: '${LocaleKeys.not_accepted_title.tr()} X',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    if (state is OneSignalPrivacySuccess)
                      TextSpan(
                        text: '${LocaleKeys.accepted_title.tr()} ✓',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            value: state is OneSignalPrivacySuccess,
            onChanged: (_) async {
              // If current state is OneSignalPrivacyFailure then go through the
              // steps to grant permission.
              if (state is OneSignalPrivacyFailure) {
                if (await Permission.notification.request().isGranted) {
                  oneSignalPrivacyBloc.add(
                    OneSignalPrivacyGrant(settingsBloc: settingsBloc),
                  );
                  oneSignalHealthBloc.add(OneSignalHealthCheck());
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => PermissionSettingDialog(
                      title: LocaleKeys.notification_permission_dialog_title.tr(),
                      content: LocaleKeys.notification_permission_dialog_content.tr(),
                    ),
                  );
                }
              }
              // If current state is OneSignalPrivacySuccess then revoke consent
              if (state is OneSignalPrivacySuccess) {
                oneSignalPrivacyBloc.add(
                  OneSignalPrivacyRevoke(settingsBloc: settingsBloc),
                );
                oneSignalHealthBloc.add(OneSignalHealthCheck());
              }
            },
          ),
        );
      },
    );
  }
}
