// @dart=2.9

import 'package:equatable/equatable.dart';

class MediaItem extends Equatable {
  final String grandparentTitle;
  final int mediaIndex;
  final String mediaType;
  final int parentMediaIndex;
  final String parentTitle;
  final String posterUrl;
  final int ratingKey;
  final int syncId;
  final String title;
  final int year;

  MediaItem({
    this.grandparentTitle,
    this.mediaIndex,
    this.mediaType,
    this.parentMediaIndex,
    this.parentTitle,
    this.posterUrl,
    this.ratingKey,
    this.syncId,
    this.title,
    this.year,
  });

  @override
  List<Object> get props => [
        grandparentTitle,
        mediaIndex,
        mediaType,
        parentMediaIndex,
        parentTitle,
        posterUrl,
        ratingKey,
        syncId,
        title,
        year,
      ];

  @override
  bool get stringify => true;
}
