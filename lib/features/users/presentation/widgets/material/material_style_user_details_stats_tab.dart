import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/asset_helper.dart';
import '../../../../../core/helpers/color_palette_helper.dart';
import '../../../../../core/pages/material/material_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../core/widgets/material/material_style_icon_card.dart';
import '../base/stat_plays_rich_text.dart';
import '../base/stat_time_rich_text.dart';
import '../base/watch_time_stat_title_text.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../../core/widgets/material/material_style_status_card.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../bloc/user_statistics_bloc.dart';

class MaterialStyleUserDetailsStatsTab extends StatefulWidget {
  final ServerModel server;
  final UserModel user;

  const MaterialStyleUserDetailsStatsTab({
    super.key,
    required this.server,
    required this.user,
  });

  @override
  State<MaterialStyleUserDetailsStatsTab> createState() => _MaterialStyleUserDetailsStatsTabState();
}

class _MaterialStyleUserDetailsStatsTabState extends State<MaterialStyleUserDetailsStatsTab> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
      builder: (context, state) {
        return MaterialStyleRefreshIndicator(
          onRefresh: () {
            context.read<UserStatisticsBloc>().add(
              UserStatisticsFetched(
                server: widget.server,
                userId: widget.user.userId!,
                freshFetch: true,
              ),
            );

            return Future.value();
          },
          child: MaterialStylePageBody(
            loading: state.playerStatsStatus == BlocStatus.initial || state.watchTimeStatsStatus == BlocStatus.initial,
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                settingsState as SettingsSuccess;

                if (state.watchTimeStatsStatus == BlocStatus.failure && state.playerStatsStatus == BlocStatus.failure) {
                  return MaterialStyleStatusPage(
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
        MaterialStyleStatusCard(
          isFailure: true,
          message: state.message ?? LocaleKeys.error_message_generic.tr(),
          suggestion: state.suggestion,
        ),
      );
    } else {
      for (int i = 0; i < state.watchTimeStatsList.length; i++) {
        final watchTimeStat = state.watchTimeStatsList[i];

        statList.add(
          MaterialStyleIconCard(
            icon: watchTimeStat.queryDays == 1
                ? FaIcon(
                    FontAwesomeIcons.solidClock,
                    size: 45,
                    color: Theme.of(context).colorScheme.onSurface,
                  )
                : watchTimeStat.queryDays == 7
                ? FaIcon(
                    FontAwesomeIcons.calendarWeek,
                    size: 50,
                    color: Theme.of(context).colorScheme.onSurface,
                  )
                : watchTimeStat.queryDays == 30
                ? FaIcon(
                    FontAwesomeIcons.solidCalendarDays,
                    size: 50,
                    color: Theme.of(context).colorScheme.onSurface,
                  )
                : FaIcon(
                    FontAwesomeIcons.hourglass,
                    size: 50,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            details: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WatchTimeStatTitleText(watchTimeStat: watchTimeStat),
                StatPlaysRichText(
                  totalPlays: watchTimeStat.totalPlays ?? 0,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
                StatTimeRichText(
                  totalTime: watchTimeStat.totalTime ?? 0,
                  labelColor: Theme.of(context).colorScheme.onSurface,
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
        MaterialStyleStatusCard(
          isFailure: true,
          message: state.message ?? LocaleKeys.error_message_generic.tr(),
          suggestion: state.suggestion,
        ),
      );
    } else {
      if (state.playerStatsList.isEmpty) {
        statList.addAll(
          [
            MaterialStyleStatusCard(message: LocaleKeys.player_stats_empty_message.tr()),
            const Gap(8),
          ],
        );
      } else {
        for (int i = 0; i < state.playerStatsList.length; i++) {
          final playerStat = state.playerStatsList[i];

          statList.add(
            MaterialStyleIconCard(
              background: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
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
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
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
                    textColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  StatTimeRichText(
                    totalTime: playerStat.totalTime ?? 0,
                    labelColor: Theme.of(context).colorScheme.onSurface,
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
