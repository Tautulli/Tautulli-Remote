import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../domain/entities/graph_state.dart';

class GraphCard extends StatelessWidget {
  final Widget chart;
  final GraphCurrentState graphCurrentState;
  final double maxYLines;
  final bool showTvLegend;
  final bool showMoviesLegend;
  final bool showMusicLegend;
  final bool showLiveTvLegend;

  const GraphCard({
    Key key,
    @required this.chart,
    @required this.graphCurrentState,
    @required this.maxYLines,
    this.showTvLegend = true,
    this.showMoviesLegend = true,
    this.showMusicLegend = true,
    this.showLiveTvLegend = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 275,
          color: TautulliColorPalette.gunmetal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 12,
                    left: 4,
                    bottom: graphCurrentState != GraphCurrentState.inProgress
                        ? 8
                        : 0,
                    right: 12,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: maxYLines < 1 || maxYLines.isNaN
                            ? const Center(
                                child: Text(
                                  'No plays for the selected time range',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : chart,
                      ),
                      const SizedBox(height: 4),
                      _GraphLegend(
                        showTvLegend: showTvLegend,
                        showMoviesLegend: showMoviesLegend,
                        showMusicLegend: showMusicLegend,
                        showLiveTvLegend: showLiveTvLegend,
                      ),
                    ],
                  ),
                ),
              ),
              graphCurrentState == GraphCurrentState.inProgress
                  ? const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: LinearProgressIndicator(
                        minHeight: 2,
                        backgroundColor: Colors.transparent,
                      ),
                    )
                  : const SizedBox(height: 0, width: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _GraphLegend extends StatelessWidget {
  final bool showTvLegend;
  final bool showMoviesLegend;
  final bool showMusicLegend;
  final bool showLiveTvLegend;

  const _GraphLegend({
    Key key,
    @required this.showTvLegend,
    @required this.showMoviesLegend,
    @required this.showMusicLegend,
    @required this.showLiveTvLegend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showTvLegend)
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.solidCircle,
                color: TautulliColorPalette.amber,
                size: 12,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text('TV'),
              ),
              if (showMoviesLegend || showMusicLegend || showLiveTvLegend)
                const SizedBox(width: 8),
            ],
          ),
        if (showMoviesLegend)
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.solidCircle,
                color: TautulliColorPalette.not_white,
                size: 12,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text('Movies'),
              ),
              if (showMusicLegend || showLiveTvLegend) const SizedBox(width: 8),
            ],
          ),
        if (showMusicLegend)
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.solidCircle,
                color: PlexColorPalette.cinnabar,
                size: 12,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text('Music'),
              ),
              if (showLiveTvLegend) const SizedBox(width: 8),
            ],
          ),
        if (showLiveTvLegend)
          Row(
            children: const [
              FaIcon(
                FontAwesomeIcons.solidCircle,
                color: PlexColorPalette.curious_blue,
                size: 12,
              ),
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text('Live TV'),
              ),
            ],
          ),
      ],
    );
  }
}
