import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_icon_card.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_refresh_page.dart';
import '../../../../../core/widgets/cupertino/cupertino_style_status_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/user_watch_time_stat_model.dart';
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
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _settingsBloc = context.read<SettingsBloc>();
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
              settingsBloc: _settingsBloc,
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
                  ? Icon(
                      CupertinoIcons.clock_fill,
                      size: 55,
                      color: ThemeHelper.cupertinoCardIconColor(),
                    )
                  : watchTimeStat.queryDays == 7
                  ? Icon(
                      CupertinoIcons.calendar_today,
                      size: 55,
                      color: ThemeHelper.cupertinoCardIconColor(),
                    )
                  : watchTimeStat.queryDays == 30
                  ? Icon(
                      CupertinoIcons.calendar,
                      size: 55,
                      color: ThemeHelper.cupertinoCardIconColor(),
                    )
                  : Icon(
                      CupertinoIcons.hourglass,
                      size: 55,
                      color: ThemeHelper.cupertinoCardIconColor(),
                    ),
              details: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _determineWatchTimeStatTitle(watchTimeStat),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  _playsRichText(
                    context: context,
                    totalPlays: watchTimeStat.totalPlays ?? 0,
                  ),
                  _timeRichText(
                    context: context,
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
                icon: WebsafeSvg.asset(
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
                    _playsRichText(
                      context: context,
                      totalPlays: playerStat.totalPlays ?? 0,
                    ),
                    _timeRichText(
                      context: context,
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

  String _determineWatchTimeStatTitle(UserWatchTimeStatModel watchTimeStat) {
    if (watchTimeStat.queryDays == 0) {
      return LocaleKeys.all_time_title.tr();
    } else if (watchTimeStat.queryDays == 1) {
      return '24 ${LocaleKeys.hours_title.tr()}';
    } else {
      return '${watchTimeStat.queryDays} ${LocaleKeys.days_title.tr()}';
    }
  }

  RichText _playsRichText({
    required BuildContext context,
    required int totalPlays,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: LocaleKeys.plays_title.tr(),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: totalPlays.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  RichText _timeRichText({
    required BuildContext context,
    required int totalTime,
  }) {
    final durationMap = TimeHelper.durationMap(
      Duration(seconds: totalTime),
    );

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: LocaleKeys.time_title.tr(),
            style: const TextStyle(fontSize: 15),
          ),
          const TextSpan(text: ' '),
          if (durationMap['day']! > 0)
            _timeTextSpan(
              '${durationMap['day'].toString()} ${LocaleKeys.days.tr()} ',
            ),
          if (durationMap['hour']! > 0)
            _timeTextSpan(
              '${durationMap['hour'].toString()} ${LocaleKeys.hrs.tr()} ',
            ),
          if (durationMap['min']! > 0)
            _timeTextSpan(
              '${durationMap['min'].toString()} ${LocaleKeys.mins.tr()}',
            ),
          if (durationMap['day']! < 1 && durationMap['hour']! < 1 && durationMap['min']! < 1 && durationMap['sec']! > 0)
            _timeTextSpan(
              '${durationMap['sec'].toString()} ${LocaleKeys.secs.tr()}',
            ),
          if (durationMap['day']! < 1 && durationMap['hour']! < 1 && durationMap['min']! < 1 && durationMap['sec']! < 1)
            _timeTextSpan('0 ${LocaleKeys.min.tr()}'),
        ],
      ),
    );
  }
}

TextSpan _timeTextSpan(String text) {
  return TextSpan(
    text: text,
    style: const TextStyle(
      fontWeight: FontWeight.w300,
    ),
  );
}
