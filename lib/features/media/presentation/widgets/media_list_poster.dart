import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/poster.dart';

class MediaListPoster extends StatelessWidget {
  final String? title;
  final int? year;
  final int? ratingKey;
  final MediaType? mediaType;
  final Uri? posterUri;
  final Function()? onTap;

  const MediaListPoster({
    super.key,
    this.title,
    this.year,
    this.ratingKey,
    required this.mediaType,
    this.posterUri,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: Poster(
              heroTag: ratingKey,
              mediaType: mediaType,
              uri: Uri.tryParse(posterUri.toString()),
            ),
          ),
          if (mediaType == MediaType.photoAlbum)
            Positioned(
              top: 4,
              right: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      color: Colors.black54,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Opacity(
                          opacity: 0.8,
                          child: FaIcon(
                            FontAwesomeIcons.solidFolderOpen,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (mediaType == MediaType.clip)
            Positioned(
              top: 4,
              right: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      color: Colors.black54,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Opacity(
                          opacity: 0.8,
                          child: FaIcon(
                            FontAwesomeIcons.video,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          //* Gradient layer to make text visible
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Colors.transparent,
                    Colors.black,
                  ],
                  stops: [
                    mediaType == MediaType.album && year != null
                        ? 0.5
                        : [
                            MediaType.artist,
                            MediaType.track,
                            MediaType.playlist,
                            MediaType.photo,
                            MediaType.photoAlbum,
                          ].contains(mediaType)
                            ? 0.7
                            : 0.8,
                    1,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (year != null && mediaType == MediaType.album)
                    Text(
                      year.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
    );
  }
}
