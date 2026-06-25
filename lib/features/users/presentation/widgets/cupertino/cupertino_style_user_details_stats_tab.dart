import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_icon_card.dart';
import '../base/stat_plays_rich_text.dart';
import '../base/stat_time_rich_text.dart';
import '../base/watch_time_stat_title_text.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_status_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../bloc/user_statistics_bloc.dart';

class CupertinoStyleUserDetailsStatsTab extends StatefulWidget {
  final ServerModel server;
  final UserModel user;

  const CupertinoStyleUserDetailsStatsTab({
    super.key,
    required this.server,
    required this.user,
  });

  @override
  State<CupertinoStyleUserDetailsStatsTab> createState() => _CupertinoStyleUserDetailsStatsTabState();
}

class _CupertinoStyleUserDetailsStatsTabState extends State<CupertinoStyleUserDetailsStatsTab> {
  final ScrollController _scrollController = ScrollController();
  Completer<void> _refreshCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    if (!_refreshCompleter.isCompleted) _refreshCompleter.complete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: _scrollController,
      child: CupertinoStyleRefreshPage(
        scrollController: _scrollController,
        onRefresh: () {
          context.read<UserStatisticsBloc>().add(
            UserStatisticsFetched(
              server: widget.server,
              userId: widget.user.userId!,
              freshFetch: true,
            ),
          );

          return _refreshCompleter.future;
        },
        sliver: BlocConsumer<UserStatisticsBloc, UserStatisticsState>(
          listener: (context, state) {
            if (state.watchTimeStatsStatus != BlocStatus.initial && state.playerStatsStatus != BlocStatus.initial) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            return SliverPadding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
              sliver: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  settingsState as SettingsSuccess;

                  if ((state.watchTimeStatsStatus == BlocStatus.initial && state.watchTimeStatsList.isEmpty) ||
                      (state.playerStatsStatus == BlocStatus.initial && state.playerStatsList.isEmpty)) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  }

                  if (state.watchTimeStatsStatus == BlocStatus.failure &&
                      state.playerStatsStatus == BlocStatus.failure) {
                    return SliverFillRemaining(
                      child: CupertinoStyleStatusPage(
                        message: state.message ?? 'Unknown failure.',
                        suggestion: state.suggestion,
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildListDelegate(
                      _buildUserStatList(
                        context: context,
                        state: state,
                        sensitive: settingsState.appSettings.maskSensitiveInfo,
                      ),
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

  List<Widget> _buildUserStatList({
    required BuildContext context,
    required UserStatisticsState state,
    required bool sensitive,
  }) {
    List<Widget> statList = [];

    if (state.watchTimeStatsStatus != BlocStatus.initial ||
        (state.watchTimeStatsStatus == BlocStatus.initial && state.watchTimeStatsList.isNotEmpty)) {
      statList.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 8, 8),
          child: const Text(
            LocaleKeys.global_stats_title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ).tr(),
        ),
      );

      if (state.watchTimeStatsStatus == BlocStatus.failure) {
        statList.add(
          CupertinoStyleStatusCard(
            isFailure: true,
            message: state.message ?? LocaleKeys.error_message_generic.tr(),
            suggestion: state.suggestion,
          ),
        );
      } else {
        for (int i = 0; i < state.watchTimeStatsList.length; i++) {
          final watchTimeStat = state.watchTimeStatsList[i];

          statList.add(
            CupertinoStyleIconCard(
              icon: watchTimeStat.queryDays == 1
                  ? const Icon(
                      CupertinoIcons.clock_fill,
                      size: 55,
                      color: ThemeHelper.cupertinoCardIconColor,
                    )
                  : watchTimeStat.queryDays == 7
                  ? const Icon(
                      CupertinoIcons.calendar_today,
                      size: 55,
                      color: ThemeHelper.cupertinoCardIconColor,
                    )
                  : watchTimeStat.queryDays == 30
                  ? const Icon(
                      CupertinoIcons.calendar,
                      size: 55,
                      color: ThemeHelper.cupertinoCardIconColor,
                    )
                  : const Icon(
                      CupertinoIcons.hourglass,
                      size: 55,
                      color: ThemeHelper.cupertinoCardIconColor,
                    ),
              details: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WatchTimeStatTitleText(watchTimeStat: watchTimeStat),
                  StatPlaysRichText(
                    totalPlays: watchTimeStat.totalPlays ?? 0,
                  ),
                  StatTimeRichText(
                    totalTime: watchTimeStat.totalTime ?? 0,
                  ),
                ],
              ),
            ),
          );

          if (i < state.watchTimeStatsList.length - 1) {
            statList.add(
              const Gap(8),
            );
          }
        }
      }
    }

    if (state.playerStatsStatus != BlocStatus.initial ||
        (state.playerStatsStatus == BlocStatus.initial && state.playerStatsList.isNotEmpty)) {
      statList.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          child: const Text(
            LocaleKeys.player_stats_title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ).tr(),
        ),
      );

      if (state.playerStatsStatus == BlocStatus.failure) {
        statList.add(
          CupertinoStyleStatusCard(
            isFailure: true,
            message: state.message ?? LocaleKeys.error_message_generic.tr(),
            suggestion: state.suggestion,
          ),
        );
      } else {
        if (state.playerStatsList.isEmpty) {
          statList.addAll(
            [
              CupertinoStyleStatusCard(message: LocaleKeys.player_stats_empty_message.tr()),
              const Gap(8),
            ],
          );
        } else {
          for (int i = 0; i < state.playerStatsList.length; i++) {
            final playerStat = state.playerStatsList[i];

            statList.add(
              CupertinoStyleIconCard(
                background: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    color: CupertinoColors.black.withValues(alpha: 0.6),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: TautulliColorPalette.mapPlatformToColor(
                        playerStat.platformName!,
                      ),
                    ),
                  ),
                ),
                icon: SvgPicture.asset(
                  AssetHelper.mapPlatformToPath(playerStat.platformName!),
                ),
                details: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerStat.playerName!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ).sensitive(),
                    StatPlaysRichText(
                      totalPlays: playerStat.totalPlays ?? 0,
                    ),
                    StatTimeRichText(
                      totalTime: playerStat.totalTime ?? 0,
                    ),
                  ],
                ),
              ),
            );

            if (i < state.playerStatsList.length - 1) {
              statList.add(
                const Gap(8),
              );
            }
          }
        }
      }
    }

    return statList;
  }

}
