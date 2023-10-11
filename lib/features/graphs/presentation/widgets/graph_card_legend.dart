import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../../../core/types/theme_type.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/domain/usecases/settings.dart';
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Wrap(
        runAlignment: WrapAlignment.center,
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Gap(4),
                  const Text(LocaleKeys.tv_title).tr(),
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const Gap(4),
                  const Text(LocaleKeys.movies_title).tr(),
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
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const Gap(4),
                  const Text(LocaleKeys.music_title).tr(),
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
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const Gap(4),
                  const Text(LocaleKeys.live_tv_title).tr(),
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Gap(4),
                  const Text(LocaleKeys.direct_play_title).tr(),
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const Gap(4),
                  const Text(LocaleKeys.direct_stream_title).tr(),
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
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const Gap(4),
                  const Text(LocaleKeys.transcode_title).tr(),
                ],
              ),
            ),
          if (seriesTypes.contains(GraphSeriesType.concurrent))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidCircle,
                    size: 12,
                    color: di.sl<Settings>().getTheme() == ThemeType.tautulli ? PlexColorPalette.seaGreen : Theme.of(context).colorScheme.secondary,
                  ),
                  const Gap(4),
                  const Text(LocaleKeys.max_concurrent_title).tr(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
