import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/cupertino/cupertino_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/ios/cupertino_refresh_page.dart';
import '../../../../../core/widgets/ios/ios_bottom_loader.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../history/presentation/bloc/individual_history_bloc.dart';
import '../../../../history/presentation/widgets/cupertino/cupertino_style_history_individual_card.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';

class CupertinoStyleMediaHistoryTab extends StatefulWidget {
  final ServerModel server;
  final int ratingKey;
  final MediaType mediaType;
  final Uri? parentPosterUri;

  const CupertinoStyleMediaHistoryTab({
    super.key,
    required this.server,
    required this.ratingKey,
    required this.mediaType,
    required this.parentPosterUri,
  });

  @override
  State<CupertinoStyleMediaHistoryTab> createState() => _CupertinoStyleMediaHistoryTabState();
}

class _CupertinoStyleMediaHistoryTabState extends State<CupertinoStyleMediaHistoryTab> {
  final ScrollController _scrollController = ScrollController();
  Completer<void> _refreshCompleter = Completer<void>();
  late IndividualHistoryBloc _individualHistoryBloc;
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();

    _individualHistoryBloc = context.read<IndividualHistoryBloc>();
    _settingsBloc = context.read<SettingsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: _scrollController,
      child: CupertinoRefreshPage(
        scrollController: _scrollController,
        onRefresh: () {
          _individualHistoryBloc.add(
            IndividualHistoryFetched(
              server: widget.server,
              ratingKey: widget.ratingKey,
              mediaType: widget.mediaType,
              freshFetch: true,
              settingsBloc: _settingsBloc,
            ),
          );

          return _refreshCompleter.future;
        },
        sliver: BlocConsumer<IndividualHistoryBloc, IndividualHistoryState>(
          listener: (context, state) {
            if (state.status != BlocStatus.initial) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            return SliverPadding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
              sliver: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  settingsState as SettingsSuccess;

                  if (state.status == BlocStatus.initial && state.history.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  }

                  if (state.status == BlocStatus.failure) {
                    return SliverFillRemaining(
                      child: CupertinoStyleStatusPage(
                        message: state.message ?? 'Unknown failure.',
                        suggestion: state.suggestion,
                      ),
                    );
                  }

                  if (state.history.isEmpty) {
                    return SliverFillRemaining(
                      child: CupertinoStyleStatusPage(
                        message: LocaleKeys.history_empty_message.tr(),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final itemIndex = index ~/ 2;

                        if (itemIndex >= state.history.length) {
                          return IosBottomLoader(
                            status: state.status,
                            failure: state.failure,
                            message: state.message,
                            suggestion: state.suggestion,
                            onTap: () {
                              _individualHistoryBloc.add(
                                IndividualHistoryFetched(
                                  server: widget.server,
                                  ratingKey: widget.ratingKey,
                                  mediaType: widget.mediaType,
                                  settingsBloc: _settingsBloc,
                                ),
                              );
                            },
                          );
                        }

                        if (index.isEven) {
                          final history = state.history[itemIndex];

                          return CupertinoStyleHistoryIndividualCard(
                            server: widget.server,
                            history: history.copyWith(posterUri: widget.parentPosterUri),
                          );
                        } else {
                          return const Gap(8);
                        }
                      },
                      childCount: state.hasReachedMax || state.status == BlocStatus.initial
                          ? (state.history.length * 2) - 1
                          : (state.history.length * 2) + 1,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
