// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../domain/entities/graph_state.dart';

class GraphCard extends StatelessWidget {
  final Widget chart;
  final GraphCurrentState graphCurrentState;
  final double maxYLines;
  final bool showTvLegend;
  final bool showMoviesLegend;
  final bool showMusicLegend;
  final bool showLiveTvLegend;
  final bool showDirectPlayLegend;
  final bool showDirectStreamLegend;
  final bool showTranscodeLegend;
  final double spaceAboveLegend;

  const GraphCard({
    Key key,
    @required this.chart,
    @required this.graphCurrentState,
    @required this.maxYLines,
    @required this.spaceAboveLegend,
    this.showTvLegend = true,
    this.showMoviesLegend = true,
    this.showMusicLegend = true,
    this.showLiveTvLegend = true,
    this.showDirectPlayLegend = false,
    this.showDirectStreamLegend = false,
    this.showTranscodeLegend = false,
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
                            ? Center(
                                child: const Text(
                                  LocaleKeys.graphs_no_plays,
                                  style: TextStyle(color: Colors.grey),
                                ).tr(),
                              )
                            : chart,
                      ),
                      SizedBox(height: spaceAboveLegend),
                      _GraphLegend(
                        showTvLegend: showTvLegend,
                        showMoviesLegend: showMoviesLegend,
                        showMusicLegend: showMusicLegend,
                        showLiveTvLegend: showLiveTvLegend,
                        showDirectPlayLegend: showDirectPlayLegend,
                        showDirectStreamLegend: showDirectStreamLegend,
                        showTranscodeLegend: showTranscodeLegend,
                      ),
                    ],
                  ),
                ),
              ),
              graphCurrentState == GraphCurrentState.inProgress
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: LinearProgressIndicator(
                        minHeight: 2,
                        color: Theme.of(context).accentColor,
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
  final bool showDirectPlayLegend;
  final bool showDirectStreamLegend;
  final bool showTranscodeLegend;

  const _GraphLegend({
    Key key,
    @required this.showTvLegend,
    @required this.showMoviesLegend,
    @required this.showMusicLegend,
    @required this.showLiveTvLegend,
    @required this.showDirectPlayLegend,
    @required this.showDirectStreamLegend,
    @required this.showTranscodeLegend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showTvLegend || showDirectPlayLegend)
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.solidCircle,
                color: TautulliColorPalette.amber,
                size: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  showTvLegend
                      ? LocaleKeys.general_tv
                      : LocaleKeys.media_details_direct_play,
                ).tr(),
              ),
              if (showMoviesLegend ||
                  showMusicLegend ||
                  showLiveTvLegend ||
                  showDirectStreamLegend ||
                  showTranscodeLegend)
                const SizedBox(width: 8),
            ],
          ),
        if (showMoviesLegend || showDirectStreamLegend)
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.solidCircle,
                color: TautulliColorPalette.not_white,
                size: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  showMoviesLegend
                      ? LocaleKeys.general_movies
                      : LocaleKeys.media_details_direct_stream,
                ).tr(),
              ),
              if (showMusicLegend || showLiveTvLegend || showTranscodeLegend)
                const SizedBox(width: 8),
            ],
          ),
        if (showMusicLegend || showTranscodeLegend)
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.solidCircle,
                color: PlexColorPalette.cinnabar,
                size: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  showMusicLegend
                      ? LocaleKeys.general_music
                      : LocaleKeys.media_details_transcode,
                ).tr(),
              ),
              if (showLiveTvLegend) const SizedBox(width: 8),
            ],
          ),
        if (showLiveTvLegend)
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.solidCircle,
                color: PlexColorPalette.curious_blue,
                size: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: const Text(LocaleKeys.general_live_tv).tr(),
              ),
            ],
          ),
      ],
    );
  }
}
