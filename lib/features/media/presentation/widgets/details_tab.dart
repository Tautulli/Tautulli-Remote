import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';

import '../../../../core/helpers/time_format_helper.dart';
import '../../../../core/widgets/error_message.dart';
import '../../domain/entities/metadata_item.dart';
import '../bloc/metadata_bloc.dart';

class DetailsTab extends StatelessWidget {
  const DetailsTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetadataBloc, MetadataState>(
      builder: (context, state) {
        if (state is MetadataFailure) {
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
        if (state is MetadataSuccess) {
          return _TabContent(metadata: state.metadata);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class _TabContent extends StatelessWidget {
  final MetadataItem metadata;

  const _TabContent({
    @required this.metadata,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedOriginallyAvailableAt;
    if (isNotEmpty(metadata.originallyAvailableAt)) {
      formattedOriginallyAvailableAt = DateFormat.yMMMMd()
          .format(DateTime.parse(metadata.originallyAvailableAt))
          .toString();
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (metadata.tagline.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  metadata.tagline,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (metadata.summary.isNotEmpty)
              Text(
                metadata.summary,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            if (metadata.summary.isNotEmpty) Divider(),
            if (isNotEmpty(metadata.studio))
              _ItemRow(
                title: 'STUDIO',
                item: [metadata.studio],
              ),
            if (metadata.mediaType == 'show' &&
                isNotEmpty(metadata.year.toString()))
              _ItemRow(
                title: 'AIRED',
                item: [metadata.year.toString()],
              ),
            if (metadata.mediaType == 'episode' &&
                isNotEmpty(formattedOriginallyAvailableAt))
              _ItemRow(
                title: 'AIRED',
                item: [formattedOriginallyAvailableAt],
              ),
            if (metadata.duration != null)
              _ItemRow(
                title: 'RUNTIME',
                item: [
                  metadata.duration != null
                      ? TimeFormatHelper.pretty(metadata.duration ~/ 1000)
                      : null
                ],
              ),
            if (metadata.contentRating.isNotEmpty)
              _ItemRow(
                title: 'RATED',
                item: [metadata.contentRating],
              ),
            if (metadata.genres.isNotEmpty)
              _ItemRow(
                title: 'GENRES',
                item: metadata.genres,
              ),
            if (metadata.directors.isNotEmpty)
              _ItemRow(
                title: 'DIRECTED BY',
                item: metadata.directors,
              ),
            if (metadata.writers.isNotEmpty)
              _ItemRow(
                title: 'WRITTEN BY',
                item: metadata.writers,
              ),
            if (metadata.actors.isNotEmpty)
              _ItemRow(
                title: 'STARRING',
                item: metadata.actors,
              ),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String title;
  final List item;

  const _ItemRow({
    @required this.title,
    @required this.item,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.isNotEmpty && isNotBlank(item[0]))
                  Text(
                    item.take(5).join(', '),
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
