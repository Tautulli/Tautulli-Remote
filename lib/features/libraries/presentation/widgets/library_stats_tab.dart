import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/user_card.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../users/domain/entities/user_table.dart';
import '../../domain/entities/library_statistic.dart';
import '../bloc/library_statistics_bloc.dart';
import 'library_statistic_heading.dart';
import 'library_stats_details.dart';

class LibraryStatsTab extends StatelessWidget {
  final int sectionId;

  const LibraryStatsTab({
    Key key,
    @required this.sectionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LibraryStatisticsBloc>(),
      child: LibraryStatsTabContent(
        sectionId: sectionId,
      ),
    );
  }
}

class LibraryStatsTabContent extends StatefulWidget {
  final int sectionId;

  LibraryStatsTabContent({
    Key key,
    @required this.sectionId,
  }) : super(key: key);

  @override
  _LibraryStatsTabContentState createState() => _LibraryStatsTabContentState();
}

class _LibraryStatsTabContentState extends State<LibraryStatsTabContent> {
  SettingsBloc _settingsBloc;
  LibraryStatisticsBloc _libraryStatisticsBloc;
  String _tautulliId;
  bool _maskSensitiveInfo;

  @override
  void initState() {
    super.initState();
    _settingsBloc = context.read<SettingsBloc>();
    _libraryStatisticsBloc = context.read<LibraryStatisticsBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      _maskSensitiveInfo = settingsState.maskSensitiveInfo;

      if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;
            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingsState.serverList.isNotEmpty) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
        });
      } else {
        _tautulliId = null;
      }

      _libraryStatisticsBloc.add(
        LibraryStatisticsFetch(
          tautulliId: _tautulliId,
          sectionId: widget.sectionId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryStatisticsBloc, LibraryStatisticsState>(
      builder: (context, state) {
        if (state is LibraryStatisticsSuccess) {
          if (state.userStatsList.isNotEmpty ||
              state.watchTimeStatsList.isNotEmpty) {
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Scrollbar(
                child: ListView(
                  children: _buildUserStatList(
                    userStatList: state.userStatsList,
                    watchTimeStatList: state.watchTimeStatsList,
                    maskSensitiveInfo: _maskSensitiveInfo,
                  ),
                ),
              ),
            );
          }
          return Center(
            child: const Text(LocaleKeys.statistics_empty).tr(),
          );
        }
        if (state is LibraryStatisticsFailure) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ErrorMessage(
                failure: state.failure,
                message: state.message,
                suggestion: state.suggestion,
              ),
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).accentColor,
          ),
        );
      },
    );
  }
}

List<Widget> _buildUserStatList({
  @required List<LibraryStatistic> watchTimeStatList,
  @required List<LibraryStatistic> userStatList,
  @required bool maskSensitiveInfo,
}) {
  List<Widget> finalList = [];

  if (watchTimeStatList.isNotEmpty) {
    finalList.add(
      LibraryStatisticHeading(
        heading: LocaleKeys.libraries_details_global_stats_heading.tr(),
      ),
    );

    for (LibraryStatistic stat in watchTimeStatList) {
      finalList.add(
        IconCard(
          icon: const FaIcon(
            FontAwesomeIcons.chartLine,
            size: 50,
          ),
          backgroundColor: PlexColorPalette.raven,
          details: LibraryStatsDetails(
            statistic: stat,
            maskSensitiveInfo: maskSensitiveInfo,
          ),
        ),
      );
    }
  }

  if (userStatList.isNotEmpty) {
    finalList.add(
      LibraryStatisticHeading(
        heading: LocaleKeys.libraries_details_user_stats_heading.tr(),
      ),
    );

    for (LibraryStatistic stat in userStatList) {
      final UserTable user = UserTable(
        friendlyName: stat.friendlyName,
        userId: stat.userId,
        userThumb: stat.userThumb,
        plays: stat.totalPlays,
      );

      finalList.add(
        UserCard(
          user: user,
          details: LibraryStatsDetails(
            statistic: stat,
            maskSensitiveInfo: maskSensitiveInfo,
          ),
          maskSensitiveInfo: maskSensitiveInfo,
          heroTag: UniqueKey(),
        ),
      );
    }
  }

  return finalList;
}
