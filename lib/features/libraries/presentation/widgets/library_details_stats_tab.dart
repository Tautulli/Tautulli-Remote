import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/time_helper.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/status_card.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/data/models/user_table_model.dart';
import '../../../users/presentation/widgets/user_card.dart';
import '../../../users/presentation/widgets/user_details.dart';
import '../../data/models/library_table_model.dart';
import '../../data/models/library_watch_time_stat_model.dart';
import '../bloc/library_statistics_bloc.dart';

class LibraryDetailsStatsTab extends StatefulWidget {
  final ServerModel server;
  final LibraryTableModel libraryTableModel;

  const LibraryDetailsStatsTab({
    super.key,
    required this.server,
    required this.libraryTableModel,
  });

  @override
  State<LibraryDetailsStatsTab> createState() => _LibraryDetailsStatsTabState();
}

class _LibraryDetailsStatsTabState extends State<LibraryDetailsStatsTab> {
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryStatisticsBloc, LibraryStatisticsState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () {
            context.read<LibraryStatisticsBloc>().add(
                  LibraryStatisticsFetched(
                    server: widget.server,
                    sectionId: widget.libraryTableModel.sectionId!,
                    settingsBloc: _settingsBloc,
                    freshFetch: true,
                  ),
                );

            return Future.value();
          },
          child: PageBody(
            loading: state.userStatsStatus == BlocStatus.initial || state.watchTimeStatsStatus == BlocStatus.initial,
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, settingsState) {
                settingsState as SettingsSuccess;

                if (state.watchTimeStatsStatus == BlocStatus.failure && state.userStatsStatus == BlocStatus.failure) {
                  return StatusPage(
                    scrollable: true,
                    message: state.message ?? 'Unknown failure.',
                    suggestion: state.suggestion,
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: _buildLibraryStatList(
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

  List<Widget> _buildLibraryStatList({
    required LibraryStatisticsState state,
    required bool sensitive,
  }) {
    List<Widget> statList = [];

    if (state.watchTimeStatsStatus != BlocStatus.initial || (state.watchTimeStatsStatus == BlocStatus.initial && state.watchTimeStatsList.isNotEmpty)) {
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
                  Text(
                    _determineWatchTimeStatTitle(watchTimeStat),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
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

    if (state.userStatsStatus != BlocStatus.initial || (state.userStatsStatus == BlocStatus.initial && state.userStatsList.isNotEmpty)) {
      statList.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          child: const Text(
            LocaleKeys.user_stats_title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ).tr(),
        ),
      );

      if (state.userStatsStatus == BlocStatus.failure) {
        statList.add(
          StatusCard(
            isFailure: true,
            message: state.message ?? LocaleKeys.error_message_generic.tr(),
            suggestion: state.suggestion,
          ),
        );
      } else {
        if (state.userStatsList.isEmpty) {
          statList.addAll(
            [
              StatusCard(message: LocaleKeys.user_stats_empty_message.tr()),
              const Gap(8),
            ],
          );
        } else {
          for (int i = 0; i < state.userStatsList.length; i++) {
            final userStat = state.userStatsList[i];

            final user = UserTableModel(
              friendlyName: userStat.friendlyName,
              plays: userStat.totalPlays,
              duration: userStat.totalTime,
              userId: userStat.userId,
              userThumb: userStat.userThumb,
              username: userStat.username,
            );

            statList.add(
              UserCard(
                server: widget.server,
                fetchUser: true,
                user: user,
                details: UserDetails(
                  user: user,
                  showLastStreamed: false,
                ),
              ),
            );

            if (i < state.userStatsList.length - 1) {
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

String _determineWatchTimeStatTitle(LibraryWatchTimeStatModel watchTimeStat) {
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
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
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
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        const TextSpan(text: ' '),
        if (durationMap['day']! > 0) _timeTextSpan(text: '${durationMap['day'].toString()} ${LocaleKeys.days.tr()} '),
        if (durationMap['hour']! > 0) _timeTextSpan(text: '${durationMap['hour'].toString()} ${LocaleKeys.hrs.tr()} '),
        if (durationMap['min']! > 0) _timeTextSpan(text: '${durationMap['min'].toString()} ${LocaleKeys.mins.tr()}'),
        if (durationMap['day']! < 1 && durationMap['hour']! < 1 && durationMap['min']! < 1 && durationMap['sec']! > 0)
          _timeTextSpan(text: '${durationMap['sec'].toString()} ${LocaleKeys.secs.tr()}'),
        if (durationMap['day']! < 1 && durationMap['hour']! < 1 && durationMap['min']! < 1 && durationMap['sec']! < 1)
          _timeTextSpan(text: '0 ${LocaleKeys.min.tr()}'),
      ],
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );
}

TextSpan _timeTextSpan({required String text}) {
  return TextSpan(
    text: text,
    style: const TextStyle(
      fontWeight: FontWeight.w300,
    ),
  );
}
