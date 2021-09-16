// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/domain/entities/server.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/inherited_headers.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../injection_container.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../history/presentation/bloc/history_libraries_bloc.dart';
import '../../../history/presentation/widgets/history_details.dart';
import '../../../history/presentation/widgets/history_modal_bottom_sheet.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

class LibraryHistoryTab extends StatelessWidget {
  final int sectionId;

  const LibraryHistoryTab({
    @required this.sectionId,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HistoryLibrariesBloc>(),
      child: _LibraryHistoryTabContent(
        sectionId: sectionId,
      ),
    );
  }
}

class _LibraryHistoryTabContent extends StatefulWidget {
  final int sectionId;

  _LibraryHistoryTabContent({
    @required this.sectionId,
    Key key,
  }) : super(key: key);

  @override
  __LibraryHistoryTabContentState createState() =>
      __LibraryHistoryTabContentState();
}

class __LibraryHistoryTabContentState extends State<_LibraryHistoryTabContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  SettingsBloc _settingsBloc;
  HistoryLibrariesBloc _historyLibrariesBloc;
  String _tautulliId;
  bool _maskSensitiveInfo;
  Map<String, String> headerMap = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _settingsBloc = context.read<SettingsBloc>();
    _historyLibrariesBloc = context.read<HistoryLibrariesBloc>();

    final settingsState = _settingsBloc.state;

    if (settingsState is SettingsLoadSuccess) {
      String lastSelectedServer;

      _maskSensitiveInfo = settingsState.maskSensitiveInfo;

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

      _historyLibrariesBloc.add(
        HistoryLibrariesFetch(
          tautulliId: _tautulliId,
          sectionId: widget.sectionId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryLibrariesBloc, HistoryLibrariesState>(
      builder: (context, state) {
        if (state is HistoryLibrariesFailure) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ErrorMessage(
                failure: state.failure,
                message: state.message,
                suggestion: state.suggestion,
              ),
            ],
          );
        }
        if (state is HistoryLibrariesSuccess) {
          final SettingsLoadSuccess settingsState = _settingsBloc.state;
          final server = settingsState.serverList.firstWhere(
            (server) => server.tautulliId == _tautulliId,
          );

          return state.list.isEmpty
              ? Center(
                  child: const Text(LocaleKeys.history_empty).tr(),
                )
              : InheritedHeaders(
                  headerMap: headerMap,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: state.hasReachedMax
                            ? state.list.length
                            : state.list.length + 1,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          final SettingsLoadSuccess settingsState =
                              _settingsBloc.state;

                          return index >= state.list.length
                              ? BottomLoader()
                              : GestureDetector(
                                  onTap: () {
                                    return showModalBottomSheet(
                                      context: context,
                                      barrierColor: Colors.black87,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (context) => BlocBuilder<
                                          SettingsBloc, SettingsState>(
                                        builder: (context, settingsState) {
                                          return HistoryModalBottomSheet(
                                            item: state.list[index],
                                            server: server,
                                            maskSensitiveInfo: settingsState
                                                    is SettingsLoadSuccess
                                                ? settingsState
                                                    .maskSensitiveInfo
                                                : false,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: PosterCard(
                                    item: state.list[index],
                                    details: HistoryDetails(
                                      historyItem: state.list[index],
                                      server:
                                          settingsState.serverList.firstWhere(
                                        (server) =>
                                            server.tautulliId == _tautulliId,
                                      ),
                                      maskSensitiveInfo: _maskSensitiveInfo,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).accentColor,
          ),
        );
      },
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
      _historyLibrariesBloc.add(
        HistoryLibrariesFetch(
          tautulliId: _tautulliId,
          sectionId: widget.sectionId,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }
}
