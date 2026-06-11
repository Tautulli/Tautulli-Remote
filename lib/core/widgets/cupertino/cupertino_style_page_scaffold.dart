import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../helpers/quick_actions_helper.dart';
import '../../helpers/theme_helper.dart';
import '../../overrides/cupertino/nav_bar_override.dart' as nav;
import 'dialogs/cupertino_style_navigation_bar_back_button.dart';
import 'bottom_sheets/cupertino_style_server_select_bottom_sheet.dart';

class CupertinoStylePageScaffold extends StatefulWidget {
  final bool showServerSelect;
  final bool loading;
  final bool showBackButton;
  final String? previousPageTitle;
  final Widget? leading;
  final Widget middle;
  final Widget? trailing;
  final Widget child;

  const CupertinoStylePageScaffold({
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
  State<CupertinoStylePageScaffold> createState() => _CupertinoStylePageScaffoldState();
}

class _CupertinoStylePageScaffoldState extends State<CupertinoStylePageScaffold> {
  final QuickActions quickActions = const QuickActions();

  @override
  void initState() {
    super.initState();
    initalizeQuickActionsCupertino(quickActions);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: nav.CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(end: 16),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showBackButton)
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  state as SettingsSuccess;

                  return CupertinoStyleNavigationBarBackButton(
                    previousPageTitle: state.serverList.length > 1 && widget.showServerSelect
                        ? null
                        : widget.previousPageTitle,
                  );
                },
              ),
            if (widget.showServerSelect)
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsSuccess && state.serverList.length > 1) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.only(
                            left: widget.showBackButton ? 0 : 16,
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
                          onPressed: () => showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoStyleServerSelectBottomSheet(
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
            if (widget.loading) const CupertinoActivityIndicator(),
            if (widget.showBackButton == false) ?widget.leading,
          ],
        ),
        middle: widget.middle,
        trailing: widget.trailing,
      ),
      child: SafeArea(
        child: widget.child,
      ),
    );
  }
}
