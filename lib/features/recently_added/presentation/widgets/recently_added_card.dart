import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/poster_card.dart';
import '../../../../translations/locale_keys.g.dart';
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
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              LocaleKeys.feature_not_yet_available_snackbar_message,
            ).tr(),
          ),
        );
      },
      mediaType: recentlyAdded.mediaType,
      uri: recentlyAdded.posterUri,
      details: RecentlyAddedCardDetails(recentlyAdded: recentlyAdded),
    );
  }
}
