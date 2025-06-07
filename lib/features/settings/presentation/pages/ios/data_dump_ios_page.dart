import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:system_theme/system_theme.dart';

import '../../../../../core/device_info/device_info.dart';
import '../../../../../core/package_information/package_information.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../../../onesignal/presentation/bloc/onesignal_status_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../widgets/ios/data_dump_ios_warning_card.dart';

class DataDumpIosPage extends StatelessWidget {
  const DataDumpIosPage({super.key});

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
      child: const DataDumpIosView(),
    );
  }
}

class DataDumpIosView extends StatelessWidget {
  const DataDumpIosView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      middle: const Text(LocaleKeys.data_dump_title).tr(),
      leading: CupertinoNavigationBarBackButton(
        //TODO: Eventually remove workaround for https://github.com/flutter/flutter/issues/89888
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: ListView(
        children: [
          DataDumpIosWarningCard(),
          _DeviceDetails(),
          _AppDetails(),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return _AppSettings(
                settingsState: state as SettingsSuccess,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsDumpGroup extends StatelessWidget {
  final String headerText;
  final List<Widget>? children;

  const _SettingsDumpGroup({
    required this.headerText,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCupertinoListSection(
      headerText: headerText,
      children: children,
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
        CupertinoListTile.notched(
          title: const Text('Aspect Ratio'),
          trailing: Text(mediaQuery.size.aspectRatio.toString()),
        ),
        CupertinoListTile.notched(
          title: const Text('Longest Side'),
          trailing: Text(mediaQuery.size.longestSide.toString()),
        ),
        CupertinoListTile.notched(
          title: const Text('Name'),
          trailing: FutureBuilder(
            future: di.sl<DeviceInfo>().model,
            builder: (context, snapshot) {
              return Text(snapshot.data.toString());
            },
          ),
        ),
        CupertinoListTile.notched(
          title: const Text('Orientation'),
          trailing: Text(mediaQuery.orientation.toString()),
        ),
        CupertinoListTile.notched(
          title: const Text('Platform'),
          trailing: Text(di.sl<DeviceInfo>().platform),
        ),
        CupertinoListTile.notched(
          title: const Text('Shortest Side'),
          trailing: Text(mediaQuery.size.shortestSide.toString()),
        ),
        CupertinoListTile.notched(
          title: const Text('Text Scale Factor'),
          trailing: Text(mediaQuery.textScaler.scale(1).toString()),
        ),
        CupertinoListTile.notched(
          title: const Text('Unique ID'),
          trailing: Expanded(
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
        ),
        CupertinoListTile.notched(
          title: const Text('Version'),
          trailing: FutureBuilder(
            future: di.sl<DeviceInfo>().version,
            builder: (context, snapshot) {
              return Text(snapshot.data.toString());
            },
          ),
        ),
        CupertinoListTile.notched(
          title: const Text('System Accent'),
          trailing: Text(
            defaultTargetPlatform.supportsAccentColor ? SystemTheme.accentColor.accent.toHexString().substring(2, 8) : 'Unsupported',
          ),
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
      headerText: 'App Settings',
      children: [
        CupertinoListTile.notched(
          title: const Text('Version'),
          trailing: FutureBuilder(
            future: PackageInformationImpl().version,
            builder: (context, snapshot) {
              return Text(snapshot.data.toString());
            },
          ),
        ),
        CupertinoListTile.notched(
          title: const Text('Build Number'),
          trailing: FutureBuilder(
            future: PackageInformationImpl().buildNumber,
            builder: (context, snapshot) {
              return Text(snapshot.data.toString());
            },
          ),
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
            (e) => CupertinoListTile.notched(
              title: Text(e.key),
              trailing: Expanded(
                child: Text(
                  e.value,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
