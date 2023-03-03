import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/asset_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/time_helper.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/status_card.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_watch_time_stat_model.dart';
import '../bloc/user_statistics_bloc.dart';

class UserDetailsStatsTab extends StatefulWidget {
  final ServerModel server;
  final UserModel user;

  const UserDetailsStatsTab({
    super.key,
    required this.server,
    required this.user,
  });

  @override
  State<UserDetailsStatsTab> createState() => _UserDetailsStatsTabState();
}

class _UserDetailsStatsTabState extends State<UserDetailsStatsTab> {
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () {
            context.read<UserStatisticsBloc>().add(
                  UserStatisticsFetched(
                    tautulliId: widget.server.tautulliId,
                    userId: widget.user.userId!,
                    settingsBloc: _settingsBloc,
                    freshFetch: true,
                  ),
                );

            return Future.value();
          },
          child: PageBody(
            loading: state.playerStatsStatus == BlocStatus.initial || state.watchTimeStatsStatus == BlocStatus.initial,
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                settingsState as SettingsSuccess;

                if (state.watchTimeStatsStatus == BlocStatus.failure && state.playerStatsStatus == BlocStatus.failure) {
                  return StatusPage(
                    scrollable: true,
                    message: state.message ?? 'Unknown failure.',
                    suggestion: state.suggestion,
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: _buildUserStatList(
                    context: context,
                    state: state,
                    sensitive: settingsState.appSettings.maskSensitiveInfo,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
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
        StatusCard(
          isFailure: true,
          message: state.message ?? LocaleKeys.error_message_generic.tr(),
          suggestion: state.suggestion,
        ),
      );
    } else {
      for (int i = 0; i < state.watchTimeStatsList.length; i++) {
        final watchTimeStat = state.watchTimeStatsList[i];

        statList.add(
          IconCard(
            icon: watchTimeStat.queryDays == 1
                ? const FaIcon(
                    FontAwesomeIcons.solidClock,
                    size: 45,
                  )
                : watchTimeStat.queryDays == 7
                    ? const FaIcon(
                        FontAwesomeIcons.calendarWeek,
                        size: 50,
                      )
                    : watchTimeStat.queryDays == 30
                        ? const FaIcon(
                            FontAwesomeIcons.solidCalendarDays,
                            size: 50,
                          )
                        : const FaIcon(
                            FontAwesomeIcons.hourglass,
                            size: 50,
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
                _playsRichText(totalPlays: watchTimeStat.totalPlays ?? 0),
                _timeRichText(totalTime: watchTimeStat.totalTime ?? 0),
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
        StatusCard(
          isFailure: true,
          message: state.message ?? LocaleKeys.error_message_generic.tr(),
          suggestion: state.suggestion,
        ),
      );
    } else {
      if (state.playerStatsList.isEmpty) {
        statList.addAll(
          [
            StatusCard(message: LocaleKeys.player_stats_empty_message.tr()),
            const Gap(8),
          ],
        );
      } else {
        for (int i = 0; i < state.playerStatsList.length; i++) {
          final playerStat = state.playerStatsList[i];

          statList.add(
            IconCard(
              background: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
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
                    sensitive ? LocaleKeys.hidden_message.tr() : playerStat.playerName!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  _playsRichText(totalPlays: playerStat.totalPlays ?? 0),
                  _timeRichText(totalTime: playerStat.totalTime ?? 0),
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
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.grey[200],
          ),
        ),
      ],
    ),
  );
}

RichText _timeRichText({
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
          style: const TextStyle(
            fontSize: 15,
          ),
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

TextSpan _timeTextSpan(String text) {
  return TextSpan(
    text: text,
    style: TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.grey[200],
    ),
  );
}
