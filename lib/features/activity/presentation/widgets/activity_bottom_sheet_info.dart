import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/media_type.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/activity_model.dart';

class ActivityBottomSheetInfo extends StatelessWidget {
  final ActivityModel activity;

  const ActivityBottomSheetInfo({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleRow(activity),
        if ([MediaType.episode, MediaType.track, MediaType.clip].contains(activity.mediaType)) SubtitleRow(activity),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return ItemDetailsRow(
              activity,
              dateFormat: state.appSettings.activeServer.dateFormat,
            );
          },
        ),
      ],
    );
  }
}

class TitleRow extends StatelessWidget {
  final ActivityModel activity;

  const TitleRow(
    this.activity, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int? maxLines;
    String text;

    switch (activity.mediaType) {
      case (MediaType.episode):
        maxLines = 1;
        text = activity.grandparentTitle ?? '';
        break;
      case (MediaType.movie):
        maxLines = 3;
        text = activity.title ?? '';
        break;
      default:
        maxLines = 2;
        text = activity.title ?? '';
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
  final ActivityModel activity;
  final int? maxLines;

  const SubtitleRow(
    this.activity, {
    super.key,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    int? lines;
    String text;

    switch (activity.mediaType) {
      case (MediaType.episode):
        lines = 2;
        text = activity.title ?? '';
        break;
      case (MediaType.movie):
        lines = 1;
        text = activity.year.toString();
        break;
      case (MediaType.clip):
        lines = 1;
        text = '(${activity.subType})';
        break;
      default:
        lines = 1;
        text = activity.grandparentTitle ?? '';
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
  final ActivityModel activity;
  final String? dateFormat;

  const ItemDetailsRow(
    this.activity, {
    super.key,
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final mediaType = activity.mediaType;

    if (mediaType == MediaType.movie && activity.year != null) {
      return Text(
        activity.year.toString(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.episode &&
        activity.live == true &&
        activity.mediaIndex == null &&
        activity.originallyAvailableAt != null) {
      return Text(
        TimeHelper.cleanDateTime(
          activity.originallyAvailableAt!,
          dateOnly: true,
          dateFormat: dateFormat,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.episode && (activity.parentMediaIndex != null || activity.mediaIndex != null)) {
      return Text(
        '${activity.parentMediaIndex != null ? "S${activity.parentMediaIndex}" : ""}${activity.parentMediaIndex != null && activity.mediaIndex != null ? " • " : ""}${activity.mediaIndex != null ? "E${activity.mediaIndex}" : ""}',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    if (mediaType == MediaType.track) {
      return Text(
        activity.parentTitle ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    return const SizedBox(height: 0, width: 0);
  }
}
