import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/grid_image_item.dart';
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../domain/entities/library.dart';
import '../bloc/library_media_bloc.dart';
import '../pages/library_details_page.dart';

class LibrariesMediaTab extends StatelessWidget {
  final Library library;
  final String sectionType;
  final String title;

  const LibrariesMediaTab({
    @required this.library,
    @required this.sectionType,
    @required this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryMediaBloc, LibraryMediaState>(
      builder: (context, state) {
        if (state is LibraryMediaInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is LibraryMediaFailure) {
          return Center(
            child: ErrorMessage(
              failure: state.failure,
              message: state.message,
              suggestion: state.suggestion,
            ),
          );
        }
        if (state is LibraryMediaSuccess) {
          if (state.libraryMediaList.length > 0) {
            return Scrollbar(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: [
                  'artist',
                  'photo',
                ].contains(library != null ? library.sectionType : sectionType)
                    ? 1
                    : 2 / 3,
                children: state.libraryMediaList.map((libraryItem) {
                  return PosterGridItem(
                    item: libraryItem,
                    onTap: () {
                      if (libraryItem.mediaType == 'photo_album') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LibraryDetailsPage(
                              title: libraryItem.title,
                              ratingKey: libraryItem.ratingKey,
                              sectionType: 'photo',
                            ),
                          ),
                        );
                      } else {
                        MediaItem mediaItem = MediaItem(
                          parentMediaIndex: libraryItem.parentMediaIndex,
                          parentTitle: title ?? library.sectionName,
                          mediaIndex: libraryItem.mediaIndex,
                          mediaType: libraryItem.mediaType,
                          posterUrl: libraryItem.posterUrl,
                          ratingKey: libraryItem.ratingKey,
                          title: libraryItem.title,
                          year: libraryItem.year,
                        );

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MediaItemPage(
                              item: mediaItem,
                              heroTag: libraryItem.ratingKey,
                            ),
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            );
          } else {
            return Expanded(
              child: Center(
                child: Text(
                  'No items found.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
        }
        return SizedBox(height: 0, width: 0);
      },
    );
  }
}
