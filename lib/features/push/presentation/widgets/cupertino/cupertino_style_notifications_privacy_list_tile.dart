import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/helpers/permission_helper.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/cupertino/dialogs/cupertino_style_permission_setting_dialog.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../bloc/push_health_bloc.dart';
import '../../bloc/push_privacy_bloc.dart';
import '../../bloc/push_sub_bloc.dart';

class CupertinoStyleNotificationsPrivacyListTile extends StatelessWidget {
  const CupertinoStyleNotificationsPrivacyListTile({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    final pushPrivacyBloc = context.read<PushPrivacyBloc>();
    final pushHealthBloc = context.read<PushHealthBloc>();
    final pushSubBloc = context.read<PushSubBloc>();

    return BlocBuilder<PushPrivacyBloc, PushPrivacyState>(
      builder: (context, state) {
        return CupertinoStyleNotchedCupertinoListTile(
          trailing: CupertinoSwitch(
            value: state is PushPrivacySuccess,
            onChanged: (value) async {
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
                  // Consent is what allows a token to be minted, so the
                  // subscription state is stale until consent has actually been
                  // recorded. Waiting for the grant to land before re-checking
                  // stops the "not registered" banner lingering until a restart.
                  await pushPrivacyBloc.stream.firstWhere((s) => s is! PushPrivacyInitial);
                  pushSubBloc.add(PushSubCheck());
                } else {
                  await showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoStylePermissionSettingDialog(
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
                await pushPrivacyBloc.stream.firstWhere((s) => s is! PushPrivacySuccess);
                pushSubBloc.add(PushSubCheck());
              }
            },
          ),
          titleText: LocaleKeys.notifications_consent_switch_title.tr(),
          subtitleWidget: RichText(
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: CupertinoColors.systemRed,
                    ),
                  ),
                if (state is PushPrivacySuccess)
                  TextSpan(
                    text: '${LocaleKeys.accepted_title.tr()} ✓',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: CupertinoTheme.of(context).primaryColor,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
