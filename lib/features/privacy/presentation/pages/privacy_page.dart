// @dart=2.9

import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tautulli_remote/features/privacy/presentation/widgets/permission_setting_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';
// import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
// import '../../../settings/domain/usecases/settings.dart';
// import '../../../settings/presentation/bloc/settings_bloc.dart';

class PrivacyPage extends StatelessWidget {
  final bool showConsentSwitch;

  const PrivacyPage({
    Key key,
    this.showConsentSwitch = true,
  }) : super(key: key);

  static const routeName = '/privacy';

  @override
  Widget build(BuildContext context) {
    final oneSignalPrivacyBloc = context.read<OneSignalPrivacyBloc>();
    final oneSignalSubscriptionBloc = context.read<OneSignalSubscriptionBloc>();
    final oneSignalHealthBloc = context.read<OneSignalHealthBloc>();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('OneSignal Data Privacy'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //! OneSignal Data Privacy
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: _OneSignalDataPrivacyText(),
              ),
              if (showConsentSwitch)
                BlocBuilder<OneSignalPrivacyBloc, OneSignalPrivacyState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SwitchListTile(
                        title: const Text(
                          'Consent to OneSignal data privacy',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TautulliColorPalette.not_white,
                          ),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Status: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: TautulliColorPalette.not_white,
                                ),
                              ),
                              if (state is OneSignalPrivacyConsentFailure)
                                const TextSpan(
                                  text: 'Not Accepted X',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.red,
                                  ),
                                  // text: Platform.isIOS &&
                                  //         state
                                  //             .iosNotificationPermissionDeclined &&
                                  //         !state.iosAppTrackingPermissionGranted
                                  //     ? 'Tracking Permission Disabled'
                                  //     : Platform.isIOS &&
                                  //             state
                                  //                 .iosNotificationPermissionDeclined &&
                                  //             !state
                                  //                 .iosNotificationPermissionGranted
                                  //         ? 'Notification Permission Disabled'
                                  //         : 'Not Accepted X',
                                  // style: TextStyle(
                                  //   fontWeight: FontWeight.w300,
                                  //   color: (Platform.isIOS &&
                                  //               state
                                  //                   .iosNotificationPermissionDeclined) &&
                                  //           (!state.iosAppTrackingPermissionGranted ||
                                  //               !state
                                  //                   .iosNotificationPermissionGranted)
                                  //       ? Colors.grey
                                  //       : Colors.red,
                                  // ),
                                ),
                              if (state is OneSignalPrivacyConsentSuccess)
                                const TextSpan(
                                  text: 'Accepted ✓',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.green,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        value: state is OneSignalPrivacyConsentSuccess
                            ? true
                            : false,
                        onChanged:
                            // (Platform.isIOS &&
                            //             state is OneSignalPrivacyConsentFailure &&
                            //             state.iosNotificationPermissionDeclined) &&
                            //         (!state.iosAppTrackingPermissionGranted &&
                            //             !state.iosNotificationPermissionGranted)
                            //     ? null
                            //     :
                            (_) async {
                          if (state is OneSignalPrivacyConsentFailure) {
                            if (Platform.isIOS) {
                              if (await Permission.notification
                                  .request()
                                  .isGranted) {
                                oneSignalPrivacyBloc
                                    .add(OneSignalPrivacyGrantConsent());
                                await Future.delayed(const Duration(seconds: 2),
                                    () {
                                  oneSignalSubscriptionBloc
                                      .add(OneSignalSubscriptionCheck());
                                });
                                oneSignalHealthBloc.add(OneSignalHealthCheck());
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
                                // await di
                                //     .sl<Settings>()
                                //     .setIosNotificationPermissionDeclined(
                                //       true,
                                //     );
                                // context.read<SettingsBloc>().add(
                                //       SettingsUpdateOneSignalBannerDismiss(
                                //         true,
                                //       ),
                                //     );
                                // context
                                //     .read<OneSignalPrivacyBloc>()
                                //     .add(OneSignalPrivacyCheckConsent());
                              }
                              // if (await Permission.appTrackingTransparency
                              //     .request()
                              //     .isGranted) {
                              // } else {
                              //   await di
                              //       .sl<Settings>()
                              //       .setIosNotificationPermissionDeclined(
                              //         true,
                              //       );
                              //   context.read<SettingsBloc>().add(
                              //         SettingsUpdateOneSignalBannerDismiss(
                              //           true,
                              //         ),
                              //       );
                              //   context
                              //       .read<OneSignalPrivacyBloc>()
                              //       .add(OneSignalPrivacyCheckConsent());
                              // }
                              // if (await Permission.notification
                              //     .request()
                              //     .isGranted) {
                              //   oneSignalPrivacyBloc
                              //       .add(OneSignalPrivacyGrantConsent());
                              //   await Future.delayed(const Duration(seconds: 2),
                              //       () {
                              //     oneSignalSubscriptionBloc
                              //         .add(OneSignalSubscriptionCheck());
                              //   });
                              //   oneSignalHealthBloc.add(OneSignalHealthCheck());
                              // } else {
                              //   await di
                              //       .sl<Settings>()
                              //       .setIosNotificationPermissionDeclined(
                              //         true,
                              //       );
                              //   context.read<SettingsBloc>().add(
                              //         SettingsUpdateOneSignalBannerDismiss(
                              //           true,
                              //         ),
                              //       );
                              //   context
                              //       .read<OneSignalPrivacyBloc>()
                              //       .add(OneSignalPrivacyCheckConsent());
                              // }
                            } else {
                              oneSignalPrivacyBloc
                                  .add(OneSignalPrivacyGrantConsent());
                              await Future.delayed(const Duration(seconds: 2),
                                  () {
                                oneSignalSubscriptionBloc
                                    .add(OneSignalSubscriptionCheck());
                              });
                              oneSignalHealthBloc.add(OneSignalHealthCheck());
                            }
                          }
                          if (state is OneSignalPrivacyConsentSuccess) {
                            oneSignalPrivacyBloc
                                .add(OneSignalPrivacyRevokeConsent());
                            oneSignalSubscriptionBloc
                                .add(OneSignalSubscriptionCheck());
                            oneSignalHealthBloc.add(OneSignalHealthCheck());
                          }
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OneSignalDataPrivacyText extends StatelessWidget {
  const _OneSignalDataPrivacyText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textBlock1 = LocaleKeys.privacy_text_block_1.tr().split('%');
    final textBlock2 = LocaleKeys.privacy_text_block_2.tr().split('%');
    final textBlock3 = LocaleKeys.privacy_text_block_3.tr().split('%');
    final textBlock4 = LocaleKeys.privacy_text_block_4.tr().split('%');

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16),
        children: [
          TextSpan(
            text: textBlock1[0],
          ),
          TextSpan(
            text: textBlock1[1],
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(
                  'https://github.com/Tautulli/Tautulli/wiki/Frequently-Asked-Questions#notifications-pycryptodome',
                );
              },
          ),
          TextSpan(
            text: textBlock1[2],
          ),
          TextSpan(
            text: '\n\n${textBlock2[1]}',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(
                  'https://onesignal.com/',
                );
              },
          ),
          TextSpan(
            text: textBlock2[2],
          ),
          TextSpan(
            text: textBlock2[3],
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch('https://onesignal.com/privacy');
              },
          ),
          TextSpan(
            text: textBlock2[4],
          ),
          TextSpan(
            text: '\n\n${textBlock3[0]}',
          ),
          TextSpan(
            text: textBlock3[1],
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(
                    'https://documentation.onesignal.com/docs/handling-personal-data#deleting-notification-data');
              },
          ),
          TextSpan(
            text: textBlock3[2],
          ),
          TextSpan(
            text: '\n\n${textBlock4[0]}',
          ),
        ],
      ),
    );
  }
}
