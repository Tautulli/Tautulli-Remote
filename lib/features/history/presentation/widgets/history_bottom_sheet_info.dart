import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/history_model.dart';

class HistoryBottomSheetInfo extends StatelessWidget {
  final HistoryModel history;

  const HistoryBottomSheetInfo({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleRow(history),
        if (history.mediaType == MediaType.episode ||
            history.mediaType == MediaType.track)
          SubtitleRow(history),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return ItemDetailsRow(
              history,
              dateFormat: state.appSettings.activeServer.dateFormat,
            );
          },
        ),
      ],
    );
  }
}

class TitleRow extends StatelessWidget {
  final HistoryModel history;

  const TitleRow(
    this.history, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int? maxLines;
    String text;

    switch (history.mediaType) {
      case (MediaType.episode):
        maxLines = 1;
        text = history.grandparentTitle ?? '';
        break;
      case (MediaType.movie):
        maxLines = 3;
        text = history.title ?? '';
        break;
      default:
        maxLines = 2;
        text = history.title ?? '';
    }

    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 17,
      ),
    );
  }
}

class SubtitleRow extends StatelessWidget {
  final HistoryModel history;
  final int? maxLines;

  const SubtitleRow(
    this.history, {
    super.key,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    int? lines;
    String text;

    switch (history.mediaType) {
      case (MediaType.episode):
        lines = 2;
        text = history.title ?? '';
        break;
      default:
        lines = 1;
        text = history.grandparentTitle ?? '';
        break;
    }

    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines ?? lines,
    );
  }
}

class ItemDetailsRow extends StatelessWidget {
  final HistoryModel history;
  final String? dateFormat;

  const ItemDetailsRow(
    this.history, {
    super.key,
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final mediaType = history.mediaType;

    if (mediaType == MediaType.movie && history.year != null) {
      return Text(
        history.year.toString(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.episode &&
        history.live == true &&
        history.mediaIndex == null) {
      return Text(
        TimeHelper.cleanDateTime(
          history.date!,
          dateOnly: true,
          dateFormat: dateFormat,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.episode &&
        (history.parentMediaIndex != null || history.mediaIndex != null)) {
      return Text(
        '${history.parentMediaIndex != null ? "S${history.parentMediaIndex}" : ""}${history.parentMediaIndex != null && history.mediaIndex != null ? " • " : ""}${history.mediaIndex != null ? "E${history.mediaIndex}" : ""}',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.track) {
      return Text(
        history.parentTitle ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    return const SizedBox(height: 0, width: 0);
  }
}
