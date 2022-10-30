import 'package:flutter/material.dart';

import '../../../../core/widgets/poster_card.dart';
import '../../../media/data/models/media_model.dart';
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
        final media = MediaModel(
          grandparentRatingKey: recentlyAdded.grandparentRatingKey,
          grandparentTitle: recentlyAdded.grandparentTitle,
          imageUri: recentlyAdded.posterUri,
          // live: recentlyAdded.live,
          mediaIndex: recentlyAdded.mediaIndex,
          mediaType: recentlyAdded.mediaType,
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
              media: media,
            ),
          ),
        );
      },
      mediaType: recentlyAdded.mediaType,
      uri: recentlyAdded.posterUri,
      details: RecentlyAddedCardDetails(recentlyAdded: recentlyAdded),
    );
  }
}
