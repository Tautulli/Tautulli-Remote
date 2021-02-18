import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/domain/entities/server.dart';
import '../../../../injection_container.dart' as di;
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/library.dart';
import '../bloc/library_media_bloc.dart';
import '../widgets/libraries_history_tab.dart';
import '../widgets/libraries_media_tab.dart';

class LibraryDetailsPage extends StatelessWidget {
  final Library library;
  final int ratingKey;
  final String sectionType;
  final String title;

  const LibraryDetailsPage({
    this.library,
    this.ratingKey,
    this.sectionType,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LibraryMediaBloc>(),
      child: LibraryDetailsPageContent(
        library: library,
        ratingKey: ratingKey,
        title: title,
        sectionType: sectionType,
      ),
    );
  }
}

class LibraryDetailsPageContent extends StatefulWidget {
  final Library library;
  final int ratingKey;
  final String sectionType;
  final String title;

  const LibraryDetailsPageContent({
    this.library,
    this.ratingKey,
    this.sectionType,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  _LibraryDetailsPageContentState createState() =>
      _LibraryDetailsPageContentState();
}

class _LibraryDetailsPageContentState extends State<LibraryDetailsPageContent> {
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
    return DefaultTabController(
      length: widget.sectionType == 'photo' ? 1 : 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(widget.title ?? widget.library.sectionName),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                child: Text('Media'),
              ),
              if (widget.sectionType != 'photo')
                Tab(
                  child: Text('History'),
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LibrariesMediaTab(
              library: widget.library,
              sectionType: widget.sectionType,
              title: widget.title,
            ),
            if (widget.sectionType != 'photo')
              LibrariesHistoryTab(
                sectionId: widget.library.sectionId,
              ),
          ],
        ),
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
