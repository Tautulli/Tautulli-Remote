import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/poster.dart';
import '../../../libraries/data/models/library_media_info_model.dart';

class MediaListPoster extends StatelessWidget {
  final LibraryMediaInfoModel libraryMediaInfoModel;
  final MediaType? mediaType;
  final Function()? onTap;
  final bool squarePosterFitCover;

  const MediaListPoster({
    super.key,
    required this.mediaType,
    required this.libraryMediaInfoModel,
    this.onTap,
    this.squarePosterFitCover = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: Poster(
              heroTag: libraryMediaInfoModel.ratingKey,
              mediaType: mediaType,
              uri: Uri.tryParse(libraryMediaInfoModel.posterUri.toString()),
            ),
          ),
          if (mediaType == MediaType.photoAlbum)
            const Positioned(
              top: 4,
              right: 4,
              child: Opacity(
                opacity: 0.8,
                child: FaIcon(
                  FontAwesomeIcons.solidFolderOpen,
                ),
              ),
            ),
          //TODO
          //  //* Gradient layer to make text visible
          // Positioned.fill(
          //   child: DecoratedBox(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: const [
          //           Colors.transparent,
          //           Colors.black,
          //         ],
          //         stops: [
          //           [
          //             MediaType.album,
          //             MediaType.artist,
          //             MediaType.track,
          //             MediaType.playlist,
          //             MediaType.photo,
          //             MediaType.photoAlbum,
          //           ].contains(mediaType)
          //               ? 0.7
          //               : 0.8,
          //           1,
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Padding(
          //     padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
          //     child: Text(
          //       libraryMediaInfoModel.title ?? '',
          //       maxLines: 1,
          //       overflow: TextOverflow.ellipsis,
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.black54,
                        width: constraints.maxWidth,
                        height: 20,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              libraryMediaInfoModel.title ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
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
