import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/heading.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../onesignal/presentation/bloc/onesignal_status_bloc.dart';
import '../bloc/settings_bloc.dart';

class DataDumpPage extends StatelessWidget {
  const DataDumpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());

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
        title: const Text('Data Dump'),
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
                        children: const [
                          Text(
                            'WARNING: This page includes sensitive data.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Be cautious when sharing'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(8),
            const _AppSettings(),
            const Gap(8),
            const _OneSignalStatus(),
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
  const _AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsState = context.read<SettingsBloc>().state as SettingsSuccess;

    return _SettingDumpGroup(
      title: 'App Settings',
      widgetList: settingsState.appSettings
          .dump()
          .entries
          .map(
            (e) => _DataDumpRow(
              children: [
                Text(e.key),
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
                const Text('Can Connect to OneSignal'),
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
                      const Text('Notification Permission'),
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
                      const Text('Push Disabled'),
                      const Gap(16),
                      Text(
                        state.state.pushDisabled.toString(),
                      ),
                    ],
                  ),
                  _DataDumpRow(
                    children: [
                      const Text('Subscribed'),
                      const Gap(16),
                      Text(
                        state.state.subscribed.toString(),
                      ),
                    ],
                  ),
                  _DataDumpRow(
                    children: [
                      const Text('User ID'),
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
