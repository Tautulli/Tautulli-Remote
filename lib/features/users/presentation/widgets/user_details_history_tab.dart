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
import '../../../history/presentation/bloc/history_individual_bloc.dart';
import '../../../history/presentation/widgets/history_details.dart';
import '../../../history/presentation/widgets/history_modal_bottom_sheet.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../domain/entities/user_table.dart';

class UserDetailsHistoryTab extends StatelessWidget {
  final UserTable user;

  const UserDetailsHistoryTab({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HistoryIndividualBloc>(),
      child: UserDetailsHistoryTabContent(
        user: user,
      ),
    );
  }
}

class UserDetailsHistoryTabContent extends StatefulWidget {
  final UserTable user;

  UserDetailsHistoryTabContent({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _UserDetailsHistoryTabContentState createState() =>
      _UserDetailsHistoryTabContentState();
}

class _UserDetailsHistoryTabContentState
    extends State<UserDetailsHistoryTabContent> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  SettingsBloc _settingsBloc;
  HistoryIndividualBloc _historyIndividualBloc;
  String _tautulliId;
  bool _maskSensitiveInfo;
  Map<String, String> headerMap = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _settingsBloc = context.read<SettingsBloc>();
    _historyIndividualBloc = context.read<HistoryIndividualBloc>();

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

      _historyIndividualBloc.add(
        HistoryIndividualFetch(
          tautulliId: _tautulliId,
          userId: widget.user.userId,
          getImages: true,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryIndividualBloc, HistoryIndividualState>(
      builder: (context, state) {
        if (state is HistoryIndividualFailure) {
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
        if (state is HistoryIndividualSuccess) {
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
                                            disableUserButton: true,
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
      _historyIndividualBloc.add(
        HistoryIndividualFetch(
          tautulliId: _tautulliId,
          userId: widget.user.userId,
          getImages: true,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }
}
