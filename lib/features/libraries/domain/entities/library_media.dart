// @dart=2.9

import 'package:equatable/equatable.dart';

class LibraryMedia extends Equatable {
  final int mediaIndex;
  final String mediaType;
  final int parentMediaIndex;
  final int ratingKey;
  final String thumb;
  final String title;
  final int year;
  final String posterUrl;

  LibraryMedia({
    this.mediaIndex,
    this.mediaType,
    this.parentMediaIndex,
    this.ratingKey,
    this.thumb,
    this.title,
    this.year,
    this.posterUrl,
  });

  LibraryMedia copyWith({
    String posterUrl,
  }) {
    return LibraryMedia(
      mediaIndex: this.mediaIndex,
      mediaType: this.mediaType,
      parentMediaIndex: this.parentMediaIndex,
      ratingKey: this.ratingKey,
      thumb: this.thumb,
      title: this.title,
      year: this.year,
      posterUrl: posterUrl,
    );
  }

  @override
  List<Object> get props => [
        mediaIndex,
        mediaType,
        parentMediaIndex,
        ratingKey,
        thumb,
        title,
        year,
        posterUrl,
      ];

  @override
  bool get stringify => true;
}
