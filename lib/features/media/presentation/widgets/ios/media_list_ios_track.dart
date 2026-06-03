import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/widgets/ios/cupertino_card.dart';
import '../../../data/models/media_model.dart';

class MediaListIosTrack extends StatelessWidget {
  final MediaModel track;
  final Function()? onTap;

  const MediaListIosTrack({
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
        child: GestureDetector(
          onTap: onTap,
          child: CupertinoCard(
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
        ),
      ),
    );
  }
}
