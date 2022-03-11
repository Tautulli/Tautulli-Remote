import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/heading.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../announcements/presentation/bloc/announcements_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_status_bloc.dart';
import '../bloc/settings_bloc.dart';

class DataDumpPage extends StatelessWidget {
  const DataDumpPage({Key? key}) : super(key: key);

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
      child: const DataDumpView(),
    );
  }
}

class DataDumpView extends StatelessWidget {
  const DataDumpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.data_dump_title).tr(),
      ),
      body: PageBody(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Card(
              color: Theme.of(context).colorScheme.error,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.exclamationTriangle),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            LocaleKeys.data_dump_warning_line_1,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ).tr(),
                          const Text(LocaleKeys.data_dump_warning_line_2).tr(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(8),
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return _AppSettings(settingsState: state as SettingsSuccess);
              },
            ),
            const Gap(8),
            const _OneSignalStatus(),
            const Gap(8),
            const _AnnouncementsDumpGroup(),
            const Gap(8),
            BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return _ServerDumpGroup(
                  settingsState: state as SettingsSuccess,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingDumpGroup extends StatelessWidget {
  final String title;
  final List<Widget> widgetList;

  const _SettingDumpGroup({
    Key? key,
    required this.title,
    required this.widgetList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Heading(text: title),
        ),
        const Gap(8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widgetList,
            ),
          ),
        ),
      ],
    );
  }
}

class _DataDumpRowHeading extends StatelessWidget {
  final String text;

  const _DataDumpRowHeading(this.text, {Key? key}) : super(key: key);

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
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
        Divider(
          color: Theme.of(context).textTheme.subtitle2!.color,
        ),
      ],
    );
  }
}

class _AppSettings extends StatelessWidget {
  final SettingsSuccess settingsState;

  const _AppSettings({
    Key? key,
    required this.settingsState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SettingDumpGroup(
      title: 'App Settings',
      widgetList: settingsState.appSettings
          .dump()
          .entries
          .map(
            (e) => _DataDumpRow(
              children: [
                _DataDumpRowHeading(e.key),
                const Gap(16),
                Text(e.value),
              ],
            ),
          )
          .toList(),
    );
  }
}

class _OneSignalStatus extends StatelessWidget {
  const _OneSignalStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SettingDumpGroup(
      title: 'OneSignal Status',
      widgetList: [
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
                          state.state.hasNotificationPermission.toString(),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  _DataDumpRow(
                    children: [
                      const _DataDumpRowHeading('Push Disabled'),
                      const Gap(16),
                      Text(
                        state.state.pushDisabled.toString(),
                      ),
                    ],
                  ),
                  _DataDumpRow(
                    children: [
                      const _DataDumpRowHeading('Subscribed'),
                      const Gap(16),
                      Text(
                        state.state.subscribed.toString(),
                      ),
                    ],
                  ),
                  _DataDumpRow(
                    children: [
                      const _DataDumpRowHeading('User ID'),
                      const Gap(16),
                      Expanded(
                        child: Text(
                          state.state.userId ?? '',
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
        )
      ],
    );
  }
}

class _AnnouncementsDumpGroup extends StatelessWidget {
  const _AnnouncementsDumpGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
      builder: (context, state) {
        if (state is AnnouncementsSuccess) {
          return _SettingDumpGroup(
            title: 'Announcements',
            widgetList: [
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
                      (state.announcementList.length -
                              state.filteredList.length)
                          .toString(),
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

class _ServerDumpGroup extends StatelessWidget {
  final SettingsSuccess settingsState;

  const _ServerDumpGroup({
    Key? key,
    required this.settingsState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: settingsState.serverList
          .map(
            (server) => _SettingDumpGroup(
              title: server.plexName,
              widgetList: [
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
                    Text(server.secondaryConnectionProtocol ?? '')
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
