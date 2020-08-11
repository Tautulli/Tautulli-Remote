import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/widgets/poster_chooser.dart';
import '../../domain/entities/recent.dart';
import 'background_image.dart';
import 'recently_added_details.dart';

class RecentlyAddedCard extends StatelessWidget {
  final RecentItem recentItem;

  const RecentlyAddedCard({
    Key key,
    @required this.recentItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(4),
          child: Stack(
            children: [
              BackgroundImage(url: recentItem.posterUrl),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                ),
                child: Row(
                  children: [
                    PosterChooser(item: recentItem),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: RecentlyAddedDetails(recentItem: recentItem),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
