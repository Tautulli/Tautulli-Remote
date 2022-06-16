import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../data/models/graph_data_model.dart';
import '../../data/models/graph_series_data_model.dart';

class GraphCardLegend extends StatelessWidget {
  final GraphDataModel graphData;

  const GraphCardLegend({
    super.key,
    required this.graphData,
  });

  @override
  Widget build(BuildContext context) {
    List<GraphSeriesType> seriesTypes = [];
    for (GraphSeriesDataModel seriesDataModel in graphData.seriesDataList) {
      seriesTypes.add(seriesDataModel.seriesType);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (seriesTypes.contains(GraphSeriesType.tv))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 12,
                  color: PlexColorPalette.gamboge,
                ),
                Gap(4),
                Text('TV'),
              ],
            ),
          ),
        if (seriesTypes.contains(GraphSeriesType.movies))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 12,
                  color: TautulliColorPalette.notWhite,
                ),
                Gap(4),
                Text('Movies'),
              ],
            ),
          ),
        if (seriesTypes.contains(GraphSeriesType.music))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 12,
                  color: PlexColorPalette.cinnabar,
                ),
                Gap(4),
                Text('Music'),
              ],
            ),
          ),
        if (seriesTypes.contains(GraphSeriesType.live))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 12,
                  color: PlexColorPalette.curiousBlue,
                ),
                Gap(4),
                Text('Live TV'),
              ],
            ),
          ),
        if (seriesTypes.contains(GraphSeriesType.directPlay))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 12,
                  color: PlexColorPalette.gamboge,
                ),
                Gap(4),
                Text('Direct Play'),
              ],
            ),
          ),
        if (seriesTypes.contains(GraphSeriesType.directStream))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 12,
                  color: TautulliColorPalette.notWhite,
                ),
                Gap(4),
                Text('Direct Stream'),
              ],
            ),
          ),
        if (seriesTypes.contains(GraphSeriesType.transcode))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 12,
                  color: PlexColorPalette.cinnabar,
                ),
                Gap(4),
                Text('Transcode'),
              ],
            ),
          ),
      ],
    );
  }
}
