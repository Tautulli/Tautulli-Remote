import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../injection_container.dart' as di;
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library.dart';
import '../bloc/library_media_bloc.dart';
import '../widgets/library_item_details.dart';

class LibraryItemsPage extends StatelessWidget {
  final Library library;
  final int ratingKey;
  final String title;

  const LibraryItemsPage({
    this.library,
    this.ratingKey,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LibraryMediaBloc>(),
      child: LibraryItemsPageContent(
        library: library,
        ratingKey: ratingKey,
        title: title,
      ),
    );
  }
}

class LibraryItemsPageContent extends StatefulWidget {
  final Library library;
  final int ratingKey;
  final String title;

  const LibraryItemsPageContent({
    this.library,
    this.ratingKey,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  _LibraryItemsPageContentState createState() =>
      _LibraryItemsPageContentState();
}

class _LibraryItemsPageContentState extends State<LibraryItemsPageContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  SettingsBloc _settingsBloc;
  LibraryMediaBloc _libraryMediaBloc;
  String _tautulliId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _settingsBloc = context.read<SettingsBloc>();
    _libraryMediaBloc = context.read<LibraryMediaBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;
            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingsState.serverList.length > 0) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
        });
      } else {
        _tautulliId = null;
      }

      _libraryMediaBloc.add(
        LibraryMediaFetched(
          tautulliId: _tautulliId,
          sectionId: widget.library != null ? widget.library.sectionId : null,
          ratingKey: widget.ratingKey,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.title ?? widget.library.sectionName),
      ),
      body: BlocBuilder<LibraryMediaBloc, LibraryMediaState>(
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
                child: ListView.builder(
                  itemCount: state.libraryMediaList.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final heroTag = UniqueKey();

                    return GestureDetector(
                      onTap: () {
                        if (state.libraryMediaList[index].mediaType ==
                            'photo_album') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LibraryItemsPage(
                                title: state.libraryMediaList[index].title,
                                ratingKey:
                                    state.libraryMediaList[index].ratingKey,
                              ),
                            ),
                          );
                        } else if (state.libraryMediaList[index].mediaType !=
                            'photo') {
                          final libraryItem = state.libraryMediaList[index];

                          MediaItem mediaItem = MediaItem(
                            parentMediaIndex: libraryItem.parentMediaIndex,
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
                                heroTag: heroTag,
                              ),
                            ),
                          );
                        }
                      },
                      child: PosterCard(
                        heroTag: heroTag,
                        item: state.libraryMediaList[index],
                        details: LibraryItemDetails(
                          item: state.libraryMediaList[index],
                        ),
                      ),
                    );
                  },
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _libraryMediaBloc.add(
        LibraryMediaFetched(
          tautulliId: _tautulliId,
          sectionId: widget.library != null ? widget.library.sectionId : null,
          ratingKey: widget.ratingKey,
        ),
      );
    }
  }
}
