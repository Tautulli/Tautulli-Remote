import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/asset_mapper_helper.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/string_mapper_helper.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/icon_card.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../core/widgets/user_card.dart';
import '../../domain/entities/statistics.dart';
import '../bloc/statistics_bloc.dart';
import '../widgets/statistics_details.dart';

class SingleStatisticTypePage extends StatefulWidget {
  final String statId;
  final String tautulliId;

  const SingleStatisticTypePage({
    Key key,
    @required this.statId,
    @required this.tautulliId,
  }) : super(key: key);

  @override
  _SingleStatisticTypePageState createState() =>
      _SingleStatisticTypePageState();
}

class _SingleStatisticTypePageState extends State<SingleStatisticTypePage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  StatisticsBloc _statisticsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _statisticsBloc = context.bloc<StatisticsBloc>();

    StatisticsState statisticsState = _statisticsBloc.state;

    if (statisticsState is StatisticsSuccess) {
      if (!statisticsState.hasReachedMaxMap[widget.statId]) {
        _statisticsBloc.add(
          StatisticsFetch(
            tautulliId: widget.tautulliId,
            statId: widget.statId,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(StringMapperHelper.mapStatIdToTitle(widget.statId)),
      ),
      body: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsSuccess) {
            List<Statistics> statisticList = state.map[widget.statId];
            bool hasReachedMax = state.hasReachedMaxMap[widget.statId];

            return Scrollbar(
              child: ListView.builder(
                itemCount: hasReachedMax
                    ? statisticList.length
                    : statisticList.length + 1,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (index >= statisticList.length) {
                    return BottomLoader();
                  }

                  final Statistics stat = statisticList[index];
                  if (widget.statId == 'top_platforms') {
                    return IconCard(
                      assetPath: AssetMapperHelper.mapPlatformToPath(
                          stat.platformName),
                      backgroundColor: TautulliColorPalette.mapPlatformToColor(
                          stat.platformName),
                      details: StatisticsDetails(statistic: stat),
                    );
                  } else if (widget.statId == 'top_users') {
                    return UserCard(
                      userThumb: stat.userThumb,
                      details: StatisticsDetails(statistic: stat),
                    );
                  } else if (widget.statId == 'most_concurrent') {
                    return IconCard(
                      assetPath: 'assets/icons/concurrent.svg',
                      details: StatisticsDetails(statistic: stat),
                    );
                  } else {
                    return PosterCard(
                      item: stat,
                      details: StatisticsDetails(statistic: stat),
                    );
                  }
                },
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _statisticsBloc.add(
        StatisticsFetch(
          tautulliId: widget.tautulliId,
          statId: widget.statId,
        ),
      );
    }
  }
}