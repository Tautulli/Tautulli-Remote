import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../core/widgets/card_with_forced_tint.dart';
import '../../data/models/media_model.dart';

class MediaListTrack extends StatelessWidget {
  final MediaModel track;
  final Function()? onTap;

  const MediaListTrack({
    super.key,
    required this.track,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).textScaler.scale(1) > 1 ? 50 * MediaQuery.of(context).textScaler.scale(1) : 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CardWithForcedTint(
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      if (track.mediaIndex != null) Text('${track.mediaIndex}.'),
                      if (track.mediaIndex != null) const Gap(2),
                      Expanded(
                        child: Text(
                          track.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        TimeHelper.hourMinSec(track.duration ?? Duration.zero),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
