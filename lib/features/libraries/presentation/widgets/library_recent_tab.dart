// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/inherited_headers.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../media/domain/entities/media_item.dart';
import '../../../media/presentation/pages/media_item_page.dart';
import '../../../recent/presentation/bloc/libraries_recently_added_bloc.dart';
import '../../../recent/presentation/widgets/recently_added_details.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

class LibraryRecentTab extends StatelessWidget {
  final int sectionId;

  const LibraryRecentTab({
    Key key,
    @required this.sectionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LibrariesRecentlyAddedBloc>(),
      child: _LibraryRecentTabContent(
        sectionId: sectionId,
      ),
    );
  }
}

class _LibraryRecentTabContent extends StatefulWidget {
  final int sectionId;

  _LibraryRecentTabContent({
    Key key,
    @required this.sectionId,
  }) : super(key: key);

  @override
  __LibraryRecentTabContentState createState() =>
      __LibraryRecentTabContentState();
}

class __LibraryRecentTabContentState extends State<_LibraryRecentTabContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  SettingsBloc _settingsBloc;
  LibrariesRecentlyAddedBloc _librariesRecentlyAddedBloc;
  String _tautulliId;
  Map<String, String> headerMap = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _settingsBloc = context.read<SettingsBloc>();
    _librariesRecentlyAddedBloc = context.read<LibrariesRecentlyAddedBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      if (settingsState.lastSelectedServer != null) {
        for (Server server in settingsState.serverList) {
          if (server.tautulliId == settingsState.lastSelectedServer) {
            lastSelectedServer = settingsState.lastSelectedServer;

            for (CustomHeaderModel header in server.customHeaders) {
              headerMap[header.key] = header.value;
            }

            break;
          }
        }
      }

      if (lastSelectedServer != null) {
        setState(() {
          _tautulliId = lastSelectedServer;
        });
      } else if (settingsState.serverList.isNotEmpty) {
        setState(() {
          _tautulliId = settingsState.serverList[0].tautulliId;
          for (CustomHeaderModel header
              in settingsState.serverList[0].customHeaders) {
            headerMap[header.key] = header.value;
          }
        });
      } else {
        _tautulliId = null;
      }

      _librariesRecentlyAddedBloc.add(
        LibrariesRecentlyAddedFetch(
          tautulliId: _tautulliId,
          sectionId: widget.sectionId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibrariesRecentlyAddedBloc, LibrariesRecentlyAddedState>(
      builder: (context, state) {
        if (state is LibrariesRecentlyAddedSuccess) {
          return InheritedHeaders(
            headerMap: headerMap,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Scrollbar(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final heroTag = UniqueKey();

                    return index >= state.list.length
                        ? BottomLoader()
                        : GestureDetector(
                            onTap: () {
                              final recentItem = state.list[index];

                              MediaItem mediaItem = MediaItem(
                                grandparentTitle: recentItem.grandparentTitle,
                                parentMediaIndex: recentItem.parentMediaIndex,
                                mediaIndex: recentItem.mediaIndex,
                                mediaType: recentItem.mediaType,
                                parentTitle: recentItem.parentTitle,
                                posterUrl: recentItem.posterUrl,
                                ratingKey: recentItem.ratingKey,
                                title: recentItem.title,
                                year: recentItem.year,
                              );

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MediaItemPage(
                                    item: mediaItem,
                                    heroTag: heroTag,
                                    enableNavOptions: true,
                                  ),
                                ),
                              );
                            },
                            child: PosterCard(
                              heroTag: heroTag,
                              item: state.list[index],
                              details: RecentlyAddedDetails(
                                recentItem: state.list[index],
                              ),
                            ),
                          );
                  },
                  itemCount: state.hasReachedMax
                      ? state.list.length
                      : state.list.length + 1,
                  controller: _scrollController,
                ),
              ),
            ),
          );
        }
        if (state is LibrariesRecentlyAddedFailure) {
          return const Text(
            LocaleKeys.libraries_details_recent_tab_failure,
          ).tr();
        }
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).accentColor,
          ),
        );
      },
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _librariesRecentlyAddedBloc.add(
        LibrariesRecentlyAddedFetch(
          tautulliId: _tautulliId,
          sectionId: widget.sectionId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }
}
