import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/pages/material/material_style_status_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/material/material_style_bottom_loader.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/material/material_style_refresh_indicator.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../history/presentation/bloc/individual_history_bloc.dart';
import '../../../../history/presentation/widgets/material/material_style_history_individual_card.dart';

class MaterialStyleMediaHistoryTab extends StatefulWidget {
  final ServerModel server;
  final int ratingKey;
  final MediaType mediaType;
  final Uri? parentPosterUri;

  const MaterialStyleMediaHistoryTab({
    super.key,
    required this.server,
    required this.ratingKey,
    required this.mediaType,
    required this.parentPosterUri,
  });

  @override
  State<MaterialStyleMediaHistoryTab> createState() => _MaterialStyleMediaHistoryTabState();
}

class _MaterialStyleMediaHistoryTabState extends State<MaterialStyleMediaHistoryTab> {
  ScrollController? _scrollController;
  late IndividualHistoryBloc _individualHistoryBloc;

  @override
  void initState() {
    super.initState();

    _individualHistoryBloc = context.read<IndividualHistoryBloc>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newController = PrimaryScrollController.of(context);
    if (newController != _scrollController) {
      _scrollController?.removeListener(_onScroll);
      _scrollController = newController;
      _scrollController!.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<IndividualHistoryBloc, IndividualHistoryState>(
      builder: (context, state) {
        return MaterialStyleRefreshIndicator(
          onRefresh: () {
            _individualHistoryBloc.add(
              IndividualHistoryFetched(
                server: widget.server,
                ratingKey: widget.ratingKey,
                mediaType: widget.mediaType,
                freshFetch: true,
              ),
            );

            return Future.value();
          },
          child: MaterialStylePageBody(
            loading: state.status == BlocStatus.initial,
            child: Builder(
              builder: (context) {
                if (state.status == BlocStatus.failure) {
                  return MaterialStyleStatusPage(
                    scrollable: true,
                    message: state.message ?? '',
                    suggestion: state.suggestion ?? '',
                  );
                }

                if (state.history.isEmpty) {
                  return MaterialStyleStatusPage(
                    scrollable: true,
                    message: LocaleKeys.history_empty_message.tr(),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.hasReachedMax || state.status == BlocStatus.initial
                      ? state.history.length
                      : state.history.length + 1,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    if (index >= state.history.length) {
                      return MaterialStyleBottomLoader(
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
                            ),
                          );
                        },
                      );
                    }

                    final history = state.history[index];

                    return MaterialStyleHistoryIndividualCard(
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


  void _onScroll() {
    if (_isBottom) {
      _individualHistoryBloc.add(
        IndividualHistoryFetched(
          server: widget.server,
          ratingKey: widget.ratingKey,
          mediaType: widget.mediaType,
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
