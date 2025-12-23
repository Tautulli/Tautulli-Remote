import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../helpers/theme_helper.dart';
import 'custom_cupertino_navigation_bar_back_button.dart';
import 'server_select_ios_bottom_sheet.dart';

class PageScaffoldCupertino extends StatelessWidget {
  final bool showServerSelect;
  final bool loading;
  final bool showBackButton;
  final String? previousPageTitle;
  final Widget? leading;
  final Widget middle;
  final Widget? trailing;
  final Widget child;

  const PageScaffoldCupertino({
    super.key,
    this.showServerSelect = false,
    this.loading = false,
    this.showBackButton = true,
    this.previousPageTitle,
    this.leading,
    required this.middle,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBackButton)
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  state as SettingsSuccess;

                  return CustomCupertinoNavigationBarBackButton(
                    previousPageTitle: state.serverList.length > 1 && showServerSelect ? null : previousPageTitle,
                  );
                },
              ),
            if (showServerSelect)
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsSuccess && state.serverList.length > 1) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.only(
                            left: showBackButton ? 0 : 16,
                            right: 16,
                          ),
                          child: Row(
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 80),
                                child: Text(
                                  state.appSettings.activeServer.plexName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: ThemeHelper.cupertinoNavigationBarItemColor(),
                                  ),
                                ),
                              ),
                              const Gap(4),
                              Icon(
                                CupertinoIcons.chevron_down,
                                size: 18,
                                color: ThemeHelper.cupertinoNavigationBarItemColor(),
                              ),
                            ],
                          ),
                          onPressed: () => showCupertinoSheet(
                            context: context,
                            builder: (context) => ServerSelectIosBottomSheet(
                              activeServer: state.appSettings.activeServer,
                              servers: state.serverList,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return const Gap(8);
                },
              ),
            const Gap(8),
            if (loading) const CupertinoActivityIndicator(),
            if (showBackButton == false) ?leading,
          ],
        ),
        middle: middle,
        trailing: trailing,
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
