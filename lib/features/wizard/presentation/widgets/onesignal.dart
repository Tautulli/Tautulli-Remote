// @dart=2.9

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tautulli_remote/features/privacy/presentation/widgets/permission_setting_dialog.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../privacy/presentation/pages/privacy_page.dart';
// import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/wizard_bloc.dart';

class OneSignal extends StatelessWidget {
  const OneSignal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 42),
      child: Column(
        children: [
          const Text(
            'OneSignal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 17,
                  bottom: 8,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      LocaleKeys.wizard_onesignal_text_1,
                      style: TextStyle(fontSize: 16),
                    ).tr(),
                    const SizedBox(height: 12),
                    const Text(
                      LocaleKeys.wizard_onesignal_text_2,
                      style: TextStyle(fontSize: 16),
                    ).tr(),
                  ],
                ),
              ),
              const Divider(
                indent: 8,
                endIndent: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPage(
                                showConsentSwitch: false,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          LocaleKeys.button_view_onesignal_privacy,
                        ).tr(),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<OneSignalHealthBloc, OneSignalHealthState>(
                builder: (context, healthState) {
                  if (healthState is OneSignalHealthFailure) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          color: Colors.red[900],
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              right: 8,
                              left: 8,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.exclamationCircle,
                                      color: TautulliColorPalette.not_white,
                                      size: 30,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: const Text(
                                        LocaleKeys
                                            .wizard_onesignal_communication_error,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ).tr(),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        context.read<OneSignalHealthBloc>().add(
                                              OneSignalHealthCheck(),
                                            );
                                      },
                                      child: const Text(
                                        LocaleKeys.button_check_again,
                                      ).tr(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return BlocBuilder<WizardBloc, WizardState>(
                      builder: (context, wizardState) {
                        if (wizardState is WizardLoaded) {
                          return CheckboxListTile(
                            value: wizardState.onesignalAccepted,
                            onChanged:
                                // wizardState.onesignalPermissionRejected
                                //     ? null
                                //     :
                                (value) async {
                              if (Platform.isIOS) {
                                if (await Permission.notification
                                    .request()
                                    .isGranted) {
                                  // context.read<WizardBloc>().add(
                                  //     WizardUpdateIosNotificationPermission());
                                  context.read<WizardBloc>().add(
                                        WizardAcceptOneSignal(value),
                                      );
                                } else {
                                  await showPermissionSettingsDialog(
                                    context,
                                    LocaleKeys
                                        .privacy_notification_permission_dialog_title
                                        .tr(),
                                    LocaleKeys
                                        .privacy_notification_permission_dialog_content
                                        .tr(),
                                  );
                                  // context.read<WizardBloc>().add(
                                  //       WizardRejectOneSignalPermission(),
                                  //     );
                                  // context.read<SettingsBloc>().add(
                                  //       SettingsUpdateOneSignalBannerDismiss(
                                  //         true,
                                  //       ),
                                  //     );
                                }
                                // if (await Permission
                                //     .appTrackingTransparency
                                //     .request()
                                //     .isGranted) {
                                //   context.read<WizardBloc>().add(
                                //       WizardUpdateIosAppTrackingPermission());
                                //   if (await Permission.notification
                                //       .request()
                                //       .isGranted) {
                                //     context.read<WizardBloc>().add(
                                //         WizardUpdateIosNotificationPermission());
                                //     context.read<WizardBloc>().add(
                                //           WizardAcceptOneSignal(value),
                                //         );
                                //   } else {
                                //     context.read<WizardBloc>().add(
                                //           WizardRejectOneSignalPermission(),
                                //         );
                                //     context.read<SettingsBloc>().add(
                                //           SettingsUpdateOneSignalBannerDismiss(
                                //             true,
                                //           ),
                                //         );
                                //   }
                                // } else {
                                //   context.read<WizardBloc>().add(
                                //         WizardRejectOneSignalPermission(),
                                //       );
                                //   context.read<SettingsBloc>().add(
                                //         SettingsUpdateOneSignalBannerDismiss(
                                //           true,
                                //         ),
                                //       );
                                // }
                              } else {
                                context.read<WizardBloc>().add(
                                      WizardAcceptOneSignal(value),
                                    );
                              }
                            },
                            // isThreeLine: Platform.isIOS,
                            title: const Text(
                              LocaleKeys.wizard_onesignal_allow_message,
                            ).tr(),
                            // subtitle: Platform.isIOS
                            //     ? RichText(
                            //         text: TextSpan(
                            //           children: [
                            //             TextSpan(
                            //               text: wizardState
                            //                       .iosAppTrackingPermission
                            //                   ? 'Tracking Permission: Enabled\n'
                            //                   : 'Tracking Permission: Disabled\n',
                            //               style: const TextStyle(
                            //                 color: Colors.grey,
                            //               ),
                            //             ),
                            //             TextSpan(
                            //               text: wizardState
                            //                       .iosNotificationPermission
                            //                   ? 'Notification Permission: Enabled\n'
                            //                   : 'Notification Permission: Disabled\n',
                            //               style: const TextStyle(
                            //                 color: Colors.grey,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       )
                            //     : null,
                          );
                        }
                        return const SizedBox(height: 0, width: 0);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
