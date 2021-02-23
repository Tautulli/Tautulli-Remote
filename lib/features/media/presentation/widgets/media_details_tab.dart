import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';

import '../../../../core/helpers/clean_data_helper.dart';
import '../../../../core/helpers/data_unit_format_helper.dart';
import '../../../../core/helpers/string_format_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../../../core/widgets/error_message.dart';
import '../../domain/entities/metadata_item.dart';
import '../bloc/metadata_bloc.dart';

class MediaDetailsTab extends StatelessWidget {
  const MediaDetailsTab({Key key}) : super(key: key);

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
    String formattedFullVideoResolution;

    if (isNotEmpty(metadata.originallyAvailableAt)) {
      formattedOriginallyAvailableAt = DateFormat.yMMMMd()
          .format(DateTime.parse(metadata.originallyAvailableAt))
          .toString();
    }
    if (isNotEmpty(metadata.videoFullResolution)) {
      formattedFullVideoResolution = metadata.videoFullResolution.contains('k')
          ? metadata.videoFullResolution.toUpperCase()
          : metadata.videoFullResolution;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNotEmpty(metadata.tagline))
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
            if (isNotEmpty(metadata.summary))
              Text(
                metadata.summary,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            if (isNotEmpty(metadata.summary))
              Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                  bottom: 2,
                ),
                child: Divider(
                  color: Colors.grey,
                  indent: MediaQuery.of(context).size.width / 3,
                  endIndent: MediaQuery.of(context).size.width / 3,
                ),
              ),
            if (metadata.childrenCount != null &&
                isNotEmpty(metadata.subMediaType))
              _ItemRow(
                title: 'ITEMS',
                item: [
                  '${metadata.childrenCount} ${StringFormatHelper.capitalize(metadata.subMediaType)}${(metadata.childrenCount > 1 ? "s" : "")}'
                ],
              ),
            if (metadata.childrenCount != null &&
                isNotEmpty(metadata.playlistType))
              _ItemRow(
                title: 'ITEMS',
                item: [
                  '${metadata.childrenCount} ${StringFormatHelper.capitalize(metadata.playlistType)}${(metadata.childrenCount > 1 ? "s" : "")}'
                ],
              ),
            if (metadata.minYear != null && metadata.maxYear != null)
              _ItemRow(
                title: 'YEAR',
                item: ['${metadata.minYear} - ${metadata.maxYear}'],
              ),
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
            if ([
                  'episode',
                  'photo',
                  'clip',
                ].contains(metadata.mediaType) &&
                isNotEmpty(formattedOriginallyAvailableAt))
              _ItemRow(
                title: metadata.mediaType == 'episode' ? 'AIRED' : 'TAKEN',
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
            if (isNotEmpty(metadata.contentRating))
              _ItemRow(
                title: 'RATED',
                item: [metadata.contentRating],
              ),
            if (metadata.genres != null && metadata.genres.isNotEmpty)
              _ItemRow(
                title: 'GENRES',
                item: metadata.genres,
              ),
            if (metadata.directors != null && metadata.directors.isNotEmpty)
              _ItemRow(
                title: 'DIRECTED BY',
                item: metadata.directors,
              ),
            if (metadata.writers != null && metadata.writers.isNotEmpty)
              _ItemRow(
                title: 'WRITTEN BY',
                item: metadata.writers,
              ),
            if (metadata.genres != null && metadata.actors.isNotEmpty)
              _ItemRow(
                title: 'STARRING',
                item: metadata.actors,
              ),
            if (isNotEmpty(metadata.container) ||
                isNotEmpty(formattedFullVideoResolution) ||
                metadata.audioChannels != null ||
                metadata.bitrate != null ||
                metadata.fileSize != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                  bottom: 2,
                ),
                child: Divider(
                  color: Colors.grey,
                  indent: MediaQuery.of(context).size.width / 3,
                  endIndent: MediaQuery.of(context).size.width / 3,
                ),
              ),
            if (isNotEmpty(metadata.container))
              _ItemRow(
                title: 'CONTAINER',
                item: [metadata.container.toUpperCase()],
              ),
            if (isNotEmpty(formattedFullVideoResolution))
              _ItemRow(
                title: 'VIDEO',
                item: [
                  '$formattedFullVideoResolution (${metadata.videoCodec.toUpperCase()})'
                ],
              ),
            if (metadata.audioChannels != null)
              _ItemRow(
                title: 'AUDIO',
                item: [
                  '${MediaFlagsCleaner.audioChannels(metadata.audioChannels.toString())} (${metadata.audioCodec.toUpperCase()})'
                ],
              ),
            if (metadata.bitrate != null)
              _ItemRow(
                title: 'BITRATE',
                item: [DataUnitFormatHelper.bitrate(metadata.bitrate)],
              ),
            if (metadata.fileSize != null)
              _ItemRow(
                title: 'FILE SIZE',
                item: [DataUnitFormatHelper.prettyFilesize(metadata.fileSize)],
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
