import 'package:flutter/material.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../media/data/models/media_model.dart';
import '../../../media/presentation/pages/media_page.dart';
import '../../data/models/recently_added_model.dart';
import 'recently_added_card_details.dart';

class RecentlyAddedCard extends StatelessWidget {
  final ServerModel server;
  final RecentlyAddedModel recentlyAdded;

  const RecentlyAddedCard({
    super.key,
    required this.server,
    required this.recentlyAdded,
  });

  @override
  Widget build(BuildContext context) {
    Uri? posterUri;

    switch (recentlyAdded.mediaType) {
      case (MediaType.episode):
        posterUri = recentlyAdded.grandparentPosterUri ?? recentlyAdded.posterUri;
        break;
      case (MediaType.track):
        posterUri = recentlyAdded.parentPosterUri;
        break;
      default:
        posterUri = recentlyAdded.posterUri;
    }

    return PosterCard(
      onTap: () async {
        final media = MediaModel(
          grandparentImageUri: recentlyAdded.grandparentPosterUri,
          grandparentRatingKey: recentlyAdded.grandparentRatingKey,
          grandparentTitle: recentlyAdded.grandparentTitle,
          imageUri: recentlyAdded.posterUri,
          // live: recentlyAdded.live,
          mediaIndex: recentlyAdded.mediaIndex,
          mediaType: recentlyAdded.mediaType,
          parentImageUri: recentlyAdded.parentPosterUri,
          parentMediaIndex: recentlyAdded.parentMediaIndex,
          parentRatingKey: recentlyAdded.parentRatingKey,
          parentTitle: recentlyAdded.parentTitle,
          ratingKey: recentlyAdded.ratingKey,
          title: recentlyAdded.title,
          year: recentlyAdded.year,
        );

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MediaPage(
              server: server,
              media: media,
              parentPosterUri: media.parentImageUri,
            ),
          ),
        );
      },
      mediaType: recentlyAdded.mediaType,
      uri: posterUri,
      details: RecentlyAddedCardDetails(recentlyAdded: recentlyAdded),
    );
  }
}
