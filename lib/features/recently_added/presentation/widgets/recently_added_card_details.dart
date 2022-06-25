import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/media_type_icon.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/recently_added_model.dart';

class RecentlyAddedCardDetails extends StatelessWidget {
  final RecentlyAddedModel recentlyAdded;

  const RecentlyAddedCardDetails({
    super.key,
    required this.recentlyAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TitleRow(recentlyAdded: recentlyAdded),
              _SubtitleRow(recentlyAdded: recentlyAdded),
              if ([
                MediaType.episode,
                MediaType.track,
                MediaType.episode,
                MediaType.album,
              ].contains(recentlyAdded.mediaType))
                _ItemDetailsRow(recentlyAdded: recentlyAdded),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${LocaleKeys.added_title.tr()} ${TimeHelper.moment(recentlyAdded.addedAt)}',
              overflow: TextOverflow.ellipsis,
            ),
            MediaTypeIcon(mediaType: recentlyAdded.mediaType),
          ],
        ),
      ],
    );
  }
}

class _TitleRow extends StatelessWidget {
  final RecentlyAddedModel recentlyAdded;

  const _TitleRow({
    required this.recentlyAdded,
  });

  @override
  Widget build(BuildContext context) {
    String? text;

    switch (recentlyAdded.mediaType) {
      case (MediaType.movie):
      case (MediaType.show):
        text = recentlyAdded.title;
        break;
      case (MediaType.season):
      case (MediaType.album):
        text = recentlyAdded.parentTitle;
        break;
      case (MediaType.episode):
      case (MediaType.track):
        text = recentlyAdded.grandparentTitle;
        break;

      default:
        text = null;
    }

    return Text(
      text ?? 'Unknown',
      overflow: TextOverflow.ellipsis,
      maxLines: [
        MediaType.movie,
        MediaType.season,
      ].contains(recentlyAdded.mediaType)
          ? 2
          : 1,
      style: const TextStyle(
        fontSize: 17,
      ),
    );
  }
}

class _SubtitleRow extends StatelessWidget {
  final RecentlyAddedModel recentlyAdded;

  const _SubtitleRow({
    required this.recentlyAdded,
  });

  @override
  Widget build(BuildContext context) {
    String? text;

    switch (recentlyAdded.mediaType) {
      case (MediaType.movie):
        text = recentlyAdded.year.toString();
        break;
      case (MediaType.episode):
      case (MediaType.season):
      case (MediaType.album):
        text = recentlyAdded.title;
        break;
      case (MediaType.track):
        text = recentlyAdded.parentTitle;
        break;
      case (MediaType.show):
        text = '${recentlyAdded.childCount} ${LocaleKeys.seasons.tr()}';
        break;
      default:
        text = null;
    }

    return Text(
      text ?? 'Unknown',
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ItemDetailsRow extends StatelessWidget {
  final RecentlyAddedModel recentlyAdded;

  const _ItemDetailsRow({
    required this.recentlyAdded,
  });

  @override
  Widget build(BuildContext context) {
    String? text;

    switch (recentlyAdded.mediaType) {
      // case (MediaType.movie):
      // case (MediaType.season):
      // case (MediaType.show):
      //   text = '';
      //   break;
      case (MediaType.episode):
        text =
            'S${recentlyAdded.parentMediaIndex} • E${recentlyAdded.mediaIndex}';
        break;
      case (MediaType.track):
        text = recentlyAdded.parentTitle;
        break;
      case (MediaType.album):
        text = recentlyAdded.year.toString();
        break;
      default:
        text = null;
    }

    return Text(
      text ?? 'Unknown',
      overflow: TextOverflow.ellipsis,
    );
  }
}
