import 'package:flutter/material.dart';

import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/poster.dart';
import '../../../libraries/data/models/library_media_info_model.dart';

class MediaListPoster extends StatelessWidget {
  final LibraryMediaInfoModel libraryMediaInfoModel;
  final MediaType? mediaType;

  const MediaListPoster({
    super.key,
    required this.mediaType,
    required this.libraryMediaInfoModel,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: Poster(
              mediaType: mediaType,
              uri: Uri.tryParse(libraryMediaInfoModel.posterUri.toString()),
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
                    [
                      MediaType.album,
                      MediaType.artist,
                      MediaType.track,
                      MediaType.playlist,
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
              child: Text(
                libraryMediaInfoModel.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}