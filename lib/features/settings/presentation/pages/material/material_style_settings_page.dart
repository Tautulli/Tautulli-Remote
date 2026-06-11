import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../onesignal/presentation/bloc/onesignal_health_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../widgets/material/material_style_app_update_alert_banner.dart';
import '../../widgets/material/groups/material_style_app_settings_group.dart';
import '../../widgets/material/groups/material_style_help_and_support_group.dart';
import '../../widgets/material/groups/material_style_more_group.dart';
import '../../widgets/material/groups/material_style_servers_group.dart';
import '../../widgets/material/buttons/material_style_register_server_button.dart';
import '../../widgets/material/material_style_settings_alert_banner.dart';

class MaterialStyleSettingsPage extends StatelessWidget {
  const MaterialStyleSettingsPage({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return const MaterialStyleSettingsView();
  }
}

class MaterialStyleSettingsView extends StatefulWidget {
  const MaterialStyleSettingsView({super.key});

  @override
  State<MaterialStyleSettingsView> createState() => _MaterialStyleSettingsViewState();
}

class _MaterialStyleSettingsViewState extends State<MaterialStyleSettingsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<OneSignalHealthBloc>().add(OneSignalHealthCheck());

    return ScaffoldWithInnerDrawer(
      title: const Text(LocaleKeys.settings_title).tr(),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              state as SettingsSuccess;

              if (state.appSettings.appUpdateAvailable) {
                return const MaterialStyleAppUpdateAlertBanner();
              }

              return const SizedBox(height: 0, width: 0);
            },
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsSuccess &&
                  (!state.appSettings.oneSignalBannerDismissed || state.appSettings.oneSignalConsented)) {
                return const MaterialStyleSettingsAlertBanner();
              }

              return const SizedBox(height: 0, width: 0);
            },
          ),
          const MaterialStyleServersGroup(),
          const Gap(8),
          const MaterialStyleRegisterServerButton(),
          const Gap(8),
          const MaterialStyleAppSettingsGroup(),
          const Gap(8),
          const MaterialStyleHelpAndSupportGroup(),
          const Gap(8),
          const MaterialStyleMoreGroup(),
        ],
      ),
    );
  }
}
