import 'package:flutter/material.dart';

import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../media/presentation/pages/media_page.dart';
import '../../data/models/recently_added_model.dart';
import 'recently_added_card_details.dart';

class RecentlyAddedCard extends StatelessWidget {
  final RecentlyAddedModel recentlyAdded;

  const RecentlyAddedCard({
    super.key,
    required this.recentlyAdded,
  });

  @override
  Widget build(BuildContext context) {
    return PosterCard(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MediaPage(
              mediaType: recentlyAdded.mediaType!,
              title: _buildTitle(recentlyAdded),
              subtitle: _buildSubtitle(recentlyAdded),
              itemDetail: _buildItemDetail(recentlyAdded),
              ratingKey: recentlyAdded.ratingKey!,
              posterUri: recentlyAdded.posterUri,
            ),
          ),
        );
      },
      mediaType: recentlyAdded.mediaType,
      uri: recentlyAdded.posterUri,
      details: RecentlyAddedCardDetails(recentlyAdded: recentlyAdded),
    );
  }

  String? _buildTitle(RecentlyAddedModel model) {
    if (model.mediaType == MediaType.season) return model.parentTitle;

    if (model.mediaType == MediaType.episode) return model.grandparentTitle;

    return model.title;
  }

  Text? _buildSubtitle(RecentlyAddedModel model) {
    if ([MediaType.season, MediaType.episode].contains(model.mediaType)) return Text(model.title ?? '');

    if (model.mediaType == MediaType.album) return Text(model.parentTitle ?? '');

    if ([
          MediaType.movie,
          MediaType.show,
        ].contains(model.mediaType) &&
        model.year != null) {
      return Text(model.year.toString());
    }

    return null;
  }

  Text? _buildItemDetail(RecentlyAddedModel model) {
    if (model.mediaType == MediaType.album) return Text(model.year.toString());

    if (model.mediaType == MediaType.episode) return Text('S${model.parentMediaIndex} • E${model.mediaIndex}');

    return null;
  }
}
