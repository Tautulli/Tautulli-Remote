import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/activity_bloc.dart';
import '../widgets/activity_card.dart';
import '../widgets/server_activity_info_card.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  static const routeName = '/activity';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ActivityBloc>(),
      child: const ActivityView(),
    );
  }
}

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  late ActivityBloc _activityBloc;
  late SettingsBloc _settingsBloc;
  late String _tautulliId;

  @override
  void initState() {
    super.initState();

    _activityBloc = context.read<ActivityBloc>();
    _settingsBloc = context.read<SettingsBloc>();
    final settingsState = _settingsBloc.state as SettingsSuccess;

    _tautulliId = settingsState.appSettings.activeServer.tautulliId;

    _activityBloc.add(
      ActivityFetched(
        tautulliId: _tautulliId,
        settingsBloc: _settingsBloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) {
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          if (previous.appSettings.activeServer != current.appSettings.activeServer) {
            return true;
          }
        }
        return false;
      },
      listener: (context, state) {
        if (state is SettingsSuccess) {
          _tautulliId = state.appSettings.activeServer.tautulliId;

          _activityBloc.add(
            ActivityFetched(
              tautulliId: _tautulliId,
              settingsBloc: _settingsBloc,
            ),
          );
        }
      },
      child: ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.activity_title).tr(),
        body: BlocBuilder<ActivityBloc, ActivityState>(
          builder: (context, state) {
            return ThemedRefreshIndicator(
              onRefresh: () {
                _activityBloc.add(
                  ActivityFetched(
                    tautulliId: _tautulliId,
                    settingsBloc: _settingsBloc,
                    freshFetch: true,
                  ),
                );

                return Future.value();
              },
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  settingsState as SettingsSuccess;

                  return PageBody(
                    loading: state.status == BlocStatus.initial,
                    child: Builder(
                      builder: (context) {
                        final multiserver = settingsState.appSettings.multiserverActivity;

                        // if (multiserver) {
                        //   return Text('Multiserver enabled, not supported yet');
                        // } else {
                        if (state.serverActivityList.isEmpty || state.serverActivityList[0].activityList.isEmpty) {
                          if (state.status == BlocStatus.failure) {
                            return StatusPage(
                              scrollable: true,
                              message: state.message ?? '',
                              suggestion: state.suggestion ?? '',
                            );
                          }
                          if (state.status == BlocStatus.success) {
                            return StatusPage(
                              scrollable: true,
                              message: LocaleKeys.activity_empty_message.tr(),
                            );
                          }
                        }

                        if (state.serverActivityList.isNotEmpty &&
                            state.serverActivityList[0].activityList.isNotEmpty) {
                          return MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(8),
                              itemCount: state.serverActivityList[0].activityList.length + 1,
                              separatorBuilder: (context, index) => const Gap(8),
                              itemBuilder: (context, index) {
                                final serverActivity = state.serverActivityList[0];

                                if (index == 0) {
                                  return ServerActivityInfoCard(serverActivity: serverActivity);
                                }

                                return ActivityCard(
                                  activity: serverActivity.activityList[index - 1],
                                  onTap: null,
                                );
                              },
                            ),
                          );
                        }

                        return const SizedBox();
                        // }
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
