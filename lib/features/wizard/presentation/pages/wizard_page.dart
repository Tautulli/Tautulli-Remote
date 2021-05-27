import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../injection_container.dart' as di;
import '../../../onesignal/presentation/bloc/onesignal_privacy_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_subscription_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/wizard_bloc.dart';
import '../widgets/closing.dart';
import '../widgets/getting_started.dart';
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

class WizardPageContent extends StatelessWidget {
  const WizardPageContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _showQuitDialog(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: BlocBuilder<WizardBloc, WizardState>(
          builder: (context, wizardState) {
            return BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                if (wizardState is WizardLoaded) {
                  if (settingsState is SettingsLoadSuccess) {
                    FabState fabState = _determineFabState(
                      currentWizardStage: currentWizardStage,
                      gettingStartedAccepted:
                          wizardState.gettingStartedAccepted,
                      onesignalAccepted: wizardState.onesignalAccepted,
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
        body: SafeArea(
          child: Swiper(
            controller: _swiperController,
            itemCount: 4,
            // loop: false,
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
                      // size: 10.0,
                      // activeSize: 10.0,
                    ).build(context, config),
                  ),
                );
              },
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const GettingStarted();
              } else if (index == 1) {
                return const Servers();
              } else if (index == 2) {
                return const OneSignal();
              } else if (index == 3) {
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
                          ? 'You will need to consent to the OneSignal data privacy later if you wish to use Tautulli Remote to receive notifications.'
                          : currentWizardStage == WizardStage.servers
                              ? 'You have not yet registered with any Tautulli servers.'
                              : 'UNKNOWN',
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
          backgroundColor:
              [FabState.enabled, FabState.finish].contains(fabState)
                  ? Theme.of(context).accentColor
                  : fabState == FabState.skip
                      ? Theme.of(context).errorColor
                      : Colors.grey[700],
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
  @required bool gettingStartedAccepted,
  @required bool onesignalAccepted,
  @required SettingsState settingsState,
}) {
  if (currentWizardStage == WizardStage.gettingStarted) {
    if (gettingStartedAccepted) {
      return FabState.enabled;
    }
    return FabState.disabled;
  }
  if (currentWizardStage == WizardStage.oneSignal) {
    if (onesignalAccepted) {
      return FabState.enabled;
    }
    return FabState.skip;
  }
  if (currentWizardStage == WizardStage.servers) {
    if (settingsState is SettingsLoadSuccess &&
        settingsState.serverList.isNotEmpty) {
      return FabState.enabled;
    }
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
        title: const Text('Are you sure you want to quit the Setup Wizard?'),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('QUIT'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
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
        title: const Text('Are you sure you want to skip?'),
        content: Text(
          message,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('SKIP'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
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
