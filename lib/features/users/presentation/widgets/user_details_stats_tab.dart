import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/helpers/asset_mapper_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/user_statistic.dart';
import '../../domain/entities/user_table.dart';
import '../bloc/user_statistics_bloc.dart';
import 'user_statistic_heading.dart';
import 'user_stats_details.dart';

class UserDetailsStatsTab extends StatelessWidget {
  final UserTable user;

  const UserDetailsStatsTab({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<UserStatisticsBloc>(),
      child: UserDetailsStatsTabContent(
        user: user,
      ),
    );
  }
}

class UserDetailsStatsTabContent extends StatefulWidget {
  final UserTable user;

  UserDetailsStatsTabContent({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _UserDetailsStatsTabContentState createState() =>
      _UserDetailsStatsTabContentState();
}

class _UserDetailsStatsTabContentState
    extends State<UserDetailsStatsTabContent> {
  SettingsBloc _settingsBloc;
  UserStatisticsBloc _userStatisticsBloc;
  String _tautulliId;
  bool _maskSensitiveInfo;

  @override
  void initState() {
    super.initState();
    _settingsBloc = context.read<SettingsBloc>();
    _userStatisticsBloc = context.read<UserStatisticsBloc>();

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
      } else if (settingsState.serverList.length > 0) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
        });
      } else {
        _tautulliId = null;
      }

      _userStatisticsBloc.add(
        UserStatisticsFetch(
          tautulliId: _tautulliId,
          userId: widget.user.userId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStatisticsBloc, UserStatisticsState>(
      builder: (context, state) {
        if (state is UserStatisticsSuccess) {
          if (state.playerStatsList.isNotEmpty ||
              state.watchTimeStatsList.isNotEmpty) {
            return Container(
              color: Theme.of(context).backgroundColor,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Scrollbar(
                  child: ListView(
                    children: _buildUserStatList(
                      playerStatList: state.playerStatsList,
                      watchTimeStatList: state.watchTimeStatsList,
                      maskSensitiveInfo: _maskSensitiveInfo,
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(
            child: Text('No stats found'),
          );
        }
        if (state is UserStatisticsFailure) {
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
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

List<Widget> _buildUserStatList({
  @required List<UserStatistic> watchTimeStatList,
  @required List<UserStatistic> playerStatList,
  @required bool maskSensitiveInfo,
}) {
  List<Widget> finalList = [];

  if (watchTimeStatList.isNotEmpty) {
    finalList.add(UserStatisticHeading(heading: 'Global Stats'));

    for (UserStatistic stat in watchTimeStatList) {
      finalList.add(
        IconCard(
          icon: FaIcon(
            FontAwesomeIcons.chartLine,
            size: 50,
          ),
          details: UserStatsDetails(
            statistic: stat,
            maskSensitiveInfo: maskSensitiveInfo,
          ),
        ),
      );
    }
  }

  if (playerStatList.isNotEmpty) {
    finalList.add(UserStatisticHeading(heading: 'Player Stats'));

    for (UserStatistic stat in playerStatList) {
      finalList.add(
        IconCard(
          localIconImagePath:
              AssetMapperHelper.mapPlatformToPath(stat.platformName),
          backgroundColor:
              TautulliColorPalette.mapPlatformToColor(stat.platformName),
          iconColor: TautulliColorPalette.not_white,
          details: UserStatsDetails(
              statistic: stat, maskSensitiveInfo: maskSensitiveInfo),
        ),
      );
    }
  }

  return finalList;
}
