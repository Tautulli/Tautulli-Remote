// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/wizard_bloc.dart';
import '../widgets/closing.dart';
import '../widgets/onesignal.dart';
import '../widgets/servers.dart';

enum FabState {
  enabled,
  disabled,
  skip,
  finish,
}

SwiperController _swiperController = SwiperController();

class WizardPage extends StatelessWidget {
  const WizardPage({Key key}) : super(key: key);

  static const routeName = '/wizard';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<WizardBloc>(),
      child: const WizardPageContent(),
    );
  }
}

class WizardPageContent extends StatefulWidget {
  const WizardPageContent({Key key}) : super(key: key);

  @override
  _WizardPageContentState createState() => _WizardPageContentState();
}

class _WizardPageContentState extends State<WizardPageContent> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(
          SettingsUpdateWizardCompleteStatus(false),
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final result = await _showQuitDialog(context);
        if (result) {
          await Navigator.of(context).pushNamedAndRemoveUntil(
            '/activity',
            (Route<dynamic> route) => false,
          );
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        // Without the appbar the SystemUiOverlayStyle is not setting the
        // notification bar icons to white
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(),
        ),
        floatingActionButton: BlocBuilder<WizardBloc, WizardState>(
          builder: (context, wizardState) {
            return BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                if (wizardState is WizardLoaded) {
                  if (settingsState is SettingsLoadSuccess) {
                    FabState fabState = _determineFabState(
                      currentWizardStage: currentWizardStage,
                      onesignalAccepted: wizardState.onesignalAccepted,
                      // onesignalPermissionRejected:
                      //     wizardState.onesignalPermissionRejected,
                      settingsState: settingsState,
                    );

                    return FabButton(
                      fabState: fabState,
                      currentWizardStage: wizardState.wizardStage,
                      onesignalAccepted: wizardState.onesignalAccepted,
                    );
                  }
                }
                return const SizedBox(height: 0, width: 0);
              },
            );
          },
        ),
        body: Stack(
          children: [
            Swiper(
              controller: _swiperController,
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              pagination: SwiperCustomPagination(
                builder: (context, config) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: const DotSwiperPaginationBuilder(
                        color: TautulliColorPalette.smoke,
                        activeColor: PlexColorPalette.gamboge,
                      ).build(context, config),
                    ),
                  );
                },
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Servers();
                } else if (index == 1) {
                  return const OneSignal();
                } else if (index == 2) {
                  return const Closing();
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: Text(
                      'No Content',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
            BlocBuilder<WizardBloc, WizardState>(
              builder: (context, state) {
                if (state is WizardLoaded &&
                    state.wizardStage != WizardStage.closing) {
                  return TextButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    child: const Text(
                      LocaleKeys.button_quit,
                    ).tr(),
                  );
                }
                return const SizedBox(height: 0, width: 0);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FabButton extends StatelessWidget {
  final FabState fabState;
  final WizardStage currentWizardStage;
  final bool onesignalAccepted;

  const FabButton({
    Key key,
    @required this.fabState,
    @required this.currentWizardStage,
    @required this.onesignalAccepted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return FloatingActionButton(
          onPressed: fabState == FabState.disabled
              ? null
              : () async {
                  if (fabState == FabState.finish) {
                    if (onesignalAccepted) {
                      await _grantConsentFuture(
                        context.read<OneSignalPrivacyBloc>(),
                      );
                    }

                    context
                        .read<SettingsBloc>()
                        .add(SettingsUpdateWizardCompleteStatus(true));

                    context
                        .read<OneSignalPrivacyBloc>()
                        .add(OneSignalPrivacyCheckConsent());
                    context
                        .read<OneSignalSubscriptionBloc>()
                        .add(OneSignalSubscriptionCheck());

                    await Navigator.of(context).pushNamedAndRemoveUntil(
                      '/activity',
                      (Route<dynamic> route) => false,
                    );
                  } else if (fabState == FabState.skip) {
                    final result = await _showSkipDialog(
                      context,
                      currentWizardStage == WizardStage.oneSignal
                          ? LocaleKeys.wizard_skip_dialog_message_privacy.tr()
                          : currentWizardStage == WizardStage.servers
                              ? LocaleKeys.wizard_skip_dialog_message_servers
                                  .tr()
                              : LocaleKeys.general_unknown_error.tr(),
                    );
                    if (result) {
                      context.read<WizardBloc>().add(
                            WizardUpdateStage(currentWizardStage),
                          );
                      return _swiperController.next();
                    }
                  } else {
                    context.read<WizardBloc>().add(
                          WizardUpdateStage(currentWizardStage),
                        );
                    return _swiperController.next();
                  }
                },
          backgroundColor: fabState == FabState.disabled
              ? Colors.grey[700]
              : Theme.of(context).accentColor,
          child: FaIcon(
            fabState == FabState.skip
                ? FontAwesomeIcons.forward
                : fabState == FabState.finish
                    ? FontAwesomeIcons.check
                    : FontAwesomeIcons.arrowRight,
            color: fabState == FabState.disabled
                ? Colors.grey
                : TautulliColorPalette.not_white,
          ),
          // ),
        );
      },
    );
  }
}

FabState _determineFabState({
  @required WizardStage currentWizardStage,
  @required bool onesignalAccepted,
  // @required bool onesignalPermissionRejected,
  @required SettingsState settingsState,
}) {
  if (currentWizardStage == WizardStage.servers) {
    if (settingsState is SettingsLoadSuccess &&
        settingsState.serverList.isNotEmpty) {
      return FabState.enabled;
    }
    return FabState.disabled;
  }
  if (currentWizardStage == WizardStage.oneSignal) {
    if (onesignalAccepted) {
      return FabState.enabled;
    }
    // if (onesignalPermissionRejected) {
    //   return FabState.enabled;
    // }
    return FabState.skip;
  }
  if (currentWizardStage == WizardStage.closing) {
    return FabState.finish;
  }
  return FabState.disabled;
}

Future<bool> _showQuitDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text(LocaleKeys.wizard_quit_dialog_title).tr(),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_cancel).tr(),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text(LocaleKeys.button_quit).tr(),
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).errorColor,
            ),
            onPressed: () {
              context
                  .read<SettingsBloc>()
                  .add(SettingsUpdateWizardCompleteStatus(true));

              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Future<bool> _showSkipDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text(LocaleKeys.wizard_skip_dialog_title).tr(),
        content: Text(
          message,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_cancel).tr(),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text(LocaleKeys.button_skip).tr(),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _grantConsentFuture(OneSignalPrivacyBloc oneSignalPrivacyBloc) {
  oneSignalPrivacyBloc.add(OneSignalPrivacyGrantConsent());
  return Future.value(null);
}
