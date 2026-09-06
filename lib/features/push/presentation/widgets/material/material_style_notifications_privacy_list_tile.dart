import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/helpers/permission_helper.dart';
import '../../../../../core/widgets/material/dialogs/material_style_permission_setting_dialog.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/push_health_bloc.dart';
import '../../bloc/push_privacy_bloc.dart';

class MaterialStyleNotificationsPrivacyListTile extends StatelessWidget {
  const MaterialStyleNotificationsPrivacyListTile({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    final pushPrivacyBloc = context.read<PushPrivacyBloc>();
    final pushHealthBloc = context.read<PushHealthBloc>();
    return BlocBuilder<PushPrivacyBloc, PushPrivacyState>(
      builder: (context, state) {
        return Material(
          color: ElevationOverlay.applySurfaceTint(
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceTint,
            1,
          ),
          child: SwitchListTile(
            title: const Text(LocaleKeys.notifications_consent_switch_title).tr(),
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
                    if (state is PushPrivacyFailure)
                      TextSpan(
                        text: '${LocaleKeys.not_accepted_title.tr()} X',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    if (state is PushPrivacySuccess)
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
            value: state is PushPrivacySuccess,
            onChanged: (_) async {
              // If current state is PushPrivacyFailure then go through the
              // steps to grant permission.
              if (state is PushPrivacyFailure) {
                final status = await PermissionHelper.requestNotification();
                if (status == null) return;
                if (status.isGranted) {
                  pushPrivacyBloc.add(
                    PushPrivacyGrant(),
                  );
                  pushHealthBloc.add(PushHealthCheck());
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => MaterialStylePermissionSettingDialog(
                      title: LocaleKeys.notification_permission_dialog_title.tr(),
                      content: LocaleKeys.notification_permission_dialog_content.tr(),
                    ),
                  );
                }
              }
              // If current state is PushPrivacySuccess then revoke consent
              if (state is PushPrivacySuccess) {
                pushPrivacyBloc.add(
                  PushPrivacyRevoke(),
                );
                pushHealthBloc.add(PushHealthCheck());
              }
            },
          ),
        );
      },
    );
  }
}
