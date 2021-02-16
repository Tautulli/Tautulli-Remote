import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/string_mapper_helper.dart';
import '../bloc/statistics_bloc.dart';
import '../pages/single_statistic_type_page.dart';

class StatisticsHeading extends StatelessWidget {
  final String statId;
  final int statisticCount;
  final String tautulliId;
  final bool maskSensitiveInfo;

  const StatisticsHeading({
    Key key,
    @required this.statId,
    @required this.statisticCount,
    @required this.tautulliId,
    @required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StatisticsBloc _statisticsBloc = context.read<StatisticsBloc>();

    return InkWell(
      onTap: statisticCount > 5
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider<StatisticsBloc>.value(
                      value: _statisticsBloc,
                      child: SingleStatisticTypePage(
                        statId: statId,
                        tautulliId: tautulliId,
                        maskSensitiveInfo: maskSensitiveInfo,
                      ),
                    );
                  },
                ),
              );
            }
          : () {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: PlexColorPalette.shark,
                  content: Text('No additional items for this statistic'),
                ),
              );
            },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          top: 6,
          bottom: 6,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                StringMapperHelper.mapStatIdToTitle(statId),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (statisticCount > 5)
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: FaIcon(
                  FontAwesomeIcons.angleRight,
                  color: TautulliColorPalette.not_white,
                  size: 21,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
