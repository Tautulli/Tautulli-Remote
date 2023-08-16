import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/media_type.dart';
import '../../../../core/widgets/bottom_loader.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../history/presentation/bloc/individual_history_bloc.dart';
import '../../../history/presentation/widgets/history_individual_card.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

class MediaHistoryTab extends StatefulWidget {
  final ServerModel server;
  final int ratingKey;
  final MediaType mediaType;
  final Uri? parentPosterUri;

  const MediaHistoryTab({
    super.key,
    required this.server,
    required this.ratingKey,
    required this.mediaType,
    required this.parentPosterUri,
  });

  @override
  State<MediaHistoryTab> createState() => _MediaHistoryTabState();
}

class _MediaHistoryTabState extends State<MediaHistoryTab> {
  ScrollController? _scrollController;
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
    // Only attach scrollController if it's currently null
    if (_scrollController == null) {
      _scrollController = PrimaryScrollController.of(context);
      _scrollController!.addListener(_onScroll);
    }

    return BlocBuilder<IndividualHistoryBloc, IndividualHistoryState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
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

            return Future.value();
          },
          child: PageBody(
            loading: state.status == BlocStatus.initial,
            child: Builder(
              builder: (context) {
                if (state.status == BlocStatus.failure) {
                  return StatusPage(
                    scrollable: true,
                    message: state.message ?? '',
                    suggestion: state.suggestion ?? '',
                  );
                }

                if (state.history.isEmpty) {
                  return StatusPage(
                    scrollable: true,
                    message: LocaleKeys.history_empty_message.tr(),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.hasReachedMax || state.status == BlocStatus.initial ? state.history.length : state.history.length + 1,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    if (index >= state.history.length) {
                      return BottomLoader(
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

                    final history = state.history[index];

                    return HistoryIndividualCard(
                      server: widget.server,
                      history: history.copyWith(posterUri: widget.parentPosterUri),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController!.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _individualHistoryBloc.add(
        IndividualHistoryFetched(
          server: widget.server,
          ratingKey: widget.ratingKey,
          mediaType: widget.mediaType,
          settingsBloc: _settingsBloc,
        ),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController!.hasClients) return false;
    final maxScroll = _scrollController!.position.maxScrollExtent;
    final currentScroll = _scrollController!.offset;
    return currentScroll >= (maxScroll * 0.95);
  }
}
