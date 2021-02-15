import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';

import '../../domain/entities/media_item.dart';
import '../../domain/entities/metadata_item.dart';
import '../bloc/metadata_bloc.dart';

class MediaItemH3 extends StatelessWidget {
  final MediaItem item;

  const MediaItemH3({
    @required this.item,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool titleEmpty = ((item.mediaType == 'episode' &&
            (item.parentMediaIndex == null || item.mediaIndex == null)) ||
        (item.mediaType == 'album' && item.year == null) ||
        (item.mediaType == 'track' && isEmpty(item.parentTitle)));

    return !titleEmpty && item.mediaType != null
        ? _HeadingText(item: item)
        : BlocBuilder<MetadataBloc, MetadataState>(
            builder: (context, state) {
              if (state is MetadataFailure) {
                return Text('');
              }
              if (state is MetadataSuccess) {
                return _HeadingText(
                  item: item,
                  metadata: state.metadata,
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              );
            },
          );
  }
}

class _HeadingText extends StatelessWidget {
  final MediaItem item;
  final MetadataItem metadata;

  const _HeadingText({
    @required this.item,
    this.metadata,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = 'UNKNOWN MEDIA TYPE';

    String parentTitle = item.parentTitle;
    int parentMediaIndex = item.parentMediaIndex;
    int mediaIndex = item.mediaIndex;
    int year = item.year;
    String mediaType = item.mediaType;

    if (metadata != null) {
      parentTitle = metadata.parentTitle;
      parentMediaIndex = metadata.parentMediaIndex;
      mediaIndex = metadata.mediaIndex;
      year = metadata.year;
      mediaType = metadata.mediaType;
    }

    switch (mediaType) {
      case 'episode':
        text = 'S$parentMediaIndex • E$mediaIndex';
        break;
      case 'album':
        text = year.toString();
        break;
      case 'track':
        text = parentTitle;
        break;
      case 'season':
      case 'movie':
      case 'show':
      case 'artist':
      case 'photo':
      case 'clip':
        text = '';
    }

    return Padding(
      padding: EdgeInsets.only(
        top: ['movie', 'season', 'show'].contains(mediaType) ? 0 : 5,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
