import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:system_theme/system_theme.dart';
import 'package:tautulli_remote/core/widgets/cupertino/cupertino_style_list_section_heading.dart';

import '../../../../../core/device_info/device_info.dart';
import '../../../../../core/package_information/package_information.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_card.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_page_scaffold.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../announcements/presentation/bloc/announcements_bloc.dart';
import '../../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../../onesignal/presentation/bloc/onesignal_status_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../widgets/cupertino/cupertino_style_data_dump_warning_card.dart';

class CupertinoStyleDataDumpPage extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleDataDumpPage({
    super.key,
    this.showBackButton = true,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());
    context.read<SettingsBloc>().add(
      const SettingsLoad(updateServerInfo: false),
    );

    return BlocProvider(
      create: (context) => di.sl<OneSignalStatusBloc>()
        ..add(
          OneSignalStatusLoad(),
        ),
      child: CupertinoStyleDataDumpView(
        showBackButton: showBackButton,
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class CupertinoStyleDataDumpView extends StatelessWidget {
  final bool showBackButton;
  final String? previousPageTitle;

  const CupertinoStyleDataDumpView({
    super.key,
    required this.showBackButton,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStylePageScaffold(
      showBackButton: showBackButton,
      previousPageTitle: previousPageTitle,
      middle: const Text(LocaleKeys.data_dump_title).tr(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          const CupertinoStyleDataDumpWarningCard(),
          const _DeviceDetails(),
          const _AppDetails(),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return _AppSettings(
                settingsState: state as SettingsSuccess,
              );
            },
          ),
          const _OneSignalStatus(),
          const _AnnouncementsGroup(),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return _ServerGroup(settingsState: state as SettingsSuccess);
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsDumpGroup extends StatelessWidget {
  final String headerText;
  final List<Widget> children;

  const _SettingsDumpGroup({
    required this.headerText,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoStyleListSectionHeading(headerText),
        CupertinoStyleListSection(
          margin: EdgeInsets.zero,
          children: [
            CupertinoStyleCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DataDumpRowHeading extends StatelessWidget {
  final String text;

  const _DataDumpRowHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

class _DataDumpRow extends StatelessWidget {
  final List<Widget> children;

  const _DataDumpRow({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 4,
          children: children,
        ),
        const Divider(
          color: CupertinoColors.systemGrey,
        ),
      ],
    );
  }
}

class _DeviceDetails extends StatelessWidget {
  const _DeviceDetails();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return _SettingsDumpGroup(
      headerText: 'Device Details',
      children: [
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Aspect Ratio'),
            const Gap(16),
            Text(mediaQuery.size.aspectRatio.toString()),
          ],
        ),
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Longest Side'),
            const Gap(16),
            Text(mediaQuery.size.longestSide.toString()),
          ],
        ),
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Name'),
            const Gap(16),
            FutureBuilder(
              future: di.sl<DeviceInfo>().model,
              builder: (context, snapshot) {
                return Text(snapshot.data.toString());
              },
            ),
          ],
        ),
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Orientation'),
            const Gap(16),
            Text(mediaQuery.orientation.toString()),
          ],
        ),
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Platform'),
            const Gap(16),
            Text(di.sl<DeviceInfo>().platform),
          ],
        ),
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Shortest Side'),
            const Gap(16),
            Text(mediaQuery.size.shortestSide.toString()),
          ],
        ),
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Text Scale Factor'),
            const Gap(16),
            Text(mediaQuery.textScaler.scale(1).toString()),
          ],
        ),
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Unique ID'),
            const Gap(16),
            Expanded(
              child: FutureBuilder(
                future: di.sl<DeviceInfo>().uniqueId,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data.toString(),
                    textAlign: TextAlign.end,
                  );
                },
              ),
            ),
          ],
        ),
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Version'),
            const Gap(16),
            FutureBuilder(
              future: di.sl<DeviceInfo>().version,
              builder: (context, snapshot) {
                return Text(snapshot.data.toString());
              },
            ),
          ],
        ),
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('System Accent'),
            const Gap(16),
            Text(
              defaultTargetPlatform.supportsAccentColor
                  ? SystemTheme.accentColor.accent.toHexString().substring(2, 8)
                  : 'Unsupported',
              // style: TextStyle(
              //   color: defaultTargetPlatform.supportsAccentColor ? SystemTheme.accentColor.accent : null,
              // ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AppDetails extends StatelessWidget {
  const _AppDetails();

  @override
  Widget build(BuildContext context) {
    return _SettingsDumpGroup(
      headerText: 'App Details',
      children: [
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Version'),
            const Gap(16),
            FutureBuilder(
              future: PackageInformationImpl().version,
              builder: (context, snapshot) {
                return Text(snapshot.data.toString());
              },
            ),
          ],
        ),
        _DataDumpRow(
          children: [
            const _DataDumpRowHeading('Build Number'),
            const Gap(16),
            FutureBuilder(
              future: PackageInformationImpl().buildNumber,
              builder: (context, snapshot) {
                return Text(snapshot.data.toString());
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _AppSettings extends StatelessWidget {
  final SettingsSuccess settingsState;

  const _AppSettings({
    required this.settingsState,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsDumpGroup(
      headerText: 'App Settings',
      children: settingsState.appSettings
          .dump()
          .entries
          .map(
            (e) => _DataDumpRow(
              children: [
                GestureDetector(
                  onLongPress: e.key == 'Patch'
                      ? () async {
                          final shorebirdUpdater = ShorebirdUpdater();
                          final status = await shorebirdUpdater.checkForUpdate();

                          if (di.sl<DeviceInfo>().platform == 'ios' && await di.sl<DeviceInfo>().version < 10) {
                            HapticFeedback.vibrate();
                          } else {
                            HapticFeedback.heavyImpact();
                          }

                          if (status == UpdateStatus.outdated) {
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_LONG,
                              msg: 'Patch available, please wait...',
                            );

                            await shorebirdUpdater.update();

                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_LONG,
                              msg: 'Patch downloaded, restart app to apply',
                            );
                          } else {
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              msg: 'No patch available',
                            );
                          }
                        }
                      : null,
                  child: _DataDumpRowHeading(e.key),
                ),
                const Gap(16),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Builder(
                      builder: (context) {
                        if (e.key == 'Theme Custom Color') {
                          return Text(
                            settingsState.appSettings.themeCustomColor.toHexString().substring(2, 8),
                            style: TextStyle(color: settingsState.appSettings.themeCustomColor),
                          );
                        }

                        return Text(e.value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _OneSignalStatus extends StatelessWidget {
  const _OneSignalStatus();

  @override
  Widget build(BuildContext context) {
    return _SettingsDumpGroup(
      headerText: 'OneSignal Status',
      children: [
        BlocBuilder<OneSignalHealthBloc, OneSignalHealthState>(
          builder: (context, state) {
            return _DataDumpRow(
              children: [
                const _DataDumpRowHeading('Can Connect to OneSignal'),
                const Gap(16),
                if (state is OneSignalHealthSuccess) const Text('true'),
                if (state is OneSignalHealthFailure) const Text('false'),
                if (state is OneSignalHealthInProgress) const Text('checking'),
              ],
            );
          },
        ),
        BlocBuilder<OneSignalStatusBloc, OneSignalStatusState>(
          builder: (context, state) {
            if (state is OneSignalStatusFailure) {
              return const Center(
                child: Text('Error Loading OneSignal Status'),
              );
            }
            if (state is OneSignalStatusSuccess) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DataDumpRow(
                    children: [
                      const _DataDumpRowHeading('Notification Permission'),
                      const Gap(16),
                      Expanded(
                        child: Text(
                          state.hasNotificationPermission.toString(),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  _DataDumpRow(
                    children: [
                      const _DataDumpRowHeading('Opted In'),
                      const Gap(16),
                      Text(
                        state.isOptedIn.toString(),
                      ),
                    ],
                  ),
                  _DataDumpRow(
                    children: [
                      const _DataDumpRowHeading('Subscribed'),
                      const Gap(16),
                      Text(
                        state.isSubscribed.toString(),
                      ),
                    ],
                  ),
                  _DataDumpRow(
                    children: [
                      const _DataDumpRowHeading('User ID'),
                      const Gap(16),
                      Expanded(
                        child: Text(
                          state.userId,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            return const Center(
              child: Text('Loading OneSignal Status'),
            );
          },
        ),
      ],
    );
  }
}

class _AnnouncementsGroup extends StatelessWidget {
  const _AnnouncementsGroup();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
      builder: (context, state) {
        if (state is AnnouncementsSuccess) {
          return _SettingsDumpGroup(
            headerText: 'Announcements',
            children: [
              _DataDumpRow(
                children: [
                  const _DataDumpRowHeading('Unread'),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      state.unread.toString(),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              _DataDumpRow(
                children: [
                  const _DataDumpRowHeading('Total'),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      state.announcementList.length.toString(),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              _DataDumpRow(
                children: [
                  const _DataDumpRowHeading('Filtered'),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      (state.announcementList.length - state.filteredList.length).toString(),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              _DataDumpRow(
                children: [
                  const _DataDumpRowHeading('Max ID'),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      state.maxId.toString(),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              _DataDumpRow(
                children: [
                  const _DataDumpRowHeading('Last Read ID'),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      state.lastReadAnnouncementId.toString(),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        if (state is AnnouncementsFailure) {}

        return Container();
      },
    );
  }
}

class _ServerGroup extends StatelessWidget {
  final SettingsSuccess settingsState;

  const _ServerGroup({
    required this.settingsState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: settingsState.serverList
          .map(
            (server) => _SettingsDumpGroup(
              headerText: server.plexName,
              children: [
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('ID'),
                    const Gap(16),
                    Text(server.id.toString()),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Sort Index'),
                    const Gap(16),
                    Text(server.sortIndex.toString()),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Plex Identifier'),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        server.plexIdentifier,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Tautulli ID'),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        server.tautulliId,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Primary Address'),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        server.primaryConnectionAddress,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Primary Protocol'),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        server.primaryConnectionProtocol,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Primary Domain'),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        server.primaryConnectionDomain,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Primary Path'),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        server.primaryConnectionPath ?? '',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Secondary Address'),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        server.secondaryConnectionAddress ?? '',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Secondary Protocol'),
                    const Gap(16),
                    Text(server.secondaryConnectionProtocol ?? ''),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Secondary Domain'),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        server.secondaryConnectionDomain ?? '',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Secondary Path'),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        server.secondaryConnectionPath ?? '',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Device Token'),
                    const Gap(16),
                    Expanded(
                      child: Text(
                        server.deviceToken,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Primary Active'),
                    const Gap(16),
                    Text(server.primaryActive.toString()),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('OneSignal Registered'),
                    const Gap(16),
                    Text(server.oneSignalRegistered.toString()),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Plex Pass'),
                    const Gap(16),
                    Text(server.plexPass.toString()),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Date Format'),
                    const Gap(16),
                    Text(server.dateFormat ?? ''),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Time Format'),
                    const Gap(16),
                    Text(server.timeFormat ?? ''),
                  ],
                ),
                _DataDumpRow(
                  children: [
                    const _DataDumpRowHeading('Custom Headers'),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: server.customHeaders
                            .map(
                              (header) => Text(
                                '{${header.key} : ${header.value}}',
                                textAlign: TextAlign.end,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
