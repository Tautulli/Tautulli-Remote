import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';
import 'server_select_ios_bottom_sheet.dart';

class PageScaffoldCupertino extends StatelessWidget {
  final bool showServerSelect;
  final bool loading;
  final Widget? leading;
  final Widget middle;
  final Widget? trailing;
  final Widget child;

  const PageScaffoldCupertino({
    super.key,
    this.showServerSelect = false,
    this.loading = false,
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
            if (showServerSelect)
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsSuccess && state.serverList.length > 1) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 80),
                                child: Text(
                                  state.appSettings.activeServer.plexName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const Gap(4),
                              const Icon(
                                CupertinoIcons.chevron_down,
                                size: 18,
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
            ?leading,
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
