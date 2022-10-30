import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MediaListTrack extends StatelessWidget {
  final String? title;
  final int? mediaIndex;
  final Uri? thumbUri;
  final Function()? onTap;

  const MediaListTrack({
    super.key,
    this.title,
    this.mediaIndex,
    this.thumbUri,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).textScaleFactor > 1 ? 50 * MediaQuery.of(context).textScaleFactor : 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Card(
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      if (mediaIndex != null) Text('$mediaIndex.'),
                      const Gap(2),
                      Expanded(
                        child: Text(
                          title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
