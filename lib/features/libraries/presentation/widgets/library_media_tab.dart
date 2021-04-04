import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/grid_image_item.dart';
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library.dart';
import '../bloc/library_media_bloc.dart';
import '../pages/library_details_page.dart';
import 'library_media_error_button.dart';

class LibraryMediaTab extends StatefulWidget {
  final String tautulliId;
  final Library library;
  final String sectionType;
  final String title;

  const LibraryMediaTab({
    @required this.tautulliId,
    @required this.library,
    @required this.sectionType,
    @required this.title,
    Key key,
  }) : super(key: key);

  @override
  _LibraryMediaTabState createState() => _LibraryMediaTabState();
}

class _LibraryMediaTabState extends State<LibraryMediaTab> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryMediaBloc, LibraryMediaState>(
      listener: (context, state) {
        if (state is LibraryMediaSuccess) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      builder: (context, state) {
        if (state is LibraryMediaInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is LibraryMediaFailure) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: ErrorMessage(
                      failure: state.failure,
                      message: state.message,
                      suggestion: state.suggestion,
                    ),
                  ),
                  LibraryMediaErrorButton(
                    completer: _refreshCompleter,
                    failure: state.failure,
                    libraryMediaEvent: LibraryMediaFetched(
                      tautulliId: widget.tautulliId,
                      sectionId: widget.library.sectionId,
                      settingsBloc: context.read<SettingsBloc>(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is LibraryMediaSuccess) {
          if (state.libraryMediaList.length > 0) {
            return RefreshIndicator(
              onRefresh: () {
                context.read<LibraryMediaBloc>().add(
                      LibraryMediaFullRefresh(
                        tautulliId: widget.tautulliId,
                        sectionId: widget.library.sectionId,
                      ),
                    );

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: PlexColorPalette.shark,
                    content:
                        Text('Performing a full refresh of library media.'),
                    action: SnackBarAction(
                      label: 'LEARN MORE',
                      onPressed: () async {
                        await launch(
                          'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#library_refresh',
                        );
                      },
                      textColor: TautulliColorPalette.not_white,
                    ),
                  ),
                );

                return _refreshCompleter.future;
              },
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Scrollbar(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: [
                      'artist',
                      'photo',
                    ].contains(widget.library != null
                            ? widget.library.sectionType
                            : widget.sectionType)
                        ? 1
                        : 2 / 3,
                    children: state.libraryMediaList.map((libraryItem) {
                      final Key heroTag = UniqueKey();

                      return PosterGridItem(
                        heroTag: libraryItem.mediaType == 'photo_album'
                            ? heroTag
                            : null,
                        item: libraryItem,
                        onTap: () {
                          if (libraryItem.mediaType == 'photo_album') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LibraryDetailsPage(
                                  title: libraryItem.title,
                                  ratingKey: libraryItem.ratingKey,
                                  sectionType: 'photo',
                                  backgroundUrlOverride: libraryItem.posterUrl,
                                  disableStatsTab: true,
                                  heroTag: heroTag,
                                ),
                              ),
                            );
                          } else {
                            MediaItem mediaItem = MediaItem(
                              parentMediaIndex: libraryItem.parentMediaIndex,
                              parentTitle:
                                  widget.title ?? widget.library.sectionName,
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
                ),
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
